'use strict'

angular.module('tripPlannerApp', ['google-maps']).controller 'mainController', ($scope) ->

  angular.extend $scope, {
    zoom: 10,
    center: {
      lat: 50,
      lng: 0,
    },
    markers: []
  }

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
