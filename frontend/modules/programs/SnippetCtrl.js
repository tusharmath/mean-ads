// Generated by CoffeeScript 1.9.1
var SnippetCtrl, app;

app = require('../../app');

SnippetCtrl = (function() {
  function SnippetCtrl(rest, route, window) {
    this.rest = rest;
    this.route = route;
    this.window = window;
    this.host = this.window.location.host;
    this.rest.one('program', this.route.id).get().then((function(_this) {
      return function(program) {
        _this.program = program;
      };
    })(this));
  }

  return SnippetCtrl;

})();

SnippetCtrl.$inject = ['Restangular', '$routeParams', '$window'];

app.controller('ProgramSnippetCtrl', SnippetCtrl);
