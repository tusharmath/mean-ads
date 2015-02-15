app = require '../../app'

class CampaignAlterCtrl
	constructor: (@rest, @alter, @tok) ->

		@alter.bootstrap @, 'campaign'

		@rest.all('programs').getList().then (@programs) =>

	beforeSave: () ->
		@campaign.keywords = @tok.tokenize @campaign.keywords
	addKeyword: () ->
		@campaign.keywordPricing = [] if not @campaign.keywordPricing
		if @keyName and @keyPrice
			@campaign.keywordPricing.push {@keyName, @keyPrice}
		@keyName = @keyPrice = null
	removeKeyword: (keyword) ->
		_.remove @campaign.keywordPricing, (s) -> s is keyword
CampaignAlterCtrl.$inject = [
	"Restangular" , 'AlterControllerExtensionService', 'TokenizerService'
]
app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
