{annotate, Inject} = require 'di'

class SplitTesting
	constructor: (@requireP, @utils, abP, @redis, @date) ->
		@ab = abP.abTesting()
	_baseExprPath: '../experiments/'
	# Dynamically loads an experiment
	_load: (module) ->
		path = "#{@_baseExprPath + @utils.snakeCaseToCamelCase module}Expr"
		@requireP.require path

	_save: (experimentName, scenarioName, command) ->
		@redis.conn.incr "#{experimentName}:#{scenarioName}:#{command}"


	getExperiment: (experimentName, uuid) ->
		experimentDescriptor = @_load experimentName
		{startDate, endDate} = experimentDescriptor

		return null if endDate < @date.now() or startDate > @date.now()

		abExperiment = @ab.createTest experimentName, experimentDescriptor.scenarioDescriptors

		# Set Scenario Name
		experimentDescriptor.scenarioName = abExperiment.getGroup experimentName, uuid

		# Add Extension methods
		experimentDescriptor.execute = (scenarioCallbacks) =>
			abExperiment.test experimentDescriptor.scenarioName, scenarioCallbacks
			@_save experimentName, experimentDescriptor.scenarioName, 'execute'

		experimentDescriptor.convert = =>
			@_save experimentName, experimentDescriptor.scenarioName, 'convert'
		experimentDescriptor

annotate SplitTesting, new Inject(
	require '../providers/RequireProvider'
	require '../Utils'
	require '../providers/AbTestingProvider'
	require '../connections/RedisConnection'
	require '../providers/DateProvider'
	)
module.exports = SplitTesting