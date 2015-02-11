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
		keywordCost:
			type: mongoose.Schema.Types.Mixed
		isEnabled:
			type: Boolean
			default: false
		owner:
			type: String
			required: true
			index: true
module.exports = CampaignSchema
