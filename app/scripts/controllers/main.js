(function() {
  'use strict';

  angular.module('tripPlannerApp', ['google-maps']).controller('mainController', function($scope) {
    angular.extend($scope, {
      center: {
        lat: 0,
        lng: 0
      },
      markers: [],
      zoom: 8,
      clickedLatitudeProperty: null,
      clickedLongitudeProperty: null
    });
    $scope.geolocationAvailable = !!navigator.geolocation;
    if ($scope.geolocationAvailable) {
      return navigator.geolocation.getCurrentPosition(function(position) {
        $scope.center = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        return $scope.$apply();
      });
    }
  });

}).call(this);
