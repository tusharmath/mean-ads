_ = require 'lodash'
BaseController = require './BaseController'

class CampaignController
	constructor: () ->
		@_populate = path: 'program', select: 'name gauge'

module.exports = CampaignController
