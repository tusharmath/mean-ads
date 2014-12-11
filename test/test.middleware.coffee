{page} = require '../backend/middleware'

describe "middleware", ->
	mockRequest = ->
		{}
	mockResponse = ->
		res = {}
		res.status = sinon.stub().returns res
		res.render = sinon.stub().returns res
		res
	beforeEach ->
		@req = mockRequest()
		@res = mockResponse()
	describe "page()", ->
		it "renders requested page", ->
			page('index') @req, @res
			@res.render.calledWith 'index'
			.should.be.ok

		it "sets the http status with page", ->
			page('404') @req, @res
			@res.status.calledWith 404
			.should.be.ok
		it "sets status to 200 if page can not be parsed as Int", ->
			page('index') @req, @res
			@res.status.calledWith 200
			.should.be.ok


