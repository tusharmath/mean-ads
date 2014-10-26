{Inject} = require 'di'

DbConnection = require '../connections/DbConnection'
class MongoModelProvider
	constructor: (@db) ->
	create: (name, schema) ->
		@db.conn.model name, schema @db.mongoose

MongoModelProvider.annotations = [
	new Inject DbConnection
]

module.exports = MongoModelProvider