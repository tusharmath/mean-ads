// Generated by CoffeeScript 1.9.1
var AjaxPendingRequests, app,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

app = require('./app');

AjaxPendingRequests = (function() {
  function AjaxPendingRequests(q) {
    this.q = q;
    this.onCountChange = bind(this.onCountChange, this);
    this.responseError = bind(this.responseError, this);
    this.response = bind(this.response, this);
    this.request = bind(this.request, this);
    this.xhrCount = 0;
  }

  AjaxPendingRequests.prototype.callback = function() {
    return console.warn('Custom callaback has not been set');
  };

  AjaxPendingRequests.prototype.request = function(config) {
    this.callback(++this.xhrCount);
    return config;
  };

  AjaxPendingRequests.prototype.response = function(response) {
    this.callback(--this.xhrCount);
    return response;
  };

  AjaxPendingRequests.prototype.responseError = function(rejection) {
    this.callback(--this.xhrCount);
    return this.q.reject(rejection);
  };

  AjaxPendingRequests.prototype.onCountChange = function(callback) {
    this.callback = callback;
  };

  return AjaxPendingRequests;

})();

AjaxPendingRequests.$inject = ['$q'];

app.service('AjaxPendingRequests', AjaxPendingRequests);
