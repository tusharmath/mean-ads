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

	_save: (exprDescriptor, command) ->
		[exprName, scenarioName] = [exprDescriptor.name(), exprDescriptor.scenario()]
		@redis.conn.incr "#{exprName}:#{scenarioName}:#{command}"


	getExperiment: (exprName, uuid) ->
		exprDescriptor = @_load exprName
		{startDate, endDate} = exprDescriptor

		return null if endDate < @date.now() or startDate > @date.now()

		# Create Experiment
		abExpr = @ab.createTest exprName, exprDescriptor.scenarioDescriptors

		# Experiment Name Getter
		exprDescriptor.name = -> abExpr.getName()

		# Scenario Name Getter
		exprDescriptor.scenario = -> abExpr.getGroup uuid

		# Increates execute value by one
		exprDescriptor.execute = (scenarioCallbacks) =>
			abExpr.test exprDescriptor.scenario(), scenarioCallbacks
			@_save exprDescriptor, 'execute'
		# Increates convert value by one
		exprDescriptor.convert = => @_save exprDescriptor, 'convert'
		exprDescriptor

annotate SplitTesting, new Inject(
	require '../providers/RequireProvider'
	require '../Utils'
	require '../providers/AbTestingProvider'
	require '../connections/RedisConnection'
	require '../providers/DateProvider'
	)
module.exports = SplitTesting