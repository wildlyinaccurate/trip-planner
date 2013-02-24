'use strict'

angular.module('tripPlannerApp', ['google-maps']).controller 'mainController', ($scope) ->

  angular.extend($scope, {
    center: {
      lat: 0,
      lng: 0,
    },
    markers: [],
    zoom: 8,
    clickedLatitudeProperty: null,
    clickedLongitudeProperty: null
  })

  $scope.geolocationAvailable = !!navigator.geolocation

  if ($scope.geolocationAvailable)
    navigator.geolocation.getCurrentPosition (position) ->
      $scope.center = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }

      $scope.$apply()
    , (error) ->
      $scope.locationError = error
      $scope.$apply()
