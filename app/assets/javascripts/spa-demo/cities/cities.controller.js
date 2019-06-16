(function() {
  'use strict';
  angular
    .module('spa-demo.cities')
    .controller('spa-demo.cities.CitiesController', CitiesController);
  CitiesController.$inject = ['spa-demo.cities.City'];

  function CitiesController(City) {
    const vm = this;
    vm.cities;
    vm.city;
    vm.create = create;
    vm.edit = edit;
    vm.remove = remove;
    vm.update = update;

    activate();
    return;
    function activate() {
      newCity();
      vm.cities = City.query();
    }

    function newCity() {
      vm.city = new City();
    }

    function handleError(err) {
      console.warn(err);
    }

    function edit(object) {
      vm.city = object;
    }

    function create() {
      vm.city
        .$save()
        .then(function() {
          vm.cities.push(vm.city);
          newCity();
        })
        .catch(handleError);
    }

    function update() {
      vm.city.$update().catch(handleError);
    }

    function remove() {
      vm.city.$delete().then(function() {
        vm.cities = City.query();
        newCity();
      });
    }

    function removeElement(elements, element) {}
  }
})();
