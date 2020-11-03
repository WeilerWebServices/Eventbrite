# KSS Search

KSS Search indexes KSS documented stylesheets to provide search capabilities to your Styleguide.

It uses [lunr.js](http://lunrjs.com) to perform the indexing and search
capabilities.  KSS Search will create an index file that can be used to search
for terms in your documentation.

## Installation

Packing Slip can be installed from npm

    npm install -g git@github.com:eventbrite/kss-search.git

## Running

### Indexing

    kss-index <path to your stylesheet files>

### Searching

You can search your KSS index from the command line or integrate with your own search library:

    kss-search "button"

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
