#= require ../../vendor/angular

#= require ../controllers/preview
#= require ../controllers/readme
#= require ../controllers/source

#= require ../services/state
#= require ../services/plunks

#= require ../directives/filelist

module = angular.module "plunker.embed", [
  "plunker.state"
  "plunker.preview"
  "plunker.readme"
  "plunker.source"
  "plunker.plunks"
  "plunker.filelist"
]

module.config ["$locationProvider", ($locationProvider) ->
  $locationProvider.html5Mode(true)
]

module.run ["$rootScope", "state", ($rootScope, state) ->
  $rootScope[k] = v for k, v of window._plunker
  
  $rootScope.state = state
]