module.exports = (mongoose) ->
    mongoose.model 'Style', new mongoose.Schema
        name:
            type: String
            required: true
        template:
            type: String
            required: true
        lessCSS:
            type: String
        created:
            type: Date
            default: Date.now
