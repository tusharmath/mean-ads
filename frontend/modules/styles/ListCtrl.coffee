define ["app"], (app) ->
    class StyleCtrl
        constructor: (rest) ->
            rest.all('styles').getList().then (@styles) =>
    StyleCtrl.$inject = ['Restangular']
    app.controller 'StyleListCtrl', StyleCtrl
