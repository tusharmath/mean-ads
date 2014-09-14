module.exports = (mongoose) ->
	SubscriptionSchema = new mongoose.Schema
		client:
			type: String
			required: true
		startDate:
			type: Date
			required: true
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
	model = mongoose.model 'Subscription', SubscriptionSchema
