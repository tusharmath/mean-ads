'use strict'

_ = require 'lodash'
config = _.merge(
    require './env/all.coffee'
    require './env/' + process.env.NODE_ENV + '.coffee' || {}
 )
if process.env.USER
    config = _.merge(
        config
        require './user/' + process.env.USER + '.coffee' || {}
    )

module.exports = config
