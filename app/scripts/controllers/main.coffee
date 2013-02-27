'use strict'

angular.module('tripPlannerApp', ['google-maps']).controller 'mainController', ($scope) ->

  angular.extend $scope, {
    zoom: 10,
    center: {
      lat: 0,
      lng: 0,
    },
    markers: [],
    latitude: 0,
    longitude: 0
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

  $scope.$watch 'latitude + longitude', (newValue, oldValue) ->
    $scope.markers.push [$scope.latitude, $scope.longitude]
  , true
