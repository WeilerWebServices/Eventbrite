import {
    mockFetch,
    getMockFetch,
    getMockResponse,
    restoreMockFetch,
} from './utils';
import {
    MOCK_USERS_ME_RESPONSE_DATA,
    MOCK_TRANSFORMED_USERS_ME_RESPONSE_DATA,
} from './__fixtures__';

import request from '../request';
import {UserApi} from '../users';

describe('me()', () => {
    it('calls fetch and calls fetch with appropriate defaults', async() => {
        const users = new UserApi(request);

        mockFetch(getMockResponse(MOCK_USERS_ME_RESPONSE_DATA));

        await expect(users.me()).resolves.toEqual(
            MOCK_TRANSFORMED_USERS_ME_RESPONSE_DATA
        );

        expect(getMockFetch()).toHaveBeenCalledTimes(1);
        expect(getMockFetch()).toHaveBeenCalledWith(
            '/users/me/',
            expect.objectContaining({})
        );

        restoreMockFetch();
    });

    it('handle token missing requests', async() => {
        const users = new UserApi(request);

        mockFetch(
            getMockResponse(
                {
                    status_code: 401,
                    error_description:
                        'An OAuth token is required for all requests',
                    error: 'NO_AUTH',
                },
                {status: 401}
            )
        );

        await expect(users.me()).rejects.toMatchObject({
            response: expect.objectContaining({
                status: 401,
                statusText: 'Unauthorized',
                ok: false,
            }),
            parsedError: {
                description: 'An OAuth token is required for all requests',
                error: 'NO_AUTH',
            },
        });

        restoreMockFetch();
    });
});

describe('get(id)', () => {
    it('calls fetch and calls fetch with appropriate defaults', async() => {
        const users = new UserApi(request);

        mockFetch(getMockResponse(MOCK_USERS_ME_RESPONSE_DATA));

        await expect(users.get('142429416488')).resolves.toEqual(
            MOCK_TRANSFORMED_USERS_ME_RESPONSE_DATA
        );

        expect(getMockFetch()).toHaveBeenCalledTimes(1);
        expect(getMockFetch()).toHaveBeenCalledWith(
            '/users/142429416488/',
            expect.objectContaining({})
        );

        restoreMockFetch();
    });

    it('should handle not found users', async() => {
        const users = new UserApi(request);

        mockFetch(
            getMockResponse(
                {
                    status_code: 404,
                    error_description: 'The user you requested does not exist.',
                    error: 'NOT_FOUND',
                },
                {status: 404}
            )
        );

        await expect(users.get('123')).rejects.toMatchObject({
            response: expect.objectContaining({
                status: 404,
                statusText: 'Not Found',
                ok: false,
            }),
            parsedError: {
                description: 'The user you requested does not exist.',
                error: 'NOT_FOUND',
            },
        });

        restoreMockFetch();
    });
});
