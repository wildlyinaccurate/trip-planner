'use strict'

angular.module('tripPlannerApp', ['google-maps', 'tripPlannerApp.services']).controller 'mainController', ($scope, reverseGeocoder) ->

  $scope.map = {
    zoom: 10,
    center: {
      lat: 50,
      lng: 0,
    },
    markers: []
  }

  $scope.alerts = []

  $scope.$watch 'map.markers.length', ->
    for marker in $scope.map.markers
      continue if marker.location

      promise = reverseGeocoder.getLocation(marker.getPosition())

      promise.then (results) ->
        marker.location = results.shift()
      , (reason) ->
        $scope.alerts.push "Unable to reverse geocode marker. #{reason}"

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
