coffee = require("coffee-script")
less = require("less")
assets = require("connect-assets")
path = require("path")
fs = require("fs")
rimraf = require("rimraf")

pkginfo = require("./package.json")


assets
  src: "#{__dirname}/assets"
  build: true
  minify: true
  buildDir: "build"
  buildFilenamer: (filename) ->
    dir = path.dirname(filename)
    ext = path.extname(filename)
    base = path.basename(filename, ext)
    
    return path.join dir, "#{base}-#{pkginfo.version}#{ext}"

if fs.existsSync("#{__dirname}/build") then rimraf.sync("#{__dirname}/build")
  
console.log "Building embed.js"
js("pages/embed")

console.log "Building embed.css"
css("pages/embed")