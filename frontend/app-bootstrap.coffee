define [
	"angular"
	'lib/auth0-widget'
	'lib/auth0-angular'
	'lib/angular-cookies'
	"lib/module-loader"
	"lib/ui-bootstrap-tpls"
], (angular) ->
	angular.bootstrap document, ['mean-ads']
