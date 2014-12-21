define ['modules/core/app'], (app)->
	class AjaxPendingRequests
		constructor: ->
			@xhrCount = 0
		callback: ->
			console.warn 'Custom callaback has not been set'
		request: (config) =>
			@callback ++@xhrCount
			config
		response: (response) =>
			@callback --@xhrCount
			response
		responseError: (rejection) =>
			@callback --@xhrCount
			rejection
		onCountChange: (@callback) =>



	app.service 'AjaxPendingRequests', AjaxPendingRequests