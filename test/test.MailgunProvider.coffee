MailgunProvider = require  '../backend/providers/MailgunProvider'
{Injector} = require 'di'

describe 'Mailgun:', ->
	beforeEach ->
		@injector = new Injector

		#Mailgun
		@mod = @injector.get MailgunProvider
	###
	IMPORTANT:
		- TEST SHOULD BE DISABLED
		- TEST SHOULD NOT BE DELETED
	###
	# describe "sendQ()", ->
	# 	it "Send an email", ->
	# 		@mod.sendQ(
	# 			'Biz Cost Savers <noreply@meanads.com>',
	# 			'tusharmath@gmail.com',
	# 			'Subscription report',
	# 			'Whats going on'
	# 			)