define ["app", "lodash"], (app, _) ->
  class CampaignCreateCtrl
    constructor: (@rest, @loc) ->
      @campaign = {}
      rest.all('programs').getList().then (@programs) =>
    save: () ->
      @campaign.keywords = _.compact @campaign.keywords.split /[\s,.|]/
      @rest
      .all 'campaigns'
      .post @campaign
      .then () => @loc.path '/campaigns'

  CampaignCreateCtrl.$inject = ["Restangular", "$location"]
  app.controller 'CampaignCreateCtrl', CampaignCreateCtrl
