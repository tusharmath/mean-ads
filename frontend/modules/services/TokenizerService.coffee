app = require '../../app'


class TokenizerService
	tokenize: (str) ->
		return [] if str is undefined
		return str if str instanceof Array is yes
		return _.compact str.split /[\s,|]/

app.service 'TokenizerService', TokenizerService
