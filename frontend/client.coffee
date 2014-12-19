do (window) ->
	settings =
		# TODO: Should be dynamically set
		host: "app.meanads.com"
	# Command Pattern
	commands =
		set: (key, value) -> settings[key] = value
		convert: (id) ->
			ajax 'get', "//#{settings.host}/api/v1/subscription/#{id}/convert", (r) -> console.log r
		ad: (program, el, keywords) ->
			ajax 'get', "//#{settings.host}/api/v1/dispatch/ad?p=#{program}", (response) ->
				el.innerHTML = response

	# Makes Http Get Requests
	ajax = (method, url, callback) ->
		oReq = new XMLHttpRequest()
		oReq.withCredentials = true
		oReq.addEventListener 'load', ->
			if oReq.readyState is 4 and oReq.status is 200
				callback oReq.responseText
		oReq.open method, url, true
		oReq.send()

	# Overriding the ma object
	ma = (cmd, args...) ->
		if commands[cmd]
			commands[cmd].apply null, args

	# Iterate over all the commands and execute
	if window.ma.q
		for cmd in window.ma.q
			ma.apply null, cmd

	# Override the orignal ma object
	window.ma = ma
