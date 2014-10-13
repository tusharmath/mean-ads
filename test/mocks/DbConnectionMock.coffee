di = require 'di'
DbConnection = require '../../backend/connections/DbConnection'
class DbConnectionMock
	mongoose: 'i am so fake'
di.annotate DbConnectionMock, new di.Provide DbConnection

module.exports = DbConnectionMock
