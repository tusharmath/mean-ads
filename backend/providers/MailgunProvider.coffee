{mailgun: {apiKey, domain}} = require '../config/config'
mailgun = require 'mailgun-js'

class MailgunProvider
	constructor: ->
		@mailgun = mailgun {apiKey, domain}
	sendQ: (from, to, subject, text) ->
		@mailgun.messages().send {from, to, subject, text}
module.exports = MailgunProvider