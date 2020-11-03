import {JSONRequest} from './types';

const SNAKE_CASE_MATCH = /_\w/g;
const snakeToCamel = (str: string) =>
    str.replace(SNAKE_CASE_MATCH, (chars: string) => chars[1].toUpperCase());

const transformKeysSnakeToCamel = <T extends { [key: string]: any } = {}>(
    obj: T
) =>
    Object.keys(obj).reduce((memo, key) => {
        let newValue = obj[key];
        const camelKey = snakeToCamel(key);

        if (
            newValue &&
            typeof newValue === 'object' &&
            !Array.isArray(newValue)
        ) {
            newValue = transformKeysSnakeToCamel(newValue);
        }

        return {
            ...memo,
            [camelKey]: newValue,
        };
    }, {}) as T;

/**
 * Returns a function that sends a request, and transforms its results
 */
const makeJsonRequest = <T>(
    request: JSONRequest,
    transformers: Array<(obj: T) => T>
) => (url: string, options?: RequestInit) =>
        request(url, options).then((response: T) =>
            transformers.reduce<T>((acc, transformer) => {
                let memo = acc;

                memo = transformer(response);
                return memo;
            }, response)
        );

/**
 * Base API class for creating new API Classes.
 * Also encapsulates default transformers such as snake to camel.
 */
export abstract class BaseApi<T> {
    request: JSONRequest<T>;

    constructor(req: JSONRequest<T>) {
        this.request = makeJsonRequest(req, [transformKeysSnakeToCamel]);
    }
}
