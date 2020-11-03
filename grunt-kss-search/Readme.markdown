# Grunt KSS Search

Grunt Plugin for [KSS Search](https://github.com/eventbrite/kss-search) to build search indexes as part of your grunt build chain.


## Installation

Packing Slip can be installed from npm

    npm install git@github.com:eventbrite/grunt-kss-search.git


## Configuration

Configure the grunt task with the directory with your KSS documented
stylesheets.  You can optionally specify where the generated kss-index.json
file should be placed.

    kss-index: {
        sass: ["src"],
        options: {
            index: "dist/docs/kss-index.json"
        }            
    }


## License

Copyright 2014 Eventbrite

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

See LICENSE.md.
