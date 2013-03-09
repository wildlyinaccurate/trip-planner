'use strict'

angular.module('tripPlannerApp', ['ui', 'tripPlannerApp.services']).controller 'mainController', ($scope, reverseGeocoder) ->

  $scope.alerts = []
  $scope.markers = []

  $scope.mapOptions = {
    center: new google.maps.LatLng(50, 0),
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  $scope.addMarker = ($event) ->
    marker = new google.maps.Marker({
      map: $scope.map,
      position: $event.latLng
    })

    $scope.markers.push marker

    promise = reverseGeocoder.getLocation(marker.getPosition())

    promise.then (results) ->
      marker.location = results.shift()
    , (reason) ->
      $scope.alerts.push "Unable to reverse geocode marker. #{reason}"

  $scope.geolocationAvailable = !!navigator.geolocation

  if ($scope.geolocationAvailable)
    navigator.geolocation.getCurrentPosition (position) ->
      $scope.map.panTo new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      $scope.$apply()
    , (error) ->
      $scope.alerts.push "We weren't able to determine your current location."
      $scope.$apply()
