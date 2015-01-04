app = require '../../app'
_ = require 'lodash'
class CampaignAlterCtrl
	constructor: (@rest, @alter, @tok) ->

		@alter.bootstrap @, 'campaign'

		rest.all('programs').getList().then (@programs) =>

	beforeSave: () ->
		@campaign.keywords = @tok.tokenize @campaign.keywords

CampaignAlterCtrl.$inject = [
	"Restangular" , 'AlterControllerExtensionService', 'TokenizerService'
]
app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
