{annotate, Inject} = require 'di'

class SplitTesting
	constructor: (@requireP, @utils, abP, @redis, @date) ->
		@ab = abP.abTesting()
	_baseExprPath: '../experiments/'
	# Dynamically loads an experiment
	_load: (module) ->
		moduleFileName = "#{@utils.snakeCaseToCamelCase module}Expr"
		path = @_baseExprPath + moduleFileName
		#TODO: Objects should be instantiated here
		@requireP.require path

	_save: (exprName, scenarioName, command) ->
		@redis.conn.incr "#{exprName}:#{scenarioName}:#{command}"


	getExperiment: (exprName, uuid) ->
		exprDescriptor = @_load exprName
		{startDate, endDate} = exprDescriptor

		return null if(
			endDate < @date.now() or
			startDate > @date.now()
			)

		# Create Experiment
		abExpr = @ab
		.createTest exprName, exprDescriptor.scenarioDescriptors

		# Set Scenario Name
		exprDescriptor.scenarioName = abExpr
		.getGroup exprName, uuid

		# Add Extension methods
		exprDescriptor.execute = (scenarioCallbacks) =>
			abExpr
			.test exprDescriptor.scenarioName, scenarioCallbacks
			@_save exprName, exprDescriptor.scenarioName, 'execute'

		exprDescriptor.convert = =>
			@_save exprName, exprDescriptor.scenarioName, 'convert'
		exprDescriptor

annotate SplitTesting, new Inject(
	require '../providers/RequireProvider'
	require '../Utils'
	require '../providers/AbTestingProvider'
	require '../connections/RedisConnection'
	require '../providers/DateProvider'
	)
module.exports = SplitTesting