"use strict";

var yeoman = require("yeoman-generator");
var helpers = require("yeoman-test");
var P = require("bluebird");
var R = require("ramda");
var path = require("path");
var caches = [];
var id, cache;

beforeEach(function () {
  caches.push(R.evolve({}, require.cache));
  for (id in require.cache) {
    delete require.cache[id];
  }
});

afterEach(function () {
  for (id in require.cache) {
    delete require.cache[id];
  }
  cache = caches.pop();
  for (id in cache) {
    var parts = path.parse(id);
    require.cache[path.join(parts.root, id.substr(parts.root.length))] = cache[id];
  }
});

var yostart = yeoman.Base.extend({
  prompting: function () {
    var self = this;
    var done = self.async();
    return new P(function (resolve) {
      self.prompt({}, resolve);
    }).then(function (answers) {
      self.props = answers;
    }).then(done).catch(done);
  },
  writing: function () {
    this.fs.copyTpl(
      this.templatePath("foo"),
      this.destinationPath("foo"),
      this.props
    );
  }
});

it("the it", function () {
  return new P(function () {
    return helpers.run(yostart);
  });
});
