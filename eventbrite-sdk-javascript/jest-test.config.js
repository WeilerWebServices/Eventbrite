const baseConfig = require('./jest-base.config.js');

module.exports = Object.assign({}, baseConfig, {
    displayName: 'test',
    testMatch: ['<rootDir>/src/**/*.spec.(ts|js)'],
});
