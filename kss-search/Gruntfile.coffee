
module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        clean:
            dist: ['dist/**/*']
        coffee:
            compile:
                expand: true
                options:
                    bare: true
                cwd: "#{__dirname}/src"
                src: ['**/*.coffee']
                dest: 'dist/'
                ext: '.js'
        usebanner:
            executables:
                options:
                    position: 'top'
                    linebreak: true
                    banner: '#!/usr/bin/env node'
                src: [
                    'dist/index-cli.js',
                    'dist/search-cli.js'
                ]
        coffeelint:
            files:
                src: ['src/**/*.coffee']
            options:
                configFile: 'coffeelint.json'

    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-banner'

    grunt.registerTask 'test', ['coffeelint']

    grunt.registerTask 'default', [
        'clean',
        'coffee:compile',
        'usebanner',
    ]
