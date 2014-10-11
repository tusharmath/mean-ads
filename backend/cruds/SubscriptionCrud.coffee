BaseCrud = require './BaseCrud'

class SubscriptionCrud
	constructor: () ->
	SubscriptionCrud:: = injector.get BaseCrud

module.exports = SubscriptionCrud
