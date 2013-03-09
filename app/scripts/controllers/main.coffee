'use strict'

angular.module('tripPlannerApp', ['google-maps']).controller 'mainController', ($scope) ->

  $scope.map = {
    zoom: 10,
    center: {
      lat: 50,
      lng: 0,
    },
    markers: []
  }

  $scope.alerts = []

  $scope.geolocationAvailable = !!navigator.geolocation

  if ($scope.geolocationAvailable)
    navigator.geolocation.getCurrentPosition (position) ->
      $scope.map.center = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }

      $scope.$apply()
    , (error) ->
      $scope.alerts.push "We weren't able to determine your current location."
      $scope.$apply()
