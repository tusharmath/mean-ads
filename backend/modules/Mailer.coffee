JadeProvider = require '../providers/JadeProvider'
JuiceProvider = require '../providers/JuiceProvider'
MailGunProvider = require '../providers/MailGunProvider'
{Inject, annotate} = require 'di'

class Mailer
	constructor: (@jade, @juice, @mail) ->
	# TODO: starts with _
	getTemplatePath: (name) ->
		"./frontend/templates/mailers/#{name}.jade"
	# TODO: starts with _
	interpolate: (jadeTemplate, locals) ->
		templatePath = @getTemplatePath jadeTemplate
		templateFn = @jade.compileFile templatePath
		templateFn locals
	sendQ: (options) ->
		{from, to, subject, template, locals} = options
		markup = @interpolate template, locals
		@juice.juiceContentQ markup
		.then (inlineMarkup) =>
			@mail.sendMessageQ from, to, subject, inlineMarkup

annotate Mailer, new Inject JadeProvider, JuiceProvider, MailGunProvider
module.exports = Mailer