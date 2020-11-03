const baseConfig = require('./jest-base.config.js');

module.exports = Object.assign({}, baseConfig, {
    runner: 'jest-runner-eslint',
    displayName: 'lint',
    testMatch: ['<rootDir>/src/**/*.(ts|js)'],
    watchPlugins: ['jest-runner-eslint/watch-fix'],
});
