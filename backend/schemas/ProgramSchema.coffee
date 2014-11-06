ProgramSchema = (mongoose) ->
	new mongoose.Schema
		name:
			type: String
			required: true
		gauge:
			type: String
			enum: ["clicks", "impressions", "milliseconds"]
			default: "impressions"
			required: true
		delivery:
			type: String
			default: 'random-set'
		style:
			type : mongoose.Schema.ObjectId
			ref : 'Style'
		created:
			type: Date
			default: Date.now
		owner:
			type: String
			required: true
			index: true

module.exports = ProgramSchema
