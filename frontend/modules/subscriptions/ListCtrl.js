// Generated by CoffeeScript 1.9.1
var SubscriptionCtrl, app;

app = require('../../app');

SubscriptionCtrl = (function() {
  function SubscriptionCtrl(rest, route) {
    route.populate = 'campaign';
    rest.all('subscriptions').getList(route).then((function(_this) {
      return function(subscriptions) {
        _this.subscriptions = subscriptions;
      };
    })(this));
  }

  SubscriptionCtrl.prototype.onInActiveCss = function(subscription) {
    if (subscription.usedCredits >= subscription.totalCredits) {
      return "text-danger";
    } else {
      return "";
    }
  };

  return SubscriptionCtrl;

})();

SubscriptionCtrl.$inject = ['Restangular', '$routeParams'];

app.controller('SubscriptionListCtrl', SubscriptionCtrl);
