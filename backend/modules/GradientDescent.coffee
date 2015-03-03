_ = require 'lodash'
MeanError = require './MeanError'

class GradientDescent
	_diffWithHypothesis: (X, Y, P, _hypothesis) ->
		_.map Y, (Yi, i) => Yi - _hypothesis P, X[i]

	_gradientDescent: (P, X, Y, _hypothesis, al = 0.01) ->
		m = X.length
		throw new MeanError 'labels length not matching training data' if m isnt Y.length
		hypDiff = @_diffWithHypothesis X, Y, P, _hypothesis
		func2 = (Pj, j) ->
			func1 = (val, Xi, i) -> val + hypDiff[i] * Xi[j]
			Pj + al / m * _.reduce X, func1, 0
		_.map P, func2
	execute: (P, X, Y, _hypothesis, epoch = 1000, al) ->
		out = P
		_.times epoch, => out = @_gradientDescent out, X, Y, _hypothesis, al
		out


module.exports = GradientDescent