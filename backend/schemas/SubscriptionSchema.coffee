SubscriptionSchema = (mongoose) ->
	new mongoose.Schema
		client:
			type: String
			required: true
		startDate:
			type: Date
			required: true
		endDate:
			type: Date
			require: true
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

		# Faster Querying
		program:
			type: mongoose.Schema.ObjectId
			required: true
			ref: 'Program'
			index: true
		keywords:
			type: [String]
			index: true

		# Delivery Management
		lastDeliveredOn:
			type: Date
			default: Date.now

module.exports = SubscriptionSchema
