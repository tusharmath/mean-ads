express = require 'express'
mongoose = require 'mongoose'
config = require '../config/config'
ProgramController = require '../controllers/ProgramController'

v1 = express.Router()

#DI initialization
di = require 'di'
injector = new di.Injector

# Keywords

v1.get '/keywords', (req, res) ->
    res.send [
        name: "Kormangala - sub localities"
        campaignCount: 213
        wordCount: 12
    ,
        name: "Indira Nagar - south localities"
        campaignCount: 132
        wordCount: 123
    ]

# Styles
v1.get '/styles', (req, res) ->
    res.send [
        name: "Blue Front"
        programs: 5
        size: 123
    ,
        name: "Slim Looking"
        programs: 12
        size: 345
    ]

# Subscriptions
v1.get '/subscriptions', (req, res) ->
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
v1.get '/campaigns', (req, res) ->
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

#Programs
programController = injector.get ProgramController
v1.post '/programs', (req, res) ->
    mongoose.connect config.mongo.uri
    mongoose.connection.once 'open', ->
        programController.create req, res

v1.get '/programs', (req, res) ->
    res.send [
        name: "doctors paradise"
        style: "Blue front"
        slotCount: 123
        gauge: "clicks"
        campaignCount : 345
        status: "active"
        algorithm: "round robin"
    ,
        name: "Lawyers Blazers"
        style: "Dirty Green"
        slotCount: 12
        gauge: "date"
        campaignCount : 3
        status: "active"
        algorithm: "super enabled"
    ,
        name: "engineer's den"
        style: "slim looking"
        slotCount: 19
        gauge: "impressions"
        campaignCount : 37
        status: "stale"
        algorithm: "weighted selections"
    ]

# All Other
v1.use '*', (req, res) -> res.send error: 'Bad Request', 404

# Exporting Versions
exports.v1 = v1
