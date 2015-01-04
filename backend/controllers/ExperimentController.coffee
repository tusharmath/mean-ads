{ErrorPool} = require '../config/error-codes'
{annotate, Inject} = require 'di'
_ = require 'lodash'
Q = require 'q'

class ExperimentController
	constructor: (@redis) ->
		@actions =
			actionMap:
				$one : ['get', -> "/experiment/:key"]
				$list : ['get', -> "/experiments"]
			$one: @$one
			$list: @$list
	$list: (req, res) =>
		@redis.conn.keys '*'
		.then (val) -> val

	$one: (req, res) =>
		{key} = req.params
		@redis.conn.get key
		.then (count) -> {count}



annotate ExperimentController, new Inject(
	require '../connections/RedisConnection'
	)
module.exports = ExperimentController
