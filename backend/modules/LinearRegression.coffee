_ = require 'lodash'
MeanError = require './MeanError'
GradientDescent = require './GradientDescent'
{annotate, Inject} = require 'di'
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
	constructor: (@gradient) ->
	# Predicts the value of Y
	_hypothesis: (P, Xi) ->
		tmp = (cost, Xij, j) -> cost + Xij * P[j]
		_.reduce Xi, tmp, 0
	train: (X, Y, epoch, al) ->
		@gradient.train X, Y, @_hypothesis, epoch, al

annotate LinearRegression, new Inject GradientDescent
module.exports = LinearRegression