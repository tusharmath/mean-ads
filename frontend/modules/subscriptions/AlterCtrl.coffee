app = require '../../app'


class SubscriptionAlterCtrl

	constructor: (@rest, @alter, @q) ->

		@alter.bootstrap @, 'subscription'

		@rest.all('campaigns').getList().then (@campaigns) =>
			do @onCampaignSelect

	_loadCampaign: =>
		@rest
		.one 'campaign', @subscription.campaign
		.get()

	_loadProgram: (@campaign) =>
		@rest
		.one 'program', @campaign.program
		.get()

	_loadStyle: (@program) =>
		@rest.one 'style', @program.style
		.get()

	_setEstimations: (@style) =>
		@costPerTransaction = @throughput = 0
		_.each @subscription.keywords, (keyName) =>
			keywordPrice = _.find @campaign.keywordPricing, (keywordPrice) ->
				keywordPrice.keyName is keyName
			if keywordPrice
				@costPerTransaction += Number(keywordPrice.keyPrice)
			else
				@costPerTransaction += @campaign.defaultCost or 0
		@costPerTransaction /= @subscription.keywords.length
		@costPerTransaction = Math.round(@costPerTransaction*100)/100
		@throughput = Math.round(@subscription.totalCredits / @costPerTransaction / 10) * 100


	onCampaignSelect: () =>
		if @subscription.campaign
			@_loadCampaign()
			.then @_loadProgram
			.then @_loadStyle
			.then @_setEstimations

	removeEmail: (email) =>
		_.remove @subscription.emailAccess, (s) ->s is email
	addEmail: =>
		if @newEmailAccess
			@subscription.emailAccess.push @newEmailAccess
			@newEmailAccess = ''
	removeKeyword: (keyword) ->
		_.remove @subscription.keywords, (s) ->s is keyword
		@_setEstimations()
	addKeyword: ->
		@subscription.keywords = [] if not @subscription.keywords
		if @newKeyword
			@subscription.keywords.push @newKeyword
			@newKeyword = null
			@_setEstimations()
SubscriptionAlterCtrl.$inject = [
	"Restangular", "AlterControllerExtensionService", '$q'
]
app.controller 'SubscriptionAlterCtrl', SubscriptionAlterCtrl
