{Provide, annotate} = require 'di'
Q = require 'q'
MailgunProvider = require '../../backend/providers/MailgunProvider'
class MailgunProviderMock
	constructor: ->
		sinon.spy @, 'sendMessageQ'
	sendMessageQ: -> Q 'sent-mailgun-request'

annotate MailgunProviderMock, new Provide MailgunProvider

module.exports = MailgunProviderMock
