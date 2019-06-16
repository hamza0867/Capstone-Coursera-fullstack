(function() {
  'use strict';
  angular
    .module('spa-demo.foos')
    .controller('spa-demo.foos.FoosController', FoosController);
  FoosController.$inject = ['spa-demo.foos.Foo'];

  function FoosController(Foo) {
    const vm = this;
    vm.foos;
    vm.foo;
    vm.create = create;
    vm.edit = edit;
    vm.remove = remove;
    vm.update = update;

    activate();
    return;
    function activate() {
      newFoo();
      vm.foos = Foo.query();
    }

    function newFoo() {
      vm.foo = new Foo();
    }

    function handleError(err) {
      console.warn(err);
    }

    function edit(object) {
      vm.foo = object;
    }

    function create() {
      vm.foo
        .$save()
        .then(function() {
          vm.foos.push(vm.foo);
          newFoo();
        })
        .catch(handleError);
    }

    function update() {
      vm.foo.$update().catch(handleError);
    }

    function remove() {
      vm.foo.$delete().then(function() {
        vm.foos = Foo.query();
        newFoo();
      });
    }

    function removeElement(elements, element) {}
  }
})();
