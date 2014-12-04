exports.mockDataSetup = ->
	ownerId = 9000
	campaign =
		name: 'apple-campaign'
		days: 10
		owner: ownerId
	subscription =
		client: 'apples'
		totalCredits: 1000
		data: a:'aaa', b: 'bbb', c: 'ccc'
		owner: ownerId
	program =
		name: 'apple-program'
		owner: ownerId
	style =
		name: 'apple-style'
		html: '<div>{{=it.a}}</div><h2 href="{{=it.c}}">{{=it.b}}</h2>'
		placeholders: ['a', 'b', 'c']
		owner: ownerId

	new @Models.Style style
	.saveQ()
	.then (@style) =>
		program.style = @style._id
		new @Models.Program program
		.saveQ()
	.then (@program) =>
		campaign.program = @program._id
		new @Models.Campaign campaign
		.saveQ()
	.then (@campaign) =>
		subscription.campaign = @campaign._id
		new @Models.Subscription subscription
		.saveQ()
	.then (@subscription) =>