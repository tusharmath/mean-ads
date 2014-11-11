_ = require 'lodash'
ErrorSchema =
	# 400
	INVALID_PARAMETERS:
		code: 'BADREQUEST'
		message: 'Request made with invalid parameters'
		httpStatus: 400

	# 403
	FORBIDDEN_DOCUMENT:
		code: 'FORBIDDEN'
		message: 'Only the owner of the document has access'
		httpStatus: 403

	# 404
	NOTFOUND_RESOURCE:
		code: 'NOTFOUND'
		message: 'Resource not found'
		httpStatus: 404

	NOTFOUND_DOCUMENT:
		code: 'NOTFOUND'
		message: 'Document not found'
		httpStatus: 404

	# 500
	INTERNAL_SERVER_ERROR:
		code: 'INTERNAL_SERVER_ERROR'
		message: 'Something went wrong'
		httpStatus: 500


ErrorPool = {}

class MeanError extends Error
	constructor: (@code, @message, @httpStatus) ->
		@type = 'mean'


_.each ErrorSchema, (val, key) ->
	ErrorPool[key] = new MeanError val.code, val.message, val.httpStatus

module.exports = ErrorPool