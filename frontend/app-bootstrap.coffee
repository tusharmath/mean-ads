# Adds to global window
require "angular"
require "angular-storage/dist/angular-storage"
require "angular-jwt/dist/angular-jwt"
require "angular-route"
require "angular-cookies"
require "restangular"
require "auth0-angular"
window._ = require 'lodash'
modules = require './lib/module-loader'
angular.bootstrap document, ['mean-ads']
