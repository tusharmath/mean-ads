define ["angular"], (angular) ->
	class RouteResolveProvider
		$get: -> {@resolve}

		getTemplateUrl: (resource, action) ->
			"modules/#{resource}s/#{action}"
			.toLowerCase()

		getController: (resource, action) -> "#{resource}#{action}Ctrl as ctrl"

		resolve: (resource, action = 'List') ->
			templateUrl = @getTemplateUrl resource, action
			controller = @getController resource, action
			{templateUrl, controller}

	angular.module 'route.resolver', []
	.provider 'RouteResolver', RouteResolveProvider
