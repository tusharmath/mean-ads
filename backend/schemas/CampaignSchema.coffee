
CampaignSchema = (mongoose) ->
	SubscriptionSchema = require './SubscriptionSchema'

	new mongoose.Schema
		name:
			type: String
			required: true
		program:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Program'
		days:
			type: Number
			required: true
		keywords:
			type: [String]
		commitment:
			type: Number
		performance:
			type: Number
		isEnabled:
			type: Boolean
			default: true
		subscriptions: [ SubscriptionSchema mongoose ]
module.exports = CampaignSchema
