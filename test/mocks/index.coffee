glob = require 'glob'
files = glob '*Mock.coffee', sync:true, cwd: './test/mocks'
module.exports = (require "./#{f}" for f in files)
