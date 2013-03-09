'use strict'

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
        marker = map.addMarker event.latLng.lat(), event.latLng.lng()

        if marker
          $timeout ->
            scope.$apply ->
              scope.markers.push marker;
  }
