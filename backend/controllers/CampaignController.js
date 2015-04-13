// Generated by CoffeeScript 1.9.1
var BaseController, CampaignController, Dispatcher, Inject, _, annotate, ref,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

_ = require('lodash');

ref = require('di'), Inject = ref.Inject, annotate = ref.annotate;

BaseController = require('./BaseController');

Dispatcher = require('../modules/Dispatcher');

CampaignController = (function() {
  function CampaignController(actions, dispatch) {
    this.actions = actions;
    this.dispatch = dispatch;
    this.postUpdateHook = bind(this.postUpdateHook, this);
    this.actions.resourceName = 'Campaign';
    this.actions.postUpdateHook = this.postUpdateHook;
  }

  CampaignController.prototype.postUpdateHook = function(campaign) {
    return this.dispatch.campaignUpdated(campaign._id).then(function() {
      return campaign;
    });
  };

  return CampaignController;

})();

annotate(CampaignController, new Inject(BaseController, Dispatcher));

module.exports = CampaignController;
