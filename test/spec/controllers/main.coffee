'use strict'

describe 'Controller: MainController', () ->

  # load the controller's module
  beforeEach module 'tripPlannerApp'

  MainController = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller) ->
    scope = {}
    MainController = $controller 'MainController', {
      $scope: scope
    }
