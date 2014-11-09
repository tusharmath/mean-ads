do (window) ->
	settings =
		host: "mean-ads.herokuapp.com"
	# Command Pattern
	commands =
		set: (key, value) -> settings[key] = value
		ad: (program, el, keywords) ->
			get "//#{settings.host}/api/v1/dispatch/ad?p=#{program}", (response) ->
				el.innerHTML = response


	# Makes Http Get Requests
	get = (url, callback) ->
		oReq = new XMLHttpRequest()
		oReq.addEventListener 'load', ->
			if oReq.readyState is 4 and oReq.status is 200
				callback oReq.responseText
		oReq.open 'get', url, true
		oReq.send()

	# Overriding the ma object
	ma = (cmd, args...) -> commands[cmd].apply null, args

	# Iterate over all the commands and execute
	if window.ma.q
		for cmd in window.ma.q
			ma.apply null, cmd

	# Override the orignal ma object
	window.ma = ma
