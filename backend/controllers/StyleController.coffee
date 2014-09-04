BaseController = require './BaseController'

class StyleController
    constructor: () ->
        @model = @modelManager.models.StyleModel

StyleController:: = injector.get(BaseController).$resolve()
module.exports = StyleController
