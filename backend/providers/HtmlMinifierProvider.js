// Generated by CoffeeScript 1.9.1
var HtmlMinifier, HtmlMinifierProvider, config;

HtmlMinifier = require('html-minifier');

config = require('../config/config');

HtmlMinifierProvider = (function() {
  function HtmlMinifierProvider() {}

  HtmlMinifierProvider.prototype.minify = function(html) {
    return HtmlMinifier.minify(html, config.htmlMinify);
  };

  return HtmlMinifierProvider;

})();

module.exports = HtmlMinifierProvider;
