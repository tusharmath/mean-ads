express = require 'express'
config = require '../config/config'

Controllers = require '../controllers'
di = require 'di'

class V1
    constructor: (ctrlManager) ->
        @router = express.Router()
        controllers = ctrlManager.controllers

        # Styles
        @router.post '/styles', (req, res) ->
            controllers.StyleController.create req, res

        @router.get '/styles', (req, res) ->
            controllers.StyleController.list req, res

        @router.delete '/styles/:id', (req, res) ->
            controllers.StyleController.remove req, res


        # Programs
        @router.post '/programs', (req, res) ->
            controllers.ProgramController.create req, res
        @router.get '/programs', (req, res) ->
            controllers.ProgramController.list req, res
        @router.delete '/programs/:id', (req, res) ->
            controllers.ProgramController.remove req, res

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
