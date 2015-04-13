// Generated by CoffeeScript 1.9.1
var ClassProvider, HostNameBuilder, Inject, Url, WindowProvider, annotate, ref;

WindowProvider = require('../providers/WindowProvider');

Url = require('url');

ref = require('di'), annotate = ref.annotate, Inject = ref.Inject, ClassProvider = ref.ClassProvider;

HostNameBuilder = (function() {
  function HostNameBuilder(windowP) {
    this.windowP = windowP;
    this._hostCache = null;
  }

  HostNameBuilder.prototype.setup = function() {
    var g, host;
    if (this._hostCache) {
      return this._hostCache;
    }
    g = this.windowP.window().ma.g;
    if (g) {
      host = Url.parse("http:" + g).host;
      this._hostCache = "" + host;
    } else {
      this._hostCache = 'app.meanads.com';
    }
    return this._hostCache;
  };

  HostNameBuilder.prototype.getHost = function() {};

  HostNameBuilder.prototype.getHostWithProtocol = function() {
    if (!this._hostCache) {
      throw new Error('setup the HostNameBuilder first dude!');
    }
    return (this.windowP.window().location.protocol) + "//" + this._hostCache;
  };

  return HostNameBuilder;

})();

annotate(HostNameBuilder, new ClassProvider);

annotate(HostNameBuilder, new Inject(WindowProvider));

module.exports = HostNameBuilder;
