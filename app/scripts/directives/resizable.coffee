'use strict'

tripPlannerApp.directive 'resizable', ->
  {
    link: (scope, element, attrs, ctrl) ->
      options = angular.extend {}, scope.$eval(attrs.resizable)
      element.resizable options
  }
