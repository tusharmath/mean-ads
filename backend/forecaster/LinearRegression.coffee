_ = require 'lodash'
GradientDescent = require './GradientDescent'
{annotate, Inject} = require 'di'
class LinearRegression
	constructor: (@gradient) ->
	# Predicts the value of Y
	_hypothesis: (P, Xi) ->
		tmp = (cost, Xij, j) -> cost + Xij * P[j]
		_.reduce Xi, tmp, 0
	train: (X, Y, epoch, al) ->
		@gradient.train X, Y, @_hypothesis, epoch, al

annotate LinearRegression, new Inject GradientDescent
module.exports = LinearRegression