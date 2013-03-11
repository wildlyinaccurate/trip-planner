'use strict'

class GeocoderService
  constructor: (@$q, @$timeout) ->
    @geocoder = new google.maps.Geocoder()

  geocode: (options) ->
    deferred = @$q.defer()

    @geocoder.geocode options, (results, status) =>
      @$timeout ->
        if status == google.maps.GeocoderStatus.OK
          deferred.resolve results
        else
          deferred.reject status

    deferred.promise

  getLocation: (latLng) ->
    @geocode { 'latLng': latLng }

  getLatLng: (location) ->
    @geocode { 'address': location }

tripPlannerApp.factory 'geocoderService', ($timeout, $q) ->
  new GeocoderService($q, $timeout)
