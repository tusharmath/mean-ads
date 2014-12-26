_ = require 'lodash'
ErrorSchema =
	# 400
	INVALID_PARAMETERS:
		code: 'BADREQUEST'
		message: 'Request made with invalid parameters'
		httpStatus: 400
	INVALID_DATE:
		code: 'DATEFORMAT'
		message: 'Invalid Date Object'
		httpStatus: 400
	INVALID_OBJECT_ID:
		code: 'OBJECTID'
		message: 'Invalid object id'
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
	UNKNOWN_ERROR:
		code: 'UNKNOWN_ERROR'
		message: 'Unknown error'
		httpStatus: 500

ErrorPool = {}

class MeanError extends Error
	constructor: (@message, @code = 'KNOWN_ERROR', @httpStatus = '500') ->
		@type = 'mean'


_.each ErrorSchema, (val, key) ->
	ErrorPool[key] = new MeanError val.message, val.code, val.httpStatus

module.exports = {ErrorPool, MeanError}