AdActivitySchema = (mongoose) ->
	new mongoose.Schema
		visitor:
			type: mongoose.Schema.ObjectId
			required: true
			ref: 'Visitor'
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
