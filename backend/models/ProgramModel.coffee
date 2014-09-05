module.exports = (mongoose) ->
    mongoose.model 'Program', new mongoose.Schema
        name:
            type: String
            required: true
        gauge:
            type: String
            enum: ["clicks", "impressions", "days"]
            default: "impressions"
            required: true
        delivery:
            type: String
            default: 'random-set'
        style:
            type : mongoose.Schema.ObjectId
            ref : 'Style'
        created:
            type: Date
            default: Date.now
