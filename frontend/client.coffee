[api, delimiter, scriptId] = ["http://mean-ads.herokuapp.com/api/v1/ads/#{mean.program}?mean=mean.cb", '&keywords[]=', 'mean']
keywordQuery = delimiter + mean.keywords.join delimiter
engine = mean.engine
mean.cb = (jsonp) ->
	el = document.getElementById mean.el
	createShadowRoot = el.createShadowRoot || el.webkitCreateShadowRoot
	shadowElement = createShadowRoot.call el
	shadowElement.innerHTML = "<style>#{jsonp.css}</style>" + mean.engine(jsonp.html) (jsonp.data)


script = document.createElement 'script'
script.src = api + keywordQuery
script.id = scriptId
document.getElementsByTagName('head')[0].appendChild script
