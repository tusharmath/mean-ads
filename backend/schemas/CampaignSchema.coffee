CampaignSchema = (mongoose) ->
	new mongoose.Schema
		name:
			type: String
			required: true
		program:
			type : mongoose.Schema.ObjectId
			required: true
			ref: 'Program'
			index: true
		defaultCost:
			type: Number
			required: true
			default: 1
		keywordPricing:
			type: mongoose.Schema.Types.Mixed
		isEnabled:
			type: Boolean
			default: false
		owner:
			type: String
			required: true
			index: true
module.exports = CampaignSchema
