describe 'HtmlMinifierProvider:', ->
	beforeEach ->
		injector = new Injector

		#HtmlMinifierProvider
		@mod = injector.getModule 'providers.HtmlMinifierProvider', mock: false
	it 'has minify method', ->
		@mod.minify.should.be.a.Function
	it 'minifies style tags', ->
		html = "<div>    <style>p {color:    #ccc;     }   </style>    </div>"
		@mod.minify html
		.should.equal "<div><style>p{color:#ccc}</style></div>"