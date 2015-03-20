angular.module("<%= @app_name %>")
  .config ($httpProvider, $locationProvider, $stateProvider, $urlRouterProvider) ->
    $locationProvider.html5Mode true
    $stateProvider
      #.state 'someState'
        #url: '/your/url'
        #templateUrl: 'template.html'
        #controller: 'yourController'
