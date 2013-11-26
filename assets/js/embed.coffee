require "../vendor/angular/angular"
require "../vendor/ui-router/ui-router"

module = angular.module "plunker.app.embed", [
  "ui.router"
]

module.config ["$stateProvider", "$urlRouterProvider", "$locationProvider", ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  
  $urlRouterProvider.when "/", "/create/index.html"
  $urlRouterProvider.when "/:plunkId", "/:plunkId/preview"
  
  $urlRouterProvider.otherwise("/new/index.html")
]

module.config ["$stateProvider", "$urlRouterProvider", ($stateProvider, $urlRouterProvider) ->
  
  $stateProvider.state "embed",
    url: "/:plunkId"
    abstract: true
    template: """
      <div ui-view></div>
    """
    controller: ["$stateParams", "$state", ($stateParams, $state) ->
      console.log "$stateParams", $stateParams.plunkId
      $state.go "embed.preview", plunkId: $stateParams.plunkId or "create" if $state.is("embed")
    ]

  $stateProvider.state "embed.start",
    url: "/"
    template: """
      <h1>Preview</h1>
    """
    controller: ["$state", ($state) ->
      $state.go "embed.preview"
    ]    
  
  $stateProvider.state "embed.readme",
    url: "/readme"
    template: """
      <h1>Readme</h1>
    """

  $stateProvider.state "embed.preview",
    url: "/preview"
    template: """
      <h1>Preview</h1>
    """

    
  $stateProvider.state "embed.file",
    url: "/:filename"
    template: """
      <h1>File</h1>
    """
]

module.run ["$rootScope", "$state", ($rootScope, $state) ->
  $rootScope.$on "$stateChangeSuccess", (e) -> console.log "[OK] State change", $state.current
]

