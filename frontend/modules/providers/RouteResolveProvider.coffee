define ["angular"], (angular) ->
	class RouteResolveProvider

		$get: -> {@resolve}

		getTemplateUrl: (resource, action) ->
			return "templates/#{resource}-tmpl"
			.toLowerCase() if action is 'Index'

			"templates/#{resource}s/#{action}-tmpl"
			.toLowerCase()

		getController: (resource, action) ->
			return "#{resource}Ctrl as ctrl" if action is 'Index'
			"#{resource}#{action}Ctrl as ctrl"

		getRoute: (resource, action) ->
			resourcePath = resource.toLowerCase()
			switch action
				when 'Index' then "/#{resourcePath}"
				when 'List' then "/#{resourcePath}s"
				when 'Create' then "/#{resourcePath}s/create"
				when 'Update' then "/#{resourcePath}s/:id"

		resolve: (routeProvider, resource, actions = ['Index']) =>

			_.each actions, (action) =>
				templateUrl = @getTemplateUrl resource, action
				controller = @getController resource, action
				route = @getRoute resource, action
				# console.log route, {templateUrl, controller}
				routeProvider.when route, {templateUrl, controller}

	angular.module 'route.resolver', []
	.provider 'RouteResolver', RouteResolveProvider
