module.exports = (mongoose) ->
    mongoose.model 'Campaign', new mongoose.Schema
        name:
            type: String
            required: true
        program:
            type : mongoose.Schema.ObjectId
            required: true
            ref: 'Program'
        days:
            type: Number
            required: true
        commitment:
            type: Number
