define [
	"angular"
	"lib/angular-route"
	"lib/ui-ace"
	"Restangular"
], (angular) ->
	"use strict"
	angular.module "mean-ads", ["ngRoute", "restangular", "ui.ace"]
	.config [
		'$routeProvider'
		'$locationProvider'
		'$httpProvider'
		'RestangularProvider'
		($routeProvider, $locationProvider, $httpProvider, RestProvider) ->
			RestProvider.setBaseUrl '/api/v1'
			RestProvider.setDefaultHttpFields cache: false
			RestProvider.setRestangularFields id: '_id'
			# TODO: Too verbose
			$routeProvider
				.when "/dashboard",
					templateUrl: "modules/dashboard/dashboard"
					controller: "DashboardCtrl as dashCtrl"

				# Programs
				.when "/programs",
					templateUrl: "modules/programs/program"
					controller: "ProgramCtrl as prgCtrl"
				.when "/programs/create",
					templateUrl: "modules/programs/create"
					controller: "ProgramCreateCtrl as ctrl"

				#Campaigns
				.when "/campaigns",
					templateUrl: "modules/campaigns/campaign"
					controller: "CampaignCtrl as cmpCtrl"
				.when "/campaigns/create",
					templateUrl: "modules/campaigns/create"
					controller: "CampaignCreateCtrl as ctrl"

				#Subscriptions
				.when "/subscriptions",
					templateUrl: "modules/subscriptions/subscription"
					controller: "SubscriptionCtrl as subCtrl"
				.when "/subscriptions/create",
					templateUrl: "modules/subscriptions/create"
					controller: "SubscriptionCreateCtrl as subCtrl"

				#Keywords
				.when "/keywords",
					templateUrl: "modules/keywords/keyword"
					controller: "KeywordCtrl as kwCtrl"

				#Styles
				.when "/styles",
					templateUrl: "modules/styles/style"
					controller: "StyleCtrl as stylCtrl"
				.when "/styles/create",
						templateUrl: "modules/styles/create"
						controller: "StyleCreateCtrl as ctrl"

				.otherwise redirectTo: "/dashboard"
			$locationProvider.html5Mode false
	]
