define ["angular"], (angular) ->
	class RouteResolveProvider

		$get: -> {@resolve}

		getTemplateUrl: (resource, action) ->
			"modules/#{resource}s/#{action}-tmpl"
			.toLowerCase()

		getController: (resource, action) -> "#{resource}#{action}Ctrl as ctrl"

		getRoute: (resource, action) ->
			resourcePath = resource.toLowerCase() + "s"
			switch action
				when 'List' then "/#{resourcePath}"
				when 'Create' then "/#{resourcePath}/create"
				when 'Update' then "/#{resourcePath}/:id"

		resolve: (routeProvider, resource, actions = ['List']) =>
			_.each actions, (action) =>
				templateUrl = @getTemplateUrl resource, action
				controller = @getController resource, action
				route = @getRoute resource, action
				routeProvider.when route, {templateUrl, controller}

	angular.module 'route.resolver', []
	.provider 'RouteResolver', RouteResolveProvider
