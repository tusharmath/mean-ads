_ = require 'lodash'
ErrorMap =
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

_.each ErrorMap, (val, key) -> val.type = 'mean'

module.exports = ErrorMap