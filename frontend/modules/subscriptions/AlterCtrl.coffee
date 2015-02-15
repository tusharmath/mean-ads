app = require '../../app'


class SubscriptionAlterCtrl

	constructor: (@rest, @alter, @q) ->

		@alter.bootstrap @, 'subscription'
		.then =>
			@subscription.keywords = [] if not @subscription.keywords
		@costPerTransaction = @throughput = 0
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
	_reduceCost: (totalCost, keyName) =>
		return 0 if not @campaign
		keywordPrice = _.find @campaign.keywordPricing, (keywordPrice) =>
			keywordPrice.keyName is keyName
		if keywordPrice
			totalCost += Number(keywordPrice.keyPrice)
		else
			totalCost += @campaign.defaultCost or 0

	# TODO: Reusable logic
	_setEstimations: (@style) =>
		totalCost = _.reduce @subscription.keywords, @_reduceCost, 0
		if totalCost > 0 and  @subscription.keywords.length > 0
			@costPerTransaction = totalCost/@subscription.keywords.length
			@throughput = @subscription.totalCredits / @costPerTransaction
		else
			@costPerTransaction = @throughput = 0

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
			@subscription.emailAccess = [] if not @subscription.email
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
