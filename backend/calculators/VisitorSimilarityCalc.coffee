u = do require '../Utils'
_ = require 'lodash'
###
	FilterFormat
	keywords: []
###

class VisitorSimilarityCalc
	# TODO: add filter for timestamp
	calc: (filter, testVisitor) ->
		b = filter.keywords
		l2 = _.groupBy testVisitor.actions, (v) -> v[1]
		_.map l2, (v) ->
			a = _.map v, (k) -> k[0]
			u.jSimilarity a, b

module.exports = VisitorSimilarityCalc



