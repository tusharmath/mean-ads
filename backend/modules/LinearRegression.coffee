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

	# j model parameter
	_gradientDescent: (P, X, Y, al) ->
		m = X.length
		throw new MeanError 'labels length not matching training data' if m isnt Y.length
		map1 = _.map Y, (Yi, i) => Yi - @_hypothesis P, X[i]
		_.map P, (Pj, j) ->
			func1 = (val, Xi, i) -> map1[i] * Xi[j]
			Pj + al / m *_.reduce X, func1, 0

	train: (X, Y) ->
		# Initialize a
		P = X.map -> 0

	predict: ->


module.exports = LinearRegression