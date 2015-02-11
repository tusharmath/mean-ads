app = require '../../app'

class CampaignAlterCtrl
	constructor: (@rest, @alter, @tok) ->

		@alter.bootstrap @, 'campaign'

		@rest.all('programs').getList().then (@programs) =>

	beforeSave: () ->
		@campaign.keywords = @tok.tokenize @campaign.keywords
	addKeyword: () ->
		@campaign.keywordCost = [] if not @campaign.keywordCost
		if @keyName and @keyCost
			@campaign.keywordCost.push {@keyName, @keyCost}
		@keyName = @keyCost = null
	removeKeyword: (keyword) ->
		_.remove @campaign.keywordCost, (s) -> s is keyword
CampaignAlterCtrl.$inject = [
	"Restangular" , 'AlterControllerExtensionService', 'TokenizerService'
]
app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
