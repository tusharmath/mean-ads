config = require '../config/config'
DateProvider = require '../providers/DateProvider'
_  = require 'lodash'
{MeanError} = require '../config/error-codes'
{Inject, annotate} = require 'di'
class DispatchStamper
	constructor: (@date) ->
	_reduce: (m, i) ->
		if m isnt ''
			m += ','
		m += "#{i.subscription}:#{i.timestamp.getTime()}"

	appendStamp : (stampStr, dispatch) ->
		stamps = @parseStamp stampStr
		{subscription} = dispatch
		timestamp = @date.now()
		stamps.push {subscription, timestamp}
		_.reduce stamps, @_reduce, ''
	parseStamp: (stampStr) ->
		try
			stamp = _.map stampStr.split(','), (i) =>
				[subscription, timestamp] = i.split ':'
				timestamp = @date.createFromValue timestamp
				if not subscription or no is _.isDate timestamp
					throw new MeanError 'Can not parse dispatch timestamp.'
				{subscription, timestamp}
		catch e
			if e instanceof MeanError then stamp = [] else throw e
		stamp

annotate DispatchStamper, new Inject DateProvider
module.exports = DispatchStamper