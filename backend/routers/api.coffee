express = require 'express'
v1 = express.Router()
#Programs
v1.use '/programs', (req, res) ->
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

v1.use '*', (req, res) -> res.send error: 'Bad Request', 404

# Exporting Versions
exports.v1 = v1
