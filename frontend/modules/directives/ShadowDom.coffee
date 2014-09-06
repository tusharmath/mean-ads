define ["app"], (app) ->
	app.directive 'meanShadowDom', ->
		scope: {
			html: '=meanShadowDom'
		}
		link: (scope, element, attrs) ->
			createShadowRoot = element[0].createShadowRoot || element[0].webkitCreateShadowRoot
			shadowElement = createShadowRoot.call element[0]
			scope.$watch 'html', ->
				shadowElement.innerHTML = scope.html if scope.html
