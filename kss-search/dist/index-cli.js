#!/usr/bin/env node
var KSSIndex, Q, dfr, indexDB, log, packageJSON, path, program, promise;

path = require('path');

Q = require('q');

log = require('verbalize');

program = require('commander');

KSSIndex = require('./index');

packageJSON = require(path.join(__dirname, "..", "package.json"));

program.version(packageJSON.version);

program.description('index kss documented sass stylesheets').option('-index, --index [index]', "output file for the index (defaults to " + KSSIndex.DEFAULT_INDEX_FILE);

program.parse(process.argv);

if (!program.args.length) {
  program.args = ['.'];
}

log.info(program.args);

indexDB = new KSSIndex();

dfr = Q.defer();

promise = dfr.promise;

program.args.forEach(function(source) {
  return promise = promise.then(function() {
    return indexDB.indexFiles(source);
  });
});

promise = promise.then(function() {
  indexDB.save(program.index);
  return console.log("saving " + (program.index || indexDB.DEFAULT_INDEX_FILE));
}).fail(function(err) {
  return log.error(err);
}).done();

dfr.resolve();
