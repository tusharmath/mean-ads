// Generated by CoffeeScript 1.9.1
var ClassProvider, CommandExecutor, ConvertCommand, CreateImageElement, HostNameBuilder, HttpProvider, Inject, annotate, querystring, ref;

querystring = require('querystring');

ref = require('di'), annotate = ref.annotate, Inject = ref.Inject, ClassProvider = ref.ClassProvider;

HttpProvider = require('../sdk/HttpProvider');

CreateImageElement = require('./CreateImageElement');

HostNameBuilder = require('./HostNameBuilder');

CommandExecutor = require('./CommandExecutor');

ConvertCommand = (function() {
  function ConvertCommand(host, exec, img) {
    this.host = host;
    this.exec = exec;
    this.img = img;
    this.exec.register(this);
  }

  ConvertCommand.prototype.alias = 'convert';

  ConvertCommand.prototype._getUrl = function(id) {
    return this.host.getHostWithProtocol() + ("/api/v1/subscription/" + id + "/convert.gif");
  };

  ConvertCommand.prototype.execute = function(subscriptionId) {
    var url;
    if (!subscriptionId) {
      return null;
    }
    url = this._getUrl(subscriptionId);
    return this.img.create(url);
  };

  return ConvertCommand;

})();

annotate(ConvertCommand, new ClassProvider);

annotate(ConvertCommand, new Inject(HostNameBuilder, CommandExecutor, CreateImageElement));

module.exports = ConvertCommand;
