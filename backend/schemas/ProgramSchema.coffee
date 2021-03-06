ProgramSchema = (mongoose) ->
	new mongoose.Schema
		name:
			type: String
			required: true
		allowedOrigins:
			type: [String]
		style:
			type : mongoose.Schema.ObjectId
			ref : 'Style'
			index: true
		created:
			type: Date
			default: Date.now
		owner:
			type: String
			required: true
			index: true
###		pricing:
			type: String
			enum: ['CPM', 'CPA']
			required: true###

module.exports = ProgramSchema
