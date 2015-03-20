angular.module("<%= @app_name %>", ['ngAnimate', 'ngResource', 'ngRoute', 'ui.router'])
  .config ($httpProvider, $routeProvider, $locationProvider) ->
    authToken = $("meta[name=\"csrf-token\"]").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
    $httpProvider.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest"
    $httpProvider.defaults.headers.common["Accept"] = "application/json"

$(document).on 'ready page:load', ->
  angular.bootstrap document.body, ['<%= @app_name %>']
