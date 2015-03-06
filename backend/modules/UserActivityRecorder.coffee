{UserActions} = require '../config/config'
{Inject, annotate} = require 'di'

class UserActivityRecorder
	constructor: (modelFac, @date) ->
		{@UserActivity} = modelFac.models()

	recordWebActivityQ: (userId, thing, action) ->
		@UserActivity.findByIdQ userId
		.then (user) =>
			return null if not user or not UserActions[action]
			user.webActivity.push (
				action: UserActions[action]
				thing: thing.toString()
				timestamp: @date.now()
			)
			user.saveQ()


annotate UserActivityRecorder, new Inject(
	require '../factories/ModelFactory'
	require '../providers/DateProvider'
	)

module.exports = UserActivityRecorder