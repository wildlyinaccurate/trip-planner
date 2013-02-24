(function() {
  'use strict';

  describe('Controller: MainController', function() {
    var MainController, scope;
    beforeEach(module('tripPlannerApp'));
    MainController = {};
    scope = {};
    return beforeEach(inject(function($controller) {
      scope = {};
      return MainController = $controller('MainController', {
        $scope: scope
      });
    }));
  });

}).call(this);
