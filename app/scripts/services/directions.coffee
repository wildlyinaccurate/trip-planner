'use strict'

class Directions
  constructor: (@$q, @$timeout) ->
    @directions = new google.maps.DirectionsService()
    @directionsModes = {
      'Driving': google.maps.TravelMode.DRIVING
      'Cycling': google.maps.TravelMode.BICYCLING
      'Transit': google.maps.TravelMode.TRANSIT
      'Walking': google.maps.TravelMode.WALKING
    }

  getDirections: (markers, options) ->
    # Take a copy so we don't modify the original markers array
    markers = markers[..]

    options = angular.extend options, {
      origin: markers.shift().getPosition(),
      destination: markers.pop().getPosition(),
      provideRouteAlternatives: false,
      waypoints: [],
      optimizeWaypoints: true
    }

    # Any markers leftover are waypoints
    for marker in markers
      options.waypoints.push {
        location: marker.getPosition(),
        stopover: true
      }

    deferred = @$q.defer()

    @directions.route options, (results, status) =>
      @$timeout ->
        if status == google.maps.DirectionsStatus.OK
          deferred.resolve results
        else
          deferred.reject status

    deferred.promise

tripPlannerApp.factory 'Directions', ($timeout, $q) ->
  new Directions($q, $timeout)
