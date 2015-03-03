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
		throw new MeanError 'x1 should be 1' if Xi[0] isnt 1
		tmp = (cost, Xij, j) -> cost + Xij * P[j]
		_.reduce Xi, tmp, 0
	train: (X, Y, epoch, al) ->
		P = @gradient.execute X, Y, @_hypothesis, epoch, al
		predict = (testXi) =>
			testXi.unshift 1
			@_hypothesis P, testXi
		{predict}

annotate LinearRegression, new Inject GradientDescent
module.exports = LinearRegression