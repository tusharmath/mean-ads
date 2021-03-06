JadeProvider = require '../providers/JadeProvider'
JuiceProvider = require '../providers/JuiceProvider'
MailgunProvider = require '../providers/MailgunProvider'
{Inject, annotate} = require 'di'
humanize = require 'humanize'

class Mailer
	constructor: (@jade, @juice, @mail) ->
	# TODO: starts with _
	getTemplatePath: (name) ->
		"./frontend/templates/mailers/#{name}-tmpl.jade"
	# TODO: starts with _
	interpolate: (jadeTemplate, locals) ->
		templatePath = @getTemplatePath jadeTemplate
		templateFn = @jade.compileFile templatePath
		templateFn locals
	sendQ: (options) ->
		{from, to, subject, template, locals} = options
		locals.humanize = humanize
		markup = @interpolate template, locals
		@juice.juiceContentQ markup
		.then (inlineMarkup) =>
			@mail.sendMessageQ from, to, subject, inlineMarkup

annotate Mailer, new Inject JadeProvider, JuiceProvider, MailgunProvider
module.exports = Mailer