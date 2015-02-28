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

	train: (X, Y) ->

	predict: ->


module.exports = LinearRegression