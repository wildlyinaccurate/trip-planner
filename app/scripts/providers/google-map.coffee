'use strict'

# Check if 2 floating point numbers are equal
#
# @see http://stackoverflow.com/a/588014
floatEqual = (f1, f2) ->
  (Math.abs(f1 - f2) < 0.000001)

class window.GoogleMap
  constructor: (element, options) ->
    @center = new google.maps.LatLng(options.center.lat, options.center.lng)
    @zoom = options.zoom
    @dragging = false
    @markers = []

    @map = new google.maps.Map(element, {
      center: @center,
      zoom: @zoom,
      draggable: options.draggable,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    })

    @on 'dragstart', =>
      @dragging = true

    @on 'drag', =>
      @dragging = true


    @on 'idle', =>
      @dragging = false

    @on 'zoom_changed', =>
      @zoom = @map.getZoom()
      @center = @map.getCenter()

    @on 'center_changed', =>
      @center = @map.getCenter()

  addMarker: (lat, lng) ->
    if !@findMarker lat, lng
      marker = new google.maps.Marker {
        position: new google.maps.LatLng(lat, lng),
        map: @map
      }

      @markers.unshift marker

      marker

  findMarker: (lat, lng) ->
    for marker in @markers
      position = marker.getPosition()

      return marker if floatEqual(position.lat(), lat) and floatEqual(position.lng(), lng)

    null

  setCenter: (center) ->
    return unless !floatEqual(center.lat, @center.lat()) or !floatEqual(center.lng, @center.lng())

    @map.setCenter new google.maps.LatLng(center.lat, center.lng)
    google.maps.event.trigger @map, 'resize'

  on: (event, callback) ->
    google.maps.event.addListener(@map, event, callback)
