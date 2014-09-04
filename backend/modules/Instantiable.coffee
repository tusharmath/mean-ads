_ = require 'lodash'
class Instantiable
    constructor: ->

    setup: (instance) ->
        instance.$resolve = @resolve

    resolve: () ->
        _baseCtrl = {}
        _.forIn @, (v,k) ->  _baseCtrl[k] = v
        return _baseCtrl

module.exports = Instantiable
