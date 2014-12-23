JadeProvider = require '../providers/JadeProvider'
{Inject, annotate} = require 'di'
###
	1. Read a file async
	2. Compile Jade
	3. Interpolate
	4. Inline style
	5. send mail
###


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