JadeProvider = require '../providers/JadeProvider'
{Inject, annotate} = require 'di'

class Mailer
	constructor: (@jade) ->
	getTemplatePath: (name) ->
		"./frontend/templates/mailers/#{name}.jade"
	interpolate: (jadeTemplate, locals) ->
		templatePath = @getTemplatePath jadeTemplate
		templateFn = @jade.compileFile templatePath
		templateFn locals
annotate Mailer, new Inject JadeProvider
module.exports = Mailer