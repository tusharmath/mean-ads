_ = require 'lodash'
BaseController = require './BaseController'

class CampaignController
	constructor: () ->
		@_populate = path: 'program', select: 'name'

module.exports = CampaignController
