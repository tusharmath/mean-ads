SubscriptionSchema = (mongoose) ->
	schema = new mongoose.Schema
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
			index: true
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
		owner:
			type: String
			required: true
			index: true
		conversions:
			type: Number
			required: true
			default: 0
		impressions:
			type: Number
			required: true
			default: 0
		emailAccess:
			type: [String]
		keywords:
			type: [String]
		clicks:
			type: Number
			default: 0
			required: true
	schema.virtual 'hasCredits'
	.get -> @totalCredits > @usedCredits
	schema
module.exports = SubscriptionSchema
