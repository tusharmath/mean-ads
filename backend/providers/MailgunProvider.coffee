{mailgun: {apiKey, domain}} = require '../config/config'
mailgun = require 'mailgun-js'

class MailgunProvider
	constructor: ->
		@mailgun = mailgun {apiKey, domain}
	sendMessageQ: (from, to, subject, html) ->
		@mailgun.messages().send {from, to, subject, html}
module.exports = MailgunProvider