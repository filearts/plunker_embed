#= require ../../vendor/bootstrap/js/bootstrap-dropdown

module = angular.module "plunker.filelist", []

module.directive "plunkerFileitem", [ "state", (state) ->
  restrict: "E"
  replace: true
  scope:
    file: "="
    plunk: "="
  template: """
    <li class="plunker-fileitem" ng-class="{active: file.filename==state.tab}">
      <a ng-href="/{{plunk.id}}/{{file.filename}}">
        <i class="icon-file"></i>
        <span class="filename">{{file.filename}}</span>
      </a>
    </li>
  """
  link: ($scope, $el, attrs) ->
    $scope.state = state
]


module.directive "plunkerFilelist", [ "state", (state) ->
  restrict: "E"
  replace: true
  template: """
    <ul class="plunker-filelist nav">
      <li class="dropdown" ng-class="{active: !!state.filename}">
        <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
          {{state.filename || "Source code"}}
          <b class="caret"></b>
        </a>
        <ul class="dropdown-menu">
          <plunker-fileitem file="file" plunk="plunk" ng-repeat="file in plunk.files"></plunker-fileitem>
        </ul>
    </ul>
  """
  link: ($scope, $el, attrs) ->
]