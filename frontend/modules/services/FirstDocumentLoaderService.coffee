app = require '../../app'


class FirstDocumentLoaderService
	constructor: (@rest, @route) ->

	load: (resourceName) ->
		if @route.id
			return @rest.one resourceName, @route.id
			.get()
			.$object
		{}

FirstDocumentLoaderService.$inject = ["Restangular", "$routeParams"]
app.service 'FirstDocumentLoaderService', FirstDocumentLoaderService
