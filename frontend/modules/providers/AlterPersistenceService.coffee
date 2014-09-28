define ["app", "lodash"], (app, _) ->
	class AlterPersistenceService
		constructor: (@rest, @loc) ->

		_update: (resourceName, resource) ->
			@rest.one resourceName, resource._id
			.patch resource

		_create: (resourceName, resource) ->
			@rest.all resourceName
			.post resource

		persist: (resourceName, resource) ->
			mode = if resource._id then 'update' else 'create'
			@["_#{mode}"] resourceName, resource
			.then => @loc.path "/#{resourceName}"

	AlterPersistenceService.$inject = ["Restangular", "$location"]
	app.service 'AlterPersistenceService', AlterPersistenceService
