{UserActions} = require '../config/config'
{Inject, annotate} = require 'di'

class VisitorActivityRecorder
	constructor: (models, @date) ->
		{@Visitor} = models

	recordWebActivityQ: (userId, thing, action) ->
		@Visitor.findByIdQ userId
		.then (user) =>
			return null if not user or not UserActions[action]
			user.webActivity.push (
				action: UserActions[action]
				thing: thing.toString()
				timestamp: @date.now()
			)
			user.saveQ()


annotate VisitorActivityRecorder, new Inject(
	require '../factories/ModelFactory'
	require '../providers/DateProvider'
	)

module.exports = VisitorActivityRecorder