_ = require 'lodash'
MeanError = require './MeanError'

class GradientDescent
	_diffWithHypothesis: (X, Y, P, _hypothesis) ->
		_.map Y, (Yi, i) =>
			throw new MeanError 'Xi0 should be 1' if X[i][0] isnt 1
			Yi - _hypothesis P, X[i]

	_gradientDescent: (P, X, Y, _hypothesis, al = 0.01) ->
		m = X.length
		throw new MeanError 'labels length not matching training data' if m isnt Y.length
		hypDiff = @_diffWithHypothesis X, Y, P, _hypothesis
		func2 = (Pj, j) ->
			func1 = (val, Xi, i) -> val + hypDiff[i] * Xi[j]
			Pj + al / m * _.reduce X, func1, 0
		_.map P, func2
	train: (X, Y, _hypothesis, epoch = 1000, al) ->
		X = _.map X, (Xi)->
			Xi.unshift 1
			Xi

		P = [0...X[0].length].map -> 0
		_.times epoch, => P = @_gradientDescent P, X, Y, _hypothesis, al
		predict = (testXi) =>
			testXi.unshift 1
			_hypothesis P, testXi
		{predict}


module.exports = GradientDescent