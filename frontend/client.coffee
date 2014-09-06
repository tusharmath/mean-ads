[api, delimiter, scriptId] = ["http://localhost:3000/api/v1/ads?mean=mean.cb", '&keywords[]=', 'mean']
keywordQuery = delimiter + mean.keywords.join delimiter
engine = mean.engine
mean.cb = (jsonp) ->
  console.log jsonp


script = document.createElement 'script'
script.src = api + keywordQuery
script.id = scriptId
document.getElementsByTagName('head')[0].appendChild script
