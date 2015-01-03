AbTestingProvider = require '../providers/AbTestingProvider'
{annotate, Inject} = require 'di'
class SplitTesting

annotate SplitTesting, new Inject AbTestingProvider
module.exports = SplitTesting