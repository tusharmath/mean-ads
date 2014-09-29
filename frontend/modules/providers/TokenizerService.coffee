define ["app", "lodash"], (app, _) ->
	class TokenizerService
		tokenize: (str) ->
			[] if str is undefined
			str if str instanceof Array is yes
			_.compact str.split /[\s,.|]/

	app.service 'TokenizerService', TokenizerService
