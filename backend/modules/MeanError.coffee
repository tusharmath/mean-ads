class MeanError extends Error
	constructor: (@message, @code = 'KNOWN_ERROR', @httpStatus = '500') ->
		@type = 'mean'
module.exports = MeanError