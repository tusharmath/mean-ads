class DateProvider
	create: (year, month, date) -> new Date year, month, date
	createFromValue: (val) -> new Date parseInt val,10
	now: -> Date.now()
	split: (date) -> [
			date.getFullYear()
			date.getMonth()
			date.getDate()
		]

module.exports = DateProvider