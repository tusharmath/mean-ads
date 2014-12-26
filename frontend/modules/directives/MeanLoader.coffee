define ["app"], (app) ->
	MeanLoader = (pendingRequests) ->
		el = {}
		onCountChange = (count)->
			if count is 0
				el.css 'display', 'none'
			else
				el.css 'display', 'block'

		pendingRequests.onCountChange onCountChange
		link: (scope, element, attrs) ->
			el = element

	app.directive 'meanLoader', ['AjaxPendingRequests', MeanLoader]

