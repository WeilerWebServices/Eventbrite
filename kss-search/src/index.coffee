fs = require 'fs'

Q = require 'q'
lunr = require 'lunr'
kss = require 'kss'


DEFAULT_INDEX_FILE = "kss-index.json"


class KSSIndex
    DEFAULT_INDEX_FILE: DEFAULT_INDEX_FILE
    constructor: ->
        @index = lunr ->
            @ref 'section'
            @field 'header', boost: 10
            @field 'section', boost: 20
            @field 'description'

    indexSection: (section) ->
        data = section.data
        document =
            section: data.reference
            header: data.header
            description: data.description
        @index.add document
        @index.documents ||= {}
        @index.documents[document.section] = document
        console.log "indexed #{document.section}"

    indexFiles: (path) ->
        console.log path
        Q.nfcall kss.traverse, path, {}
        .then (response) =>
            response.data.sections.forEach (section) =>
                @indexSection section

    search: (query) ->
        @index.search query

    get: (ref) ->
        return @index.documents?[ref]

    save: (destination) ->
        destination = destination or DEFAULT_INDEX_FILE
        output = @index.toJSON()
        output.documents = @index.documents
        Q.nfcall fs.writeFile, destination, JSON.stringify(output)

    @load: (data) ->
        index = new @()
        index.index = lunr.Index.load(data)
        index.index.documents = data.documents
        return index

    @loadFile: (source) ->
        source = source or DEFAULT_INDEX_FILE
        data = JSON.parse(fs.readFileSync source)
        @load data

module.exports = KSSIndex
