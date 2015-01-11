describe 'HtmlMinifierProvider:', ->
	beforeEach ->
		injector = new Injector

		#HtmlMinifierProvider
		@mod = injector.getModule 'providers.HtmlMinifierProvider'
	it 'has minify method', ->
		@mod.minify.should.be.a.Function