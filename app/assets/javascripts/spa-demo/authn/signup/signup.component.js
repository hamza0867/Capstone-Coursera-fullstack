(function () {
  "use strict";

  angular
    .module("spa-demo.authn")
    .component("sdSignup", {
      templateUrl: templateUrl,
      controller: SignupController,
      controllerAs: "$ctrl",
    });

  templateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function templateUrl(APP_CONFIG) {
    return APP_CONFIG.authn_signup_html;
  }

  SignupController.$inject = ["$scope", "$state", "spa-demo.authn.Authn"];
  function SignupController($scope, $state, Authn) {
    var $ctrl = this;
    $ctrl.signup = signup;
    $ctrl.signupForm = {};

    ////////////////

    function signup() {
      console.log("signup...");
      Authn.signup($ctrl.signupForm)
        .then(res => {
          $ctrl.id = res.data.data.id;
          console.log("signup complete", res.data, $ctrl);
          $state.go("home");
        })
        .catch(e => {
          console.log("signup failure", e, $ctrl);
          $ctrl.signupForm["errors"] = e.data.errors;
        });
    }

    $ctrl.$onInit = function () {
      console.log("Singup Controller", $scope);
    };
    $ctrl.$onChanges = function (changesObj) {
      console.log(changesObj);
    };
    $ctrl.$onDestroy = function () {};
  }
})();
