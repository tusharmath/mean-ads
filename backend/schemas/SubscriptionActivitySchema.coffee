SubscriptionActivitySchema = (mongoose) ->
	new mongoose.Schema
		visitor:
			type: String
			required: true
			index: true
		subscription:
			type: mongoose.Schema.ObjectId
			required: true
			ref: 'Subscription'
			index: true
		click:
			type: Boolean
			required: true
			default: false
		query:
			type: String
		created:
			type: Date
			default: Date.now
		depth:
			type: Number
			default: 1
		position:
			type: Number
			default: 0
module.exports = SubscriptionActivitySchema
