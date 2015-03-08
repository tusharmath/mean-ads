_ = require 'lodash'
MeanError = require './MeanError'
{annotate, Inject} = require 'di'
###
X: Training Set
Y: Labels
P: Model Parameters
m: Size of Training Set
n: Number of features
al: Alpha
epoch: Max Iterations
###

class GradientDescent
	constructor: (@scaler) ->
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
		scaleParams = @scaler.getScaleParams X
		X = @scaler.scaleVectorList X, scaleParams
		X = _.map X, (Xi)->
			Xi.unshift 1
			Xi

		P = [0...X[0].length].map -> 0
		_.times epoch, => P = @_gradientDescent P, X, Y, _hypothesis, al
		predict = (testXi, theta = P) =>

			[testXi] = @scaler.scaleVectorList [testXi], scaleParams
			testXi.unshift 1
			_hypothesis theta, testXi
		{predict, theta: P}

annotate GradientDescent, new Inject require './FeatureScaler'

module.exports = GradientDescent