'use strict'

class ReverseGeocoder
  constructor: (@$q, @$timeout) ->
    @geocoder = new google.maps.Geocoder()

  getLocation: (latLng) ->
    deferred = @$q.defer()

    @geocoder.geocode { 'latLng': latLng }, (results, status) =>
      @$timeout ->
        if status == google.maps.GeocoderStatus.OK
          deferred.resolve results
        else
          deferred.reject status

    deferred.promise

tripPlannerApp.factory 'reverseGeocoder', ($timeout, $q) ->
  new ReverseGeocoder($q, $timeout)
