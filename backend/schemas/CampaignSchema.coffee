CampaignSchema = (mongoose) ->
	new mongoose.Schema
		name:
			type: String
			required: true
		program:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Program'
		days:
			type: Number
			required: true
		keywords:
			type: [String]
		commitment:
			type: Number
		performance:
			type: Number
		isEnabled:
			type: Boolean
			default: true

module.exports = CampaignSchema
