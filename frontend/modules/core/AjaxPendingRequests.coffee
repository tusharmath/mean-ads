app = require '../../app'
class AjaxPendingRequests
	constructor: (@q) ->
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
		@q.reject rejection
	onCountChange: (@callback) =>

AjaxPendingRequests.$inject = ['$q']

app.service 'AjaxPendingRequests', AjaxPendingRequests