// Generated by CoffeeScript 1.9.1
var DbConnection, Inject, MongooseProvider, config;

config = require('../config/config');

MongooseProvider = require('../providers/MongooseProvider');

Inject = require('di').Inject;

DbConnection = (function() {
  function DbConnection(mongooseProvider) {
    var mongoose;
    this.mongooseProvider = mongooseProvider;
    mongoose = this.mongooseProvider.mongoose;
    this._connect = (function(_this) {
      return function() {
        _this.conn = mongoose.createConnection(config.mongo.uri);
        _this.conn.on('open', function() {
          return bragi.log('application:mongo', bragi.util.symbols.success, 'Db Connection established successfully');
        });
        _this.conn.on('error', function() {
          return bragi.log('application:mongo', bragi.util.symbols.error, 'Db Connection could not be established');
        });
        return _this.conn.on('disconnected', function() {
          bragi.log('application:mongo', bragi.util.symbols.error, 'Db Connection got disconnected');
          return setTimeout(_this._connect, config.mongo.options.db.autoConnectIn);
        });
      };
    })(this);
    this._connect();
  }

  return DbConnection;

})();

DbConnection.annotations = [new Inject(MongooseProvider)];

module.exports = DbConnection;
