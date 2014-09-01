express = require 'express'
config = require '../config/config'
_ = require 'lodash'
Controllers = require '../controllers'
di = require 'di'

routeMap = [
    'programs'
    'styles'
    'keywords'
    'subscriptions '
    'campaigns'
]
class V1
    extractControllerName: (str) ->
        str
        .replace /^./, str[0].toUpperCase()
        .replace /s$/, 'Controller'

    bindActionToMethod: (ctrl, action, method, route) ->
        @router[method] route, _.bind ctrl[action], ctrl if ctrl[action]
    constructor: (ctrlManager) ->
        @router = express.Router()
        controllers = ctrlManager.controllers
        _.each routeMap, (route) =>
            ctrlName = @extractControllerName route
            @extractControllerName route
            ctrl = controllers[ctrlName]
            return if not ctrl
            _bindCtrlActionToMethod = _
                .chain @bindActionToMethod
                .curry ctrl
                .bind @
                .value()
            _bindCtrlActionToMethod 'create', 'post', "/#{route}"
            _bindCtrlActionToMethod 'list', 'get', "/#{route}"
            _bindCtrlActionToMethod 'first', 'get', "/#{route}/:id"
            _bindCtrlActionToMethod 'update', 'put', "/#{route}/:id"
            _bindCtrlActionToMethod 'remove', 'delete', "/#{route}/:id"

        # Keywords
        @router.get '/keywords', (req, res) ->
            res.send [
                name: "Kormangala - sub localities"
                campaignCount: 213
                wordCount: 12
            ,
                name: "Indira Nagar - south localities"
                campaignCount: 132
                wordCount: 123
            ]

        # Subscriptions
        @router.get '/subscriptions', (req, res) ->
            res.send [
                client: "Fortis Multispeciality Hospital"
                campaign: "Indiranagar Dentistry"
                startDate: new Date 1, 1, 2010
                endDate: new Date 1, 1, 2014
                creditsRemaining: 4094
                totalCredits: 9876
                gauge: "clicks"
            ,
                client: "Manipal Dental Clinic"
                campaign: "Kormangala Orthopedics"
                startDate: new Date 1, 1, 2019
                endDate: new Date 1, 1, 2114
                creditsRemaining: 94
                totalCredits: 976
                gauge: "impressions"
            ]

        # Campaigns
        @router.get '/campaigns', (req, res) ->
            res.send [
                name: "Indiranagar Dentistry"
                duration: "6 months"
                commitment: 4000
                gauge: "clicks"
                adCount: 14
                health: "success"
                status: "stopped"
                program: "Engineer's Den"
            ,
                name: "Kormangala Orthopedics"
                duration: "3 months"
                commitment: 100
                gauge : "impressions"
                adCount: 198
                health: "danger"
                status: "running"
                program: "Slim Looking"
            ]

        # Bad Requests
        @router.use '*', (req, res) -> res.send error: 'Bad Request', 404

di.annotate V1, new di.Inject Controllers
module.exports = V1
@extraextractControllerName
