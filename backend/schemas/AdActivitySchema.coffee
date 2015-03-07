AdActivitySchema = (mongoose) ->
	new mongoose.Schema
		userActivity:
			type: mongoose.Schema.ObjectId
			required: true
			ref: 'UserActivity'
			index: true
		subscription:
			type: mongoose.Schema.ObjectId
			required: true
			ref: 'Subscription'
			index: true
		# http://www.psychstat.missouristate.edu/multibook/mlt08m.html
		styleDummyCode:
			type: Number
			required: true
		click:
			type: Boolean
		jSimilarity:
			type: [Number]
		created:
			type: Date
			default: Date.now

module.exports = AdActivitySchema
