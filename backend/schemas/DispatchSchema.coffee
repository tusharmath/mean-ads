DispatchSchema = (mongoose) ->
	new mongoose.Schema

		markup:
			type: String
			required: true
		subscription:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Subscription'
			index: true
		allowedOrigins:
			type: [String]
		# Delivery Management
		program:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Program'
			index: true
		lastDeliveredOn:
			type: Date
			default: Date.now
		# StartDate of the subscription
		startDate:
			type: Date
			required: true
		keywords:
			type: [String]
			index: true
		# Subscription Data for rendering
		data:
			type: mongoose.Schema.Types.Mixed

module.exports = DispatchSchema
