/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.facebook.presto.execution.scheduler;

import com.facebook.presto.execution.RemoteTask;
import com.facebook.presto.execution.SqlStageExecution;
import com.facebook.presto.execution.TaskStatus;
import com.facebook.presto.spi.Node;
import com.google.common.collect.ImmutableList;
import com.google.common.util.concurrent.SettableFuture;
import io.airlift.units.DataSize;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.OptionalInt;
import java.util.Set;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.Supplier;

import static com.facebook.presto.execution.scheduler.ScheduleResult.BlockedReason.WRITER_SCALING;
import static com.facebook.presto.spi.StandardErrorCode.NO_NODES_AVAILABLE;
import static com.facebook.presto.util.Failures.checkCondition;
import static java.util.Objects.requireNonNull;
import static java.util.concurrent.TimeUnit.MILLISECONDS;

public class ScaledWriterScheduler
        implements StageScheduler
{
    private interface TaskScheduler
    {
        RemoteTask scheduleTask(Node node, int partition, OptionalInt totalPartitions);
    }

    private final TaskScheduler taskScheduler;
    private final Supplier<Collection<TaskStatus>> sourceTasksProvider;
    private final Supplier<Collection<TaskStatus>> writerTasksProvider;
    private final NodeSelector nodeSelector;
    private final ScheduledExecutorService executor;
    private final long writerMinSizeBytes;
    private final Set<Node> scheduledNodes = new HashSet<>();
    private final AtomicBoolean done = new AtomicBoolean();
    private volatile SettableFuture<?> future = SettableFuture.create();

    public ScaledWriterScheduler(
            SqlStageExecution stage,
            Supplier<Collection<TaskStatus>> sourceTasksProvider,
            Supplier<Collection<TaskStatus>> writerTasksProvider,
            NodeSelector nodeSelector,
            ScheduledExecutorService executor,
            DataSize writerMinSize)
    {
        requireNonNull(stage, "stage is null");
        this.taskScheduler = stage::scheduleTask;
        this.sourceTasksProvider = requireNonNull(sourceTasksProvider, "sourceTasksProvider is null");
        this.writerTasksProvider = requireNonNull(writerTasksProvider, "writerTasksProvider is null");
        this.nodeSelector = requireNonNull(nodeSelector, "nodeSelector is null");
        this.executor = requireNonNull(executor, "executor is null");
        this.writerMinSizeBytes = requireNonNull(writerMinSize, "minWriterSize is null").toBytes();
    }

    public void finish()
    {
        done.set(true);
        future.set(null);
    }

    @Override
    public ScheduleResult schedule()
    {
        List<RemoteTask> writers = scheduleTasks(getNewTaskCount());

        future.set(null);
        future = SettableFuture.create();
        executor.schedule(() -> future.set(null), 200, MILLISECONDS);

        return new ScheduleResult(done.get(), writers, future, WRITER_SCALING, 0);
    }

    private int getNewTaskCount()
    {
        if (scheduledNodes.isEmpty()) {
            return 1;
        }

        double fullTasks = sourceTasksProvider.get().stream()
                .filter(task -> !task.getState().isDone())
                .map(TaskStatus::isOutputBufferOverutilized)
                .mapToDouble(full -> full ? 1.0 : 0.0)
                .average().orElse(0.0);

        long writtenBytes = writerTasksProvider.get().stream()
                .map(TaskStatus::getPhysicalWrittenDataSize)
                .mapToLong(DataSize::toBytes)
                .sum();

        if ((fullTasks >= 0.5) && (writtenBytes >= (writerMinSizeBytes * scheduledNodes.size()))) {
            return 1;
        }

        return 0;
    }

    private List<RemoteTask> scheduleTasks(int count)
    {
        if (count == 0) {
            return ImmutableList.of();
        }

        List<Node> nodes = nodeSelector.selectRandomNodes(count, scheduledNodes);

        checkCondition(!scheduledNodes.isEmpty() || !nodes.isEmpty(), NO_NODES_AVAILABLE, "No nodes available to run query");

        ImmutableList.Builder<RemoteTask> tasks = ImmutableList.builder();
        for (Node node : nodes) {
            tasks.add(taskScheduler.scheduleTask(node, scheduledNodes.size(), OptionalInt.empty()));
            scheduledNodes.add(node);
        }

        return tasks.build();
    }
}