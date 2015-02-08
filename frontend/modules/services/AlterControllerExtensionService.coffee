app = require '../../app'

class AlterControllerExtensionService
	constructor: (@alter, @first) ->

	bootstrap: (ctrl, resourceName) ->

		# Adding extension methods
		ctrl.save = =>
			ctrl.beforeSave() if ctrl.beforeSave
			@alter.persist resourceName, ctrl[resourceName]

		#Initialzing
		ctrl[resourceName] = @first.load resourceName

AlterControllerExtensionService.$inject = [
	'AlterPersistenceService'
	'FirstDocumentLoaderService'
]
app.service 'AlterControllerExtensionService', AlterControllerExtensionService
