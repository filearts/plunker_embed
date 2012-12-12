#= require ../../vendor/prism/prism.js


#= require ../services/state


module = angular.module "plunker.source", [
  "plunker.state"
]

module.directive "plunkerHighlight", [ "$timeout", ($timeout) ->
  restrict: "E"
  replace: true
  scope:
    file: "="
  template: """
    <pre class="language-{{extension}}" ><code class="language-{{extension}}" ng-bind="file.content"></code></pre>
  """
  link: ($scope, $el, attrs) ->
    mapExtension = (filename) ->
      extension = filename.split(".")[1..].join(".")
      
      extensions = 
        html: "markup"
        js: "javascript"
        
      extensions[extension] or extension
    
    $scope.$watch "file.filename", (filename) ->
      $scope.extension = mapExtension(filename)
      $timeout -> Prism.highlightElement($el[0])
]


module.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/:id/*filename",
    template: """
      <plunker-highlight file="file"></plunker-highlight>
    """
    reloadOnSearch: true
    resolve:
      plunk: ["state", (state) ->
        state.plunk.$$refreshing or state.plunk
      ]
    controller: [ "$scope", "$routeParams", "state", "plunk", ($scope, $routeParams, state, plunk) ->
      state.filename = $routeParams.filename
      
      $scope.plunk = plunk
      $scope.file = plunk.files[$routeParams.filename]
    ]
]

