define ["app"], (app) ->
	app.directive 'meanShadowDom', ->
		scope: {
			html: '=meanShadowDom'
		}
		link: (scope, element, attrs) ->
			shadowElement = element[0].createShadowRoot()
			scope.$watch 'html', ->
				shadowElement.innerHTML = scope.html if scope.html
