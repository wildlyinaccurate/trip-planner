(function() {
  'use strict';

  angular.module('tripPlannerApp', []).config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainController'
      }).otherwise({
        redirectTo: '/'
      });
    }
  ]);

}).call(this);
