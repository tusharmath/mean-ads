define ["app", "lodash"], (app, _) ->


	class AlterControllerExtensionService
		constructor: (@alter, @first) ->

		bootstrap: (ctrl, docName) ->
			resourceName = "#{docName}s"

			# Adding extension methods
			ctrl.save = =>
				ctrl.beforeSave() if ctrl.beforeSave
				@alter.persist resourceName, ctrl[docName]

			#Initialzing
			ctrl[docName] = @first.load resourceName

	AlterControllerExtensionService.$inject = [
		'AlterPersistenceService'
		'FirstDocumentLoaderService'
	]
	app.service 'AlterControllerExtensionService', AlterControllerExtensionService
