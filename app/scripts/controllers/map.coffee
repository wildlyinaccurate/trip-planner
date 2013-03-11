'use strict'

tripPlannerApp.controller 'MapCtrl', ($scope, $timeout, Geocoder, Directions) ->

  $scope.alerts = []
  $scope.markers = []

  $scope.mapOptions = {
    center: new google.maps.LatLng(50, 0),
    zoom: 9,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  $scope.directionsModes = Directions.directionsModes

  directionsDisplay = new google.maps.DirectionsRenderer({
    preserveViewport: true
  })

  # Default directions mode
  $scope.directionsMode = { value: $scope.directionsModes['Driving'] }

  $scope.$watch 'directionsMode.value', $scope.updateDirections

  $scope.$watch 'map', (map) ->
    directionsDisplay.setMap map

  # Update the directions display
  $scope.updateDirections = ->
    return unless $scope.markers.length >= 2

    $timeout ->
      promise = Directions.getDirections $scope.markers, {
        travelMode: $scope.directionsMode.value
      }

      promise.then (result) ->
        # Hide the first & last markers so that the "A" & "B" directions markers are visible
        marker.setVisible true for marker in $scope.markers
        $scope.markers[0].setVisible false
        $scope.markers[$scope.markers.length - 1].setVisible false

        directionsDisplay.setDirections result
      , (reason) ->
        $scope.alerts.push "Unable to get directions. #{reason}"

  # Add a marker to the map, based on a click event
  $scope.addMarker = ($event) ->
    marker = new google.maps.Marker({
      map: $scope.map,
      position: $event.latLng
    })

    $scope.markers.push marker

    promise = Geocoder.getLocation marker.getPosition()

    promise.then (results) ->
      marker.location = results.shift()
    , (reason) ->
      $scope.alerts.push "Unable to reverse geocode marker. #{reason}"

    $scope.updateDirections()

  # Remove marker at position #{index}
  $scope.removeMarker = (index) ->
    marker = $scope.markers.splice(index, 1)[0]
    marker.setMap null

    $scope.updateDirections()

  # Center the map based on the user's current location
  if (navigator.geolocation)
    navigator.geolocation.getCurrentPosition (position) ->
      $scope.map.panTo new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      $scope.$apply()
    , (error) ->
      $scope.alerts.push "We weren't able to determine your current location."
      $scope.$apply()
