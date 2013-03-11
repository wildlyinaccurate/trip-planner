(function() {
  'use strict';

  window.tripPlannerApp = angular.module('tripPlannerApp', ['ui', 'ui.bootstrap.dialog']);

}).call(this);

(function() {
  'use strict';

  tripPlannerApp.directive('resizable', function() {
    return {
      link: function(scope, element, attrs, ctrl) {
        var options;
        options = angular.extend({}, scope.$eval(attrs.resizable));
        return element.resizable(options);
      }
    };
  });

}).call(this);

(function() {
  'use strict';

  var Geocoder;

  Geocoder = (function() {

    function Geocoder($q, $timeout) {
      this.$q = $q;
      this.$timeout = $timeout;
      this.geocoder = new google.maps.Geocoder();
    }

    Geocoder.prototype.geocode = function(options) {
      var deferred,
        _this = this;
      deferred = this.$q.defer();
      this.geocoder.geocode(options, function(results, status) {
        return _this.$timeout(function() {
          if (status === google.maps.GeocoderStatus.OK) {
            return deferred.resolve(results);
          } else {
            return deferred.reject(status);
          }
        });
      });
      return deferred.promise;
    };

    Geocoder.prototype.getLocation = function(latLng) {
      return this.geocode({
        'latLng': latLng
      });
    };

    Geocoder.prototype.getLatLng = function(location) {
      return this.geocode({
        'address': location
      });
    };

    return Geocoder;

  })();

  tripPlannerApp.factory('Geocoder', function($timeout, $q) {
    return new Geocoder($q, $timeout);
  });

}).call(this);

(function() {
  'use strict';

  var Directions;

  Directions = (function() {

    function Directions($q, $timeout) {
      this.$q = $q;
      this.$timeout = $timeout;
      this.directions = new google.maps.DirectionsService();
      this.directionsModes = {
        'Driving': google.maps.TravelMode.DRIVING,
        'Cycling': google.maps.TravelMode.BICYCLING,
        'Transit': google.maps.TravelMode.TRANSIT,
        'Walking': google.maps.TravelMode.WALKING
      };
    }

    Directions.prototype.setMap = function(map) {
      this.map = map;
    };

    Directions.prototype.getDirections = function(markers, options) {
      var deferred, marker, _i, _len,
        _this = this;
      markers = markers.slice(0);
      options = angular.extend(options, {
        origin: markers.shift().getPosition(),
        destination: markers.pop().getPosition(),
        provideRouteAlternatives: false,
        waypoints: [],
        optimizeWaypoints: true
      });
      for (_i = 0, _len = markers.length; _i < _len; _i++) {
        marker = markers[_i];
        options.waypoints.push({
          location: marker.getPosition(),
          stopover: false
        });
      }
      deferred = this.$q.defer();
      this.directions.route(options, function(results, status) {
        return _this.$timeout(function() {
          if (status === google.maps.DirectionsStatus.OK) {
            return deferred.resolve(results);
          } else {
            return deferred.reject(status);
          }
        });
      });
      return deferred.promise;
    };

    return Directions;

  })();

  tripPlannerApp.factory('Directions', function($timeout, $q) {
    return new Directions($q, $timeout);
  });

}).call(this);

(function() {
  'use strict';

  tripPlannerApp.controller('LocationModalCtrl', function($scope, dialog, query, locations, Geocoder) {
    $scope.query = query;
    $scope.locations = locations;
    return $scope.close = function(location) {
      return dialog.close(location);
    };
  });

}).call(this);

(function() {
  'use strict';

  tripPlannerApp.controller('MapCtrl', function($scope, $timeout, $q, $dialog, Geocoder, Directions) {
    var directionsDisplay;
    $scope.alerts = [];
    $scope.markers = [];
    $scope.locationText = {
      value: ''
    };
    $scope.mapOptions = {
      center: new google.maps.LatLng(50, 0),
      zoom: 9,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    $scope.directionsModes = Directions.directionsModes;
    directionsDisplay = new google.maps.DirectionsRenderer({
      preserveViewport: true
    });
    $scope.directionsMode = {
      value: $scope.directionsModes['Driving']
    };
    $scope.$watch('directionsMode.value', $scope.updateDirections);
    $scope.$watch('map', function(map) {
      return directionsDisplay.setMap(map);
    });
    $scope.updateDirections = function() {
      if (!($scope.markers.length >= 2)) {
        return;
      }
      return $timeout(function() {
        var promise;
        promise = Directions.getDirections($scope.markers, {
          travelMode: $scope.directionsMode.value
        });
        return promise.then(function(result) {
          var marker, _i, _len, _ref;
          _ref = $scope.markers;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            marker = _ref[_i];
            marker.setVisible(true);
          }
          $scope.markers[0].setVisible(false);
          $scope.markers[$scope.markers.length - 1].setVisible(false);
          return directionsDisplay.setDirections(result);
        }, function(reason) {
          return $scope.alerts.push("Unable to get directions. " + reason);
        });
      });
    };
    $scope.addMarker = function($event) {
      var marker, promise;
      marker = new google.maps.Marker({
        map: $scope.map,
        position: $event.latLng
      });
      $scope.markers.push(marker);
      promise = Geocoder.getLocation(marker.getPosition());
      promise.then(function(results) {
        return marker.location = results.shift();
      }, function(reason) {
        return $scope.alerts.push("Unable to reverse geocode marker. " + reason);
      });
      return $scope.updateDirections();
    };
    $scope.addLocation = function(location) {
      var addLocationDeferred;
      addLocationDeferred = $q.defer();
      addLocationDeferred.promise.then(function(location) {
        $scope.addMarker({
          latLng: location.geometry.location
        });
        return $timeout(function() {
          return $scope.locationText.value = '';
        });
      });
      return Geocoder.getLatLng(location).then(function(results) {
        var dialog, promise;
        if (results.length === 1) {
          return addLocationDeferred.resolve(results[0]);
        } else {
          dialog = $dialog.dialog({
            resolve: {
              query: function() {
                return location;
              },
              locations: function() {
                return results;
              }
            }
          });
          promise = dialog.open('views/location-modal.html', 'LocationModalCtrl');
          return promise.then(function(location) {
            return addLocationDeferred.resolve(location);
          });
        }
      });
    };
    $scope.removeMarker = function(index) {
      var marker;
      marker = $scope.markers.splice(index, 1)[0];
      marker.setMap(null);
      return $scope.updateDirections();
    };
    if (navigator.geolocation) {
      return navigator.geolocation.getCurrentPosition(function(position) {
        $scope.map.panTo(new google.maps.LatLng(position.coords.latitude, position.coords.longitude));
        return $scope.$apply();
      }, function(error) {
        $scope.alerts.push("We weren't able to determine your current location.");
        return $scope.$apply();
      });
    }
  });

}).call(this);
