BaseCrud = require './BaseCrud'

class CampaignCrud
	constructor: () ->
	CampaignCrud:: = injector.get BaseCrud

module.exports = CampaignCrud
