define ["app"], (app) ->
    class KeywordCtrl
        constructor: (rest) ->
            rest.all('keywords').getList().then (@keywords) =>
    KeywordCtrl.$inject = ['Restangular']
    app.controller 'KeywordCtrl', KeywordCtrl
