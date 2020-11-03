var DEFAULT_INDEX_FILE, KSSIndex, Q, fs, kss, lunr;

fs = require('fs');

Q = require('q');

lunr = require('lunr');

kss = require('kss');

DEFAULT_INDEX_FILE = "kss-index.json";

KSSIndex = (function() {
  KSSIndex.prototype.DEFAULT_INDEX_FILE = DEFAULT_INDEX_FILE;

  function KSSIndex() {
    this.index = lunr(function() {
      this.ref('section');
      this.field('header', {
        boost: 10
      });
      this.field('section', {
        boost: 20
      });
      return this.field('description');
    });
  }

  KSSIndex.prototype.indexSection = function(section) {
    var data, document, _base;
    data = section.data;
    document = {
      section: data.reference,
      header: data.header,
      description: data.description
    };
    this.index.add(document);
    (_base = this.index).documents || (_base.documents = {});
    this.index.documents[document.section] = document;
    return console.log("indexed " + document.section);
  };

  KSSIndex.prototype.indexFiles = function(path) {
    console.log(path);
    return Q.nfcall(kss.traverse, path, {}).then((function(_this) {
      return function(response) {
        return response.data.sections.forEach(function(section) {
          return _this.indexSection(section);
        });
      };
    })(this));
  };

  KSSIndex.prototype.search = function(query) {
    return this.index.search(query);
  };

  KSSIndex.prototype.get = function(ref) {
    var _ref;
    return (_ref = this.index.documents) != null ? _ref[ref] : void 0;
  };

  KSSIndex.prototype.save = function(destination) {
    var output;
    destination = destination || DEFAULT_INDEX_FILE;
    output = this.index.toJSON();
    output.documents = this.index.documents;
    return Q.nfcall(fs.writeFile, destination, JSON.stringify(output));
  };

  KSSIndex.load = function(data) {
    var index;
    index = new this();
    index.index = lunr.Index.load(data);
    index.index.documents = data.documents;
    return index;
  };

  KSSIndex.loadFile = function(source) {
    var data;
    source = source || DEFAULT_INDEX_FILE;
    data = JSON.parse(fs.readFileSync(source));
    return this.load(data);
  };

  return KSSIndex;

})();

module.exports = KSSIndex;
