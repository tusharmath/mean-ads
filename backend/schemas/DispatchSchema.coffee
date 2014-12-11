DispatchSchema = (mongoose) ->
	new mongoose.Schema

		markup:
			type: String
			required: true

		subscription:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Subscription'
		allowedOrigins:
			type: [String]
		# Delivery Management
		program:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Program'

		lastDeliveredOn:
			type: Date
			default: Date.now

		keywords:
			type: [String]

module.exports = DispatchSchema
