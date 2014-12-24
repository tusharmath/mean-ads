do (window) ->
	urlParse = (url) ->
		l = document.createElement 'a'
		l.href = url
		l
	map = (items, callback) ->
		callback i for i in items
	settings =
		hostname: "app.meanads.com"
		port: ""
	# Command Pattern
	commands =
		set: (key, value) -> settings[key] = value
		convert: (id) ->
			ajax 'get', "//#{settings.hostname}:#{settings.port}/api/v1/subscription/#{id}/convert", (r) -> console.log r
		ad: (program, el, keywords) ->
			url = "//#{settings.hostname}:#{settings.port}/api/v1/dispatch/ad?p=#{program}"
			if keywords and keywords.length > 0
				keywordParams = map keywords, (k) -> "&k=#{k}"
				url += keywordParams.join ''
			ajax 'get', url, (response) ->
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
	# Dynamically setting hostname and port
	if window.ma.g
		{hostname, port} = urlParse window.ma.g
		settings.hostname = hostname
		settings.port = port

	# Iterate over all the commands and execute
	if window.ma.q
		for cmd in window.ma.q
			ma.apply null, cmd

	# Override the orignal ma object
	window.ma = ma
