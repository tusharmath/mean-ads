class DateProvider
	create: (year, month, date) ->
		new Date year, month, date
	now: -> Date.now()
	split: (date) -> [
			date.getFullYear()
			date.getMonth()
			date.getDate()
		]

module.exports = DateProvider