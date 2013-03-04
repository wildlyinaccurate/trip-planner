'use strict'

# Check if 2 floating point numbers are equal
#
# @see http://stackoverflow.com/a/588014
floatEqual = (f1, f2) ->
  (Math.abs(f1 - f2) < 0.000001)

angular.module('google-maps', []).directive 'googleMap', ($log, $timeout) ->
  {
    priority: 100,
    template: '<div class="angular-google-map" ng-transclude></div>',
    replace: false,
    transclude: true,
    restrict: 'EC',
    scope: {
      center: '=center',
      markers: '=markers',
      zoom: '=zoom',
      refresh: '&refresh'
    },

    link: (scope, element, attrs, ctrl) ->
      if !angular.isDefined(scope.center) || (!angular.isDefined(scope.center.lat) || !angular.isDefined(scope.center.lng))
        $log.error('google-maps: Could not find a valid center property')
        return

      angular.element(element).addClass 'angular-google-map'

      map = new GoogleMap(element[0], {
        center: scope.center,
        zoom: scope.zoom,
        draggable: attrs.draggable == 'true',
      })

      scope.$watch 'center', (newValue, oldValue) ->
        if !floatEqual(newValue.lat, oldValue.lat) or !floatEqual(newValue.lng, oldValue.lng)
          map.setCenter newValue
      , true

      map.on 'center_changed', ->
        $timeout ->
          scope.$apply ->
            scope.center.lat = map.center.lat()
            scope.center.lng = map.center.lng()

      map.on 'zoom_changed', ->
        $timeout ->
          scope.$apply ->
            scope.zoom = map.zoom

      map.on 'click', (event) ->
        map.addMarker(event.latLng.lat(), event.latLng.lng())
  }
