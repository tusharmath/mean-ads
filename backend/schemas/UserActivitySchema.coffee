UserActivitySchema = (mongoose) ->
	new mongoose.Schema
		webActivity:
			type: mongoose.Schema.Types.Mixed
			default: []
		modelParams:
			type: [Number]
		updated:
			type: Date
			default: Date.now

module.exports = UserActivitySchema
