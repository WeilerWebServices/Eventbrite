const baseConfig = require('./jest-base.config.js');

module.exports = Object.assign({}, baseConfig, {
    runner: 'jest-runner-tsc',
    displayName: 'tsc',
    testMatch: ['<rootDir>/src/**/*.(ts|js)'],
});
