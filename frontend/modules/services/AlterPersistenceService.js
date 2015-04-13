// Generated by CoffeeScript 1.9.1
var AlterPersistenceService, app;

app = require('../../app');

AlterPersistenceService = (function() {
  function AlterPersistenceService(rest, loc) {
    this.rest = rest;
    this.loc = loc;
  }

  AlterPersistenceService.prototype._update = function(resourceName, resource) {
    return this.rest.one(resourceName, resource._id).patch(resource);
  };

  AlterPersistenceService.prototype._create = function(resourceName, resource) {
    return this.rest.all(resourceName).post(resource);
  };

  AlterPersistenceService.prototype.persist = function(resourceName, resource) {
    var mode;
    mode = resource._id ? 'update' : 'create';
    return this["_" + mode](resourceName, resource).then((function(_this) {
      return function() {
        return _this.loc.path("/" + resourceName + "s");
      };
    })(this));
  };

  AlterPersistenceService.prototype.remove = function(resourceName, resource) {
    return this.rest.one(resourceName, resource._id).remove().then((function(_this) {
      return function() {
        return _this.loc.path("/" + resourceName + "s");
      };
    })(this));
  };

  return AlterPersistenceService;

})();

AlterPersistenceService.$inject = ["Restangular", "$location"];

app.service('AlterPersistenceService', AlterPersistenceService);
