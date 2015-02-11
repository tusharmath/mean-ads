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
		.then (@style) =>

	onCampaignSelect: () =>
		if @subscription.campaign
			@_loadCampaign()
			.then @_loadProgram
			.then @_loadStyle
	removeEmail: (email) =>
		_.remove @subscription.emailAccess, (s) ->s is email
	addEmail: =>
		if @newEmailAccess
			@subscription.emailAccess.push @newEmailAccess
			@newEmailAccess = ''
	removeKeyword: (keyword) ->
		_.remove @subscription.keywords, (s) ->s is keyword
	addKeyword: ->
		@subscription.keywords = [] if not @subscription.keywords
		if @newKeyword
			@subscription.keywords.push @newKeyword
			@newKeyword = null
SubscriptionAlterCtrl.$inject = [
	"Restangular", "AlterControllerExtensionService", '$q'
]
app.controller 'SubscriptionAlterCtrl', SubscriptionAlterCtrl
