define ["app"], (app) ->
    class StyleCtrl
        constructor: () ->
            @styles = [
                name: "Blue Front"
                programs: 5
                size: 123
            ,
                name: "Slim Looking"
                programs: 12
                size: 345
            ]
    app.controller 'StyleCtrl', StyleCtrl
