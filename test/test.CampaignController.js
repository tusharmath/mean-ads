// Generated by CoffeeScript 1.9.1
var BaseController, CampaignController, Injector, MongooseProviderMock;

CampaignController = require('../backend/controllers/CampaignController');

BaseController = require('../backend/controllers/BaseController');

MongooseProviderMock = require('./mocks/MongooseProviderMock');

Injector = require('di').Injector;

describe('CampaignController:', function() {
  beforeEach(function() {
    this.injector = new Injector([MongooseProviderMock]);
    this.mod = this.injector.get(CampaignController);
    return this.mongo = this.injector.getModule('providers.MongooseProvider', {
      mock: false
    });
  });
  afterEach(function() {
    return this.mongo.__reset();
  });
  it("must have actions", function() {
    return this.mod.actions.should.be.an.instanceOf(BaseController);
  });
  return it('sets the post update hook', function() {
    return this.mod.actions.postUpdateHook.should.equal(this.mod.postUpdateHook);
  });
});
