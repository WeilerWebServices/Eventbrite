(function() {
    'use strict';

    var path = require('path');
    var Q = require('q');
    var KSSIndex = require('kss-search');

    module.exports = function(grunt) {

        grunt.registerMultiTask('kss-index', 'Index KSS documented stylesheets', function() {

            var options = this.options({
                index: null,
                cwd: null
            });

            var indexer = new KSSIndex();
            var dfr = Q.defer();
            var promise = dfr.promise;
            var doneCallback = this.async();

            // Index the KSS Files
            this.filesSrc.forEach(function(file) {
                var base = path.resolve(file);
                promise = promise.then(function() {
                    console.log("indexing " + base);
                    return indexer.indexFiles(base);
                });
            });

            // Save the Index
            promise = promise.then(function() {
                return indexer.save(options.index);
            });

            promise.then(doneCallback, function(err) {
                console.error(err);
                doneCallback(false);
            });
            // Start the grunt task
            dfr.resolve();
        });
    };

}());
