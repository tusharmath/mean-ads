module.exports = (mongoose) ->
    mongoose.model 'Subscription', new mongoose.Schema
        client:
            type: String
            required: true
        startDate:
            type: Date
            required: true
        campaign:
            type : mongoose.Schema.ObjectId
            ref : 'Campaign'
        totalCredits:
            type : Number
            required: true
        creditsRemaining:
            type : Number
        created:
            type: Date
            default: Date.now
        placeHolderValue:
            type: mongoose.Schema.Types.Mixed
