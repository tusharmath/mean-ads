{Provide, annotate} = require 'di'
Q = require 'q'
MailGunProvider = require '../../backend/providers/MailGunProvider'
class MailGunProviderMock
	constructor: ->
		sinon.spy @, 'sendMessageQ'
	sendMessageQ: -> Q 'sent-mailgun-request'

MailGunProviderMock.annotations = [
	new Provide MailGunProvider
]

module.exports = MailGunProviderMock
