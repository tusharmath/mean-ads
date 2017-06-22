_ = require 'lodash'
{annotate, Inject} = require 'di'
class LogisticRegression
	constructor: (@gradient) ->
	# Predicts the value of Y
	_hypothesis: (P, Xi) ->
		tmp = (cost, Xij, j) -> cost + Xij * P[j]
		tmp1 = _.reduce Xi, tmp, 0
		tmp2 = Math.exp  -tmp1
		1 / (1 + tmp2)
	train: (X, Y, epoch, al) ->
		@gradient.train X, Y, @_hypothesis, epoch, al

annotate LogisticRegression, new Inject require './GradientDescent'
module.exports = LogisticRegression