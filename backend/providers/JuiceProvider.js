// Generated by CoffeeScript 1.9.1
var JuiceProvider, Q, config, juice;

juice = require('juice');

config = require('../config/config');

Q = require('q');

JuiceProvider = (function() {
  function JuiceProvider() {
    this.options = {
      url: "http://localhost:" + config.port
    };
  }

  JuiceProvider.prototype.juiceContentQ = function(markup) {
    return Q.Promise((function(_this) {
      return function(resolve, reject) {
        return juice.juiceContent(markup, _this.options, function(err, html) {
          if (err) {
            return reject(err);
          }
          return resolve(html);
        });
      };
    })(this));
  };

  return JuiceProvider;

})();

module.exports = JuiceProvider;
