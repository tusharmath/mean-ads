config = require '../config/config'
DateProvider = require '../providers/DateProvider'
_  = require 'lodash'
{Inject, annotate} = require 'di'
class DispatchStamper
	constructor: (@date) ->
	appendStamp : (stamp, dispatch) ->
	parseStamp: (stamp) ->
		stamps = []
		_.each stamp.split(','), (i) =>
			[subscription, timestamp] = i.split ':'
			timestamp = @date.createFromValue timestamp
			stamps.push {subscription, timestamp}
		stamps

annotate DispatchStamper, new Inject DateProvider
module.exports = DispatchStamper