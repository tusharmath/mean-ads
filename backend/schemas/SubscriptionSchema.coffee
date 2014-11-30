SubscriptionSchema = (mongoose) ->
	new mongoose.Schema
		client:
			type: String
			required: true
		startDate:
			type: Date
			required: true
			default: Date.now
		campaign:
			type : mongoose.Schema.ObjectId
			required: true
			ref : 'Campaign'
		totalCredits:
			type : Number
			required: true
		usedCredits:
			type : Number
			required: true
			default: 0
		created:
			type: Date
			default: Date.now
		data:
			type: mongoose.Schema.Types.Mixed
			require: true
		owner:
			type: String
			required: true
			index: true

module.exports = SubscriptionSchema
