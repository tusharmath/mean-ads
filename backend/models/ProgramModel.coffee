module.exports = (mongoose) ->
    ProgramModel = mongoose.model 'Program', new mongoose.Schema
        name: String
        gauge: type: String, enum: ["clicks", "impressions", "days"]
        delivery: String
        style: String
        campaigns: Number
