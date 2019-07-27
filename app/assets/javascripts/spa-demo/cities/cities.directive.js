(function () {
  "use strict";
  angular
    .module("spa-demo.cities")
    .directive("sdCities", CitiesDirective);

  CitiesDirective.$inject = ["spa-demo.config.APP_CONFIG"];

  function CitiesDirective(APP_CONFIG) {
    const ddo = {
      templateUrl: APP_CONFIG.cities_html,
      replace: true,
      bindToController: true,
      controller: "spa-demo.cities.CitiesController",
      controllerAs: "citiesVM",
      restrict: "E",
      scope: {},
      link: link
    };

    return ddo;

    function link(scope, element, attrs) {
      console.log("CitiesDirective", scope);
    }
  }
})();
