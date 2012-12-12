#= require ../../vendor/angular-sanitize
#= require ../../vendor/showdown/src/showdown

#= require ../services/state


module = angular.module "plunker.readme", [
  "ngSanitize"
  "plunker.state"
]

module.filter "markdown", [ () ->
  converter = new Showdown.converter()
  (value) -> if value then converter.makeHtml(value) else ""
]

module.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/:id/readme",
    template: """
      <div class="plunker-readme" ng-bind-html="readme | markdown">
    """
    reloadOnSearch: true
    resolve:
      plunk: ["state", (state) ->
        state.plunk.$$refreshing or state.plunk
      ]
    controller: [ "$scope", "state", "plunk", ($scope, state, plunk) ->
      
      $scope.readme = state.readme
      
      state.activateTab("readme")
    ]
]

