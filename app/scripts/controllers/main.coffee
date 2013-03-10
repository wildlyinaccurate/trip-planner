'use strict'

tripPlannerApp.controller 'mainController', ($scope, reverseGeocoder, directionsService) ->

  $scope.alerts = []
  $scope.markers = []

  $scope.mapOptions = {
    center: new google.maps.LatLng(50, 0),
    zoom: 9,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  $scope.directionsModes = directionsService.directionsModes

  directionsDisplay = new google.maps.DirectionsRenderer({
    preserveViewport: true
  })

  # Default directions mode
  $scope.directionsMode = { value: $scope.directionsModes['Driving'] }

  $scope.updateDirections = ->
    return unless $scope.markers.length >= 2

    promise = directionsService.getDirections $scope.markers, {
      travelMode: $scope.directionsMode.value
    }

    promise.then (result) ->
      directionsDisplay.setDirections result
    , (reason) ->
      $scope.alerts.push "Unable to get directions. #{reason}"

  $scope.addMarker = ($event) ->
    marker = new google.maps.Marker({
      map: $scope.map,
      position: $event.latLng
    })

    $scope.markers.push marker

    promise = reverseGeocoder.getLocation marker.getPosition()

    promise.then (results) ->
      marker.location = results.shift()
    , (reason) ->
      $scope.alerts.push "Unable to reverse geocode marker. #{reason}"

    $scope.updateDirections()

  $scope.$watch 'directionsMode.value', $scope.updateDirections

  $scope.$watch 'map', (newValue) ->
    directionsDisplay.setMap newValue

  $scope.geolocationAvailable = !!navigator.geolocation

  if ($scope.geolocationAvailable)
    navigator.geolocation.getCurrentPosition (position) ->
      $scope.map.panTo new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      $scope.$apply()
    , (error) ->
      $scope.alerts.push "We weren't able to determine your current location."
      $scope.$apply()
