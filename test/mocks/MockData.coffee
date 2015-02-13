Q = require 'q'
_ = require 'lodash'
# TODO: Make it readable!
ownerId = 9000
campaign =
	name: 'apple-campaign'
	days: 10
	owner: ownerId
	defaultCost: 1
	isEnabled: true
subscription =
	client: 'apples'
	totalCredits: 1000
	usedCredits: 120
	data: a:'aaa', b: 'bbb', c: 'ccc'
	owner: ownerId
	emailAccess: ['a@a.com', 'b@b.com', 'c@c.com']
	keywords: ['inky', 'pinky', 'ponky']
	# startDate: new Date(2012,1,2)
subscription2 =
	client: 'apples2'
	totalCredits: 2000
	usedCredits: 120
	data: a:'aaa2', b: 'bbb2', c: 'ccc2'
	owner: ownerId
subscription3 =
	client: 'apples3'
	totalCredits: 3000
	usedCredits: 120
	data: a:'aaa3', b: 'bbb3', c: 'ccc3'
	owner: 9001
subscription4 =
	client: 'apples4'
	totalCredits: 4000
	usedCredits: 120
	data: a:'aaa4', b: 'bbb4', c: 'ccc4'
	owner: ownerId
dispatches = [
	markup: 'hello world 1'
	startDate: new Date 2014, 1, 1
	keywords: ['aa', 'bb']
,
	markup: 'hello world 2 '
	startDate: new Date 2014, 1, 1
	keywords: ['bb', 'cc']
,
	markup: 'hello world 3'
	startDate: new Date 2014, 1, 1
	keywords: ['cc', 'dd']
]
program =
	name: 'apple-program'
	owner: ownerId
	pricing: 'CPM'
style =
	name: 'apple-style'
	html: '<div>{{=it.a}}</div><h2 href="{{=it.c}}">{{=it.b}}</h2>'
	css: 'p {position: absolute;}   a.selected {color: #f3a;}'
	placeholders: ['a', 'b', 'c']
	owner: ownerId

exports.mockDataSetup = ->
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
		subscription2.campaign = @campaign._id
		subscription3.campaign = @campaign._id
		subscription4.campaign = @campaign._id

		Q.all [
			new @Models.Subscription(subscription).saveQ()
			new @Models.Subscription(subscription2).saveQ()
			new @Models.Subscription(subscription3).saveQ()
			new @Models.Subscription(subscription4).saveQ()
		]
	.spread (@subscription) =>
		Q.all _.map dispatches, (d) =>
			d.subscription = @subscription._id
			d.program = @program._id
			new @Models.Dispatch(d).saveQ()
	.spread (@dispatch) =>