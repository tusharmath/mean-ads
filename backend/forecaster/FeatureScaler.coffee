_ = require 'lodash'
class FeatureScaler

	scaleList: (item) ->
		range = _.max(item) - _.min(item)
		total = _.reduce item, (v, i) ->v + i
		avg = total / item.length
		_.map item, (item) -> (item - avg) / range
	scaleVectorList: (vectorList, scaleMetrics) ->
		n = vectorList[0].length
		m = vectorList.length
		for i in [0...m]
			for j in [0...n]
				{avg, range} = scaleMetrics[j]
				if range isnt 0
					vectorList[i][j] = (vectorList[i][j] - avg) / range
		vectorList

	getScaleParams: (vectorList) ->
		n = vectorList[0].length
		m = vectorList.length

		_.map [0...n], (j) ->
			sum = 0
			min = max = vectorList[0][j]
			for i in [0...m]
				val = vectorList[i][j]
				sum += val
				min = val if val < min
				max = val if val > max
			avg = sum / m
			{avg, range: max-min}


module.exports = FeatureScaler
