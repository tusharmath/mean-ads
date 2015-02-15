app = require '../../app'

class AlterControllerExtensionService
	constructor: (@alter, @first) ->

	bootstrap: (ctrl, resourceName) ->

		# Adding extension methods
		ctrl.save = =>
			ctrl.beforeSave() if ctrl.beforeSave
			@alter.persist resourceName, ctrl[resourceName]

		ctrl.remove = =>
			@alter.remove resourceName, ctrl[resourceName]

		#Initialzing
		@first.load resourceName
		.then (val) ->
			ctrl[resourceName] = val
			val

AlterControllerExtensionService.$inject = [
	'AlterPersistenceService'
	'FirstDocumentLoaderService'
]
app.service 'AlterControllerExtensionService', AlterControllerExtensionService
