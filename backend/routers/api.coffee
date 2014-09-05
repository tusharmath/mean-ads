express = require 'express'
config = require '../config/config'
_ = require 'lodash'
Controllers = require '../controllers'
di = require 'di'
{resources, actionMap} = require './conventions'
class V1
    constructor: (ctrlManager) ->
        @router = express.Router()
        controllers = ctrlManager.controllers
        _.each resources, (resource) =>
            ctrlName = @extractControllerName resource
            ctrl = controllers[ctrlName]
            if ctrl
                _.each actionMap, (map) =>
                    [action, method, _route] = map

                    @router[method] _route(resource), _.bind(ctrl[action], ctrl) if ctrl[action]


        # Bad Requests
        @router.use '*', (req, res) -> res.send error: 'Service not found', 404
    extractControllerName: (str) ->
        str
        .replace /^./, str[0].toUpperCase()
        .replace /s$/, 'Controller'


di.annotate V1, new di.Inject Controllers
module.exports = V1
