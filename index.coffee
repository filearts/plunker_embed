coffee = require("coffee-script")
less = require("less")
jade = require("jade")
express = require("express")
assets = require("connect-assets")
nconf = require("nconf")
request = require("request")
lactate = require("lactate")
path = require("path")

pkginfo = require("./package.json")

# process.env.NODE_ENV = "production"

# Set defaults in nconf
require "./configure"


apiUrl = nconf.get("url:api")
app = module.exports = express()


lactateOptions = 
  "max age": "one week"
  
assetOptions =
  src: "#{__dirname}/assets"
  buildDir: "assets/build"
  buildFilenamer: (filename) ->
    dir = path.dirname(filename)
    ext = path.extname(filename)
    base = path.basename(filename, ext)
    
    return path.join dir, "{base}-#{pkginfo.version}#{ext}"
  helperContext: app.locals

app.set "views", "#{__dirname}/views"
app.set "view engine", "jade"
app.set "view options", layout: false

app.use express.logger()
app.use require("./middleware/vary").middleware()
app.use lactate.static "#{__dirname}/build", lactateOptions
app.use lactate.static "#{__dirname}/assets", lactateOptions
app.use "/css/font", lactate.static("#{__dirname}/assets/vendor/Font-Awesome-More/font/", lactateOptions)

if process.env.NODE_ENV is "production"
  app.locals.js = (route) -> """<script src="/js/#{route}-#{pkginfo.version}.js"></script>"""
  app.locals.css = (route) -> """<link rel="stylesheet" href="/css/#{route}-#{pkginfo.version}.css" />"""
else
  app.use assets(assetOptions)
  
app.use express.cookieParser()
app.use express.bodyParser()
app.use require("./middleware/expose").middleware
  "url": nconf.get("url")
  "package": pkginfo

app.use app.router

app.use express.errorHandler()



app.get "/partials/:partial", (req, res, next) ->
  res.render "partials/#{req.params.partial}"


handlePlunk = (req, res, next) ->
  request.get "#{apiUrl}/plunks/#{req.params.id}", (err, response, body) ->
    return res.send(500) if err
    return res.send(response.statusCode) if response.statusCode >= 400
    
    try
      plunk = JSON.parse(response.body)
    catch e
      return res.send(500)
    
    unless plunk then res.send(404) # TODO: Better error page
    else
      res.locals.plunk = JSON.stringify(plunk).replace(/<\//g,"<\\/")
      res.render "embed"


app.get "/:id", handlePlunk
app.get "/:id*", handlePlunk
