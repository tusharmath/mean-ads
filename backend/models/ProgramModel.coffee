module.exports = (mongoose) ->
    ProgramModel = mongoose.model 'Program', new mongoose.Schema
        name:
            type: String
            required: true
        gauge:
            type: String
            enum: ["clicks", "impressions", "days"]
            required: true
        delivery:
            type: String
            required: true
        style:
            type: String
            required: true
        campaigns:
            type: Number
            required: true
