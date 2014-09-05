module.exports = (mongoose) ->
	mongoose.model 'Style', new mongoose.Schema
		name:
			type: String
			required: true
		html:
			type: String
			required: true
		css:
			type: String
		created:
			type: Date
			default: Date.now
		placeholders:
			type: [String]
