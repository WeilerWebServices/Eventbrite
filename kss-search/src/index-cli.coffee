path = require 'path'

Q = require 'q'

log = require 'verbalize'
program = require 'commander'

KSSIndex = require './index'


packageJSON = require path.join(__dirname, "..", "package.json")

program
    .version packageJSON.version

program
    .description 'index kss documented sass stylesheets'
    .option '-index, --index [index]', "output file for the index (defaults to #{KSSIndex.DEFAULT_INDEX_FILE}"


program.parse(process.argv)

program.args = ['.'] unless program.args.length

log.info program.args

indexDB = new KSSIndex()
dfr = Q.defer()
promise = dfr.promise

program.args.forEach (source) ->
    promise = promise.then ->
        indexDB.indexFiles source

promise = promise.then ->
    indexDB.save program.index
    console.log "saving #{program.index or indexDB.DEFAULT_INDEX_FILE}"
.fail (err) ->
    log.error err
.done()

dfr.resolve()
