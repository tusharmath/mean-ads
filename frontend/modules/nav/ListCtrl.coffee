define ["app"], (app) ->
	injected = 0

	class NavbarCtrl
		constructor: ($location) ->
			injected = {$location}
			@modules = [
			# 	name: "Dashboard"
			# 	path: "/dashboard"
			# ,
				 #---begin:modules---#
				name: "Programs"
				path: "/programs"
			,
				name: "Campaigns"
				path: "/campaigns"
			,
				name: "Subscriptions"
				path: "/subscriptions"
			,
				name: "Styles"
				path: "/styles"
			]

		isActive: (route) ->
			injected.$location.path().match route

	NavbarCtrl.$inject = ['$location']

	app.controller 'NavListCtrl', NavbarCtrl
