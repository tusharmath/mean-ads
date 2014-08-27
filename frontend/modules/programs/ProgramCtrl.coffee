define ["app"], (app) ->
    class ProgramCtrl
        constructor: (rest) ->
            rest.all('programs').getList().then (@programs) =>

    ProgramCtrl.$inject = ["Restangular"]
    app.controller 'ProgramCtrl', ProgramCtrl
