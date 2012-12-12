#= require ../services/state


module = angular.module "plunker.preview", [
  "plunker.state"
]

module.directive "plunkerPreviewer", [ "state", (state) ->
  restrict: "E"
  replace: true
  scope:
    plunk: "="
  template: """
    <iframe class="plunker-previewer" ng-src="{{plunk.raw_url}}" frameborder="0" width="100%" height="100%"></iframe>
  """
  link: ($scope, $el, attrs) ->
    $scope.state = state
    
    $scope.$watch "state.refreshed_at", ->
      $el[0].src = $el[0].src
]


module.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/:id", redirectTo: "/:id/preview"
  $routeProvider.when "/:id/preview",
    template: """
      <plunker-previewer plunk="plunk"></plunker-previewer>
    """
    reloadOnSearch: true
    resolve:
      plunk: ["state", (state) ->
        state.plunk.$$refreshing or state.plunk
      ]
    controller: [ "$scope", "state", "plunk", ($scope, state, plunk) ->
      $scope.plunk = plunk
      
      state.activateTab("preview")
    ]
]

