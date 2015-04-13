// Generated by CoffeeScript 1.9.1
var StyleAlterCtrl, app;

app = require('../../app');

StyleAlterCtrl = (function() {
  function StyleAlterCtrl(rest, interpolate, alter, tok) {
    this.rest = rest;
    this.interpolate = interpolate;
    this.alter = alter;
    this.tok = tok;
    this.alter.bootstrap(this, 'style');
  }

  StyleAlterCtrl.prototype._getStyleTags = function() {
    return "<style>" + this.style.css + "</style>";
  };

  StyleAlterCtrl.prototype.getRowCount = function(str) {
    return str != null ? str.split('\n').length : void 0;
  };

  StyleAlterCtrl.prototype.beforeSave = function() {
    return this.style.placeholders = this.tok.tokenize(this.style.placeholders);
  };

  return StyleAlterCtrl;

})();

StyleAlterCtrl.$inject = ['Restangular', '$interpolate', 'AlterControllerExtensionService', 'TokenizerService'];

app.controller('StyleAlterCtrl', StyleAlterCtrl);
