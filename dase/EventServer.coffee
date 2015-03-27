{annotate, Inject} = require 'di'
class EventServer
	constructor: (@models)->

	addEventQ: (user, entity, eventName, properties) ->
		ev = new @models.UserEvent {user, entity, eventName, properties}
		ev.saveQ()

	createEventStream: ->

annotate EventServer, new Inject require '../factories/ModelFactory'
module.exports = EventServer