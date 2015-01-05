app = require './app'
class RouteResolveProvider

	$get: -> {@resolve}

	getTemplateUrl: (resource, action) ->
		resource_lc = resource.toLowerCase()
		action_lc = action.toLowerCase()
		switch action_lc
			when 'index' then "templates/#{resource_lc}-tmpl"
			when 'create' then "templates/#{resource_lc}s/alter-tmpl"
			when 'update' then "templates/#{resource_lc}s/alter-tmpl"
			else "templates/#{resource_lc}s/#{action_lc}-tmpl"

	getController: (resource, action) ->
		resource_lc = resource.toLowerCase()
		action_lc = action.toLowerCase()
		switch action_lc
			when 'index' then "#{resource}Ctrl as ctrl"
			when 'create' then "#{resource}AlterCtrl as ctrl"
			when 'update' then "#{resource}AlterCtrl as ctrl"
			else "#{resource}#{action}Ctrl as ctrl"

	getRoute: (resource, action) ->
		resourcePath = resource.toLowerCase()
		switch action
			when 'Index' then "/#{resourcePath}"
			when 'List' then "/#{resourcePath}s"
			when 'Create' then "/#{resourcePath}s/create"
			else "/#{resourcePath}s/:id/#{action.toLowerCase()}"
	defaultOptions:
		actions: ['Index']
		requiresLogin: true
	resolve: (routeProvider, resource, options = {}) =>

		{actions, requiresLogin} = _.assign options, @defaultOptions
		_.each actions, (action) =>
			requiresLogin = false
			templateUrl = @getTemplateUrl resource, action
			controller = @getController resource, action
			route = @getRoute resource, action
			routeProvider.when route, {templateUrl, controller, requiresLogin}

app.provider 'RouteResolver', RouteResolveProvider
