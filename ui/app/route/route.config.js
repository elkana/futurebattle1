(function () {
  'use strict';

  angular.module('app.route')
    // global settings
    .constant('appConfig', {
      showHome: true
    })

    // global init
    .run(['$rootScope', '$state', 'appConfig', 'loginService',
      function($rootScope, $state, appConfig, loginService) {
        // add support for redirect states
        $rootScope.$on('$stateChangeStart', function(evt, to, params) {
          if (to.redirectTo) {
            evt.preventDefault();
            $state.go(to.redirectTo, params, {location: 'replace'});
          }
        });

        // expose appConfig to views
        $rootScope.appConfig = appConfig;

        // configure loginService
        loginService.protectedRoutes(['root.create', 'root.detail', 'root.profile', 'root.search']);
      }])

    .config(RouteConfig);

  RouteConfig.$inject = ['$stateProvider', '$urlMatcherFactoryProvider',
    '$urlRouterProvider', '$locationProvider', 'appConfig'
  ];

  function RouteConfig(
    $stateProvider,
    $urlMatcherFactoryProvider,
    $urlRouterProvider,
    $locationProvider,
    appConfig
  ) {

    $urlRouterProvider.otherwise('/');
    $locationProvider.html5Mode(true);

    function valToFromString(val) {
      return val !== null ? val.toString() : val;
    }

    function regexpMatches(val) { // jshint validthis:true
      return this.pattern.test(val);
    }

    $urlMatcherFactoryProvider.type('path', {
      encode: valToFromString,
      decode: valToFromString,
      is: regexpMatches,
      pattern: /.+/
    });

    $stateProvider
      .state('root', {
        url: '',
        abstract: true,
        templateUrl: 'app/root/root.html',
        controller: 'RootCtrl',
        controllerAs: '$rootCtrl',
        resolve: {
          user: function(userService) {
            return userService.getUser();
          }
        }
      });
    if (appConfig.showHome) {
      $stateProvider
        .state('root.landing', {
          url: '/',
          templateUrl: 'app/landing/landing.html',
          controller: 'LandingCtrl',
          controllerAs: '$ctrl',
          navLabel: {
            text: 'Home',
            area: 'dashboard',
            navClass: 'fa-home'
          }
        });
    } else {
      $stateProvider
        .state('root.landing', {
          url: '/',
          redirectTo: 'root.search'
        });
    }
    $stateProvider
      .state('root.search', {
        url: '/search?q',
        templateUrl: 'app/search/search.html',
        controller: 'SearchCtrl',
        controllerAs: '$ctrl',
        navLabel: {
          text: 'Search',
          area: 'dashboard',
          navClass: 'fa-search'
        }
      })
      .state('root.create', {
        url: '/create?prev',
        templateUrl: 'app/create/create.html',
        controller: 'CreateCtrl',
        controllerAs: '$ctrl',
        navLabel: {
          text: 'Create',
          area: 'dashboard',
          navClass: 'fa-wpforms',
          edit: true
        },
        resolve: {
          doc: function() {
            return null;
          }
        }
      })
      .state('root.edit', {
        url: '/edit{uri:path}?prev',
        templateUrl: 'app/create/create.html',
        controller: 'CreateCtrl',
        controllerAs: '$ctrl',
        resolve: {
          doc: function(MLRest, $stateParams) {
            var uri = $stateParams.uri;
            return MLRest.getDocument(uri).then(function(response) {
              return response;
            });
          }
        }
      })
      .state('root.view', {
        url: '/detail{uri:path}',
        params: {
          uri: {
            value: null
          }
        },
        templateUrl: 'app/detail/detail.html',
        controller: 'DetailCtrl',
        controllerAs: '$ctrl',
        resolve: {
		    doc: function(MLRest, $stateParams) {
            var uri = $stateParams.uri;
			var params = { format: 'xml'};
			if (uri.endsWith('.json')){
				params = { format: 'json', transform :'futurebattle-to-html'}
			}
				
            return MLRest.getDocument(uri, params).then(function(response) {
              return response;
            });

          }
		  
        }
      })
      .state('root.profile', {
        url: '/profile',
        templateUrl: 'app/user/profile.html',
        controller: 'ProfileCtrl',
        controllerAs: '$ctrl'
      })
      .state('root.login', {
        url: '/login?state&params',
        templateUrl: 'app/login/login-full.html',
        controller: 'LoginFullCtrl',
        controllerAs: '$ctrl'
      });
  }
}());
