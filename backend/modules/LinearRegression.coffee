_ = require 'lodash'
MeanError = require './MeanError'
###
X: Training Set
Y: Labels
P: Model Parameters
m: Size of Training Set
n: Number of features
al: Alpha
I: Max Iterations

###
class LinearRegression
	# Predicts the value of Y
	_hypothesis: (P, Xi) ->
		throw new MeanError 'x1 should be 1' if Xi[0] isnt 1
		tmp = (cost, Xij, j) -> cost + Xij * P[j]
		_.reduce Xi, tmp, 0

	_diffWithHypothesis: (X, Y, P) ->
		_.map Y, (Yi, i) => Yi - @_hypothesis P, X[i]
	# j model parameter
	_gradientDescent: (P, X, Y, al) ->
		m = X.length
		throw new MeanError 'labels length not matching training data' if m isnt Y.length
		hypDiff = @_diffWithHypothesis X, Y, P
		_.map P, (Pj, j) ->
			func1 = (val, Xi, i) -> val + hypDiff[i] * Xi[j]
			Pj + al / m * _.reduce X, func1, 0

	train: (X, Y, epoch = 1000, al = 0.1) ->

		X = _.map X, (Xi)->
			Xi.unshift 1
			Xi
		n = X[0].length
		P = [0...n].map -> 0
		_.times epoch, => P = @_gradientDescent P, X, Y, al
		predict = (testXi) =>
			testXi.unshift 1
			@_hypothesis P, testXi
		{predict}


module.exports = LinearRegression