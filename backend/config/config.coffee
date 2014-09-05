'use strict'
fs = require 'fs'
_ = require 'lodash'
config = _.merge(
    require './env/all.coffee'
    require './env/' + process.env.NODE_ENV + '.coffee' || {}
 )
if process.env.USER
  userconfig = './user/' + process.env.USER + '.coffee'
  if fs.existsSync userconfig
    config = _.merge(
        config
        require userconfig
    )

module.exports = config
