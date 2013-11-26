path = require("path")

module.exports = (grunt) ->
  grunt.initConfig 
    pkg: grunt.file.readJSON('package.json')

    build:
      src: 'assets',
      dest: 'public'
    
    less:
      compile:
        files:
          '<%=build.dest%>/css/embed.<%=pkg.version%>.css': ['<%=build.src%>/css/embed.less']
      build:
        #options:
        #  compress: true
        files:
          '<%=build.dest%>/css/embed.<%=pkg.version%>.css': ['<%=build.src%>/css/embed.less']
          
    watch:
      scripts:
        files: ['<%=build.src%>/**/*.coffee', '<%=build.src%>/**/*.js']
        tasks: ['browserify:compile']
      styles:
        files: ["<%=build.src%>/**/*.less", "<%=build.src%>/**/*.css"]
        tasks: ['less:compile']
      options:
        nospawn: true

    browserify:
      compile:
        files:
          '<%=build.dest%>/js/embed.<%=pkg.version%>.js': ['<%=build.src%>/js/embed.coffee']
        options:
          debug: true
          transform: ['caching-coffeeify']
          noParse: ['<%=build.src%>/vendor/angular/angular.js','<%=build.src%>/vendor/ui-router/ui-router.js','<%=build.src%>/vendor/angular-ui/ui-bootstrap.js']
          

  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-browserify'

  grunt.registerTask 'default', ['compile', 'watch']
  grunt.registerTask 'compile', ['browserify:compile', 'less:compile']