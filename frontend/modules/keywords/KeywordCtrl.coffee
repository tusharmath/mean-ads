define ["app"], (app) ->
    class KeywordCtrl
        constructor: () ->
            @keywords = [
                name: "Kormangala - sub localities"
                campaignCount: 213
                wordCount: 12
            ,
                name: "Indira Nagar - south localities"
                campaignCount: 132
                wordCount: 123
            ]
    app.controller 'KeywordCtrl', KeywordCtrl
