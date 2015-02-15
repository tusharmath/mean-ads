app = require '../../app'


class FirstDocumentLoaderService
	constructor: (@rest, @route, @$q) ->

	load: (resourceName) ->
		if @route.id
			return @rest.one resourceName, @route.id
			.get()
		else
			@$q (r) -> r {}

FirstDocumentLoaderService.$inject = ["Restangular", "$routeParams", "$q"]
app.service 'FirstDocumentLoaderService', FirstDocumentLoaderService
