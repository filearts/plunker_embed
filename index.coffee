express = require("express")
expstate = require("express-state")
lactate = require("lactate")
request = require("request")
nconf = require("nconf")
hbs = require("hbs")

pkg = require("./package.json")


# Set defaults in nconf
require "./configure"


server = express()
apiUrl = nconf.get("url:api")

expstate.extend(server)

hbs.registerHelper "expose", (exposed) -> hbs.handlebars.SafeString(exposed.toString().replace(/<\//g, "<\\/").replace(/-->/g, "--\\>"))


# Configure express
server.enable "trust proxy"

server.engine "html", hbs.__express

server.set "view engine", "html"
server.set "views", "#{process.env.PWD}/views"


# Express middleware

server.use require("./middleware/vary").middleware()
server.use lactate.static "#{process.env.PWD}/public",
  "max age": "one week"
server.use server.router


servePlunk = (req, res, next) ->
  expose =
    version: pkg.version
    cachebuster: if process.env.NODE_ENV is "production" then "" else "?cachebuster=#{Date.now()}"
    plunk:
      description: ""
      files:
        'index.html': ""
    
  respond = ->
    res.expose expose
    res.render "index", expose
  
  if req.params.plunkId
    options =
      json: true
      url: "#{apiUrl}/plunks/#{req.params.plunkId}"
    
    request options, (err, response, body) ->
      if err then respond()
      if response.statusCode >= 400 then respond()
      if !body then respond()
      
      expose.plunk = body
      
      respond()
  
  else respond()


server.get "/:plunkId", servePlunk
server.get "/", servePlunk


module.exports = server