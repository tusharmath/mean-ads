_ = require 'lodash'
MeanError = require './MeanError'
###
X: Training Set
Y: Labels
P: Parameters
###
class LinearRegression
	_cost: ->
	_hypothesis: () ->
	# Predicts the value of Y
	_hypothesis: (P, Xi) ->
		throw new MeanError 'x1 should be 1' if Xi[0] isnt 1
		tmp = (cost, Xij, j) -> cost + Xij * P[j]
		_.reduce Xi, tmp, 0

	# j model parameter
	_gradientDescent: (P, X, Y, al) ->
		m = X.length
		map1 = _.map Y, (Yi, i) => (@_hypothesis P, X[i]) - Yi
		_.map P,(Pj, j) ->
			Pj - _.reduce(X, ((val, Xi, i)-> map1[i] * Xi[j]), 0)/m*al

	train: (X, Y) ->

	predict: ->


module.exports = LinearRegression