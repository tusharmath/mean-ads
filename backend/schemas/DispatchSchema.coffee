DispatchSchema = (mongoose) ->
	new mongoose.Schema

		markup:
			type: String
			required: true

		subscription:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Subscription'

		# Delivery Management
		lastDeliveredOn:
			type: Date
			default: Date.now

		keywords:
			type: [String]

module.exports = DispatchSchema
