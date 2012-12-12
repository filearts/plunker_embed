#= require ../services/plunks

module = angular.module "plunker.state", [
  "plunker.plunks"
]

module.service "state", [ "$rootScope", "plunks", ($rootScope, plunks) ->
  new class Viewstate
    constructor: ->
      @tab = "preview"
      @filename = ""
      @plunk = plunk = plunks.findOrCreate(window._plunker.plunk)
      
      @refreshed_at = Date.now()
      
      $rootScope.$watch ( -> plunk.files ), (files) =>
        readmeRegex = /^readme(\.(md|markdown))?$/i
        for filename, file of files when filename.match(readmeRegex)
          return @readme = file.content
      , true
    
    activateTab: (@tab) ->
      @filename = ""
    refreshPreview: ->
      @refreshed_at = Date.now()
      
]