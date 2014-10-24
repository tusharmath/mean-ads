module.exports =
	# 403
	FORBIDDEN_DOC:
		code: 'FORBIDDEN'
		message: 'Only the owner of the resource has access to this document'
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