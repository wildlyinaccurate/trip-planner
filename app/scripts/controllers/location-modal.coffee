'use strict'

tripPlannerApp.controller 'LocationModalCtrl', ($scope, dialog, query, locations, Geocoder) ->
  $scope.query = query
  $scope.locations = locations

  $scope.close = (location) ->
    dialog.close(location)
