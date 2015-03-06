VisitorSchema = (mongoose) ->
	new mongoose.Schema
		webActivity:
			type: mongoose.Schema.Types.Mixed
		adActivity:
			type: mongoose.Schema.Types.Mixed
		modelParams:
			type: [Number]
		updated:
			type: Date
			default: Date.now

module.exports = VisitorSchema
