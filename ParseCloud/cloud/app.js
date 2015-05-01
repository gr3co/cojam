
// These two lines are required to initialize Express in Cloud Code.
var express = require("express"),
app = express(),
crypto = require('crypto'),
buffer = require('buffer'),
url = require('url');


var config = new Parse.Object("Config");
config.set("spotify_client_id", "100501836e2e494c97c10613da0587d2");
config.set("spotify_client_secret", "9129022efdda416bb2be0f7c676822c4");
config.set("spotify_callback_url", "cojam-spotify://callback");
config.set("spotify_endpoint", "https://accounts.spotify.com");

var AUTH_HEADER = "Basic " + new buffer.Buffer(config.get("spotify_client_id") + ":" + config.get("spotify_client_secret")).toString("base64");

app.use(express.bodyParser());

app.post("/swap", function (req, res) {
         if (!req.body || !req.body.hasOwnProperty("code")) {
         res.status(550).send("Permission Denied");
         return;
         }
         
         var form_data = {
         "grant_type": "authorization_code",
         "redirect_uri": config.get("spotify_callback_url"),
         "code": req.body.code
         };
         
         Parse.Cloud.httpRequest({
                                 method: "POST",
                                 url: url.resolve(config.get("spotify_endpoint"), "/api/token"),
                                 headers: {
                                 "Authorization": AUTH_HEADER,
                                 "Content-Type": "application/x-www-form-urlencoded"
                                 },
                                 body: form_data,
                                 success: function(httpResponse) {
                                 if (httpResponse.status != 200) {
                                 res.status(550).send("Permission Denied");
                                 return;
                                 }
                                 
                                 var token_data = JSON.parse(httpResponse.text);
                                 
                                 res.status(200).set({"Content-Type": "application/json"}).send(token_data);
                                 },
                                 error: function(httpResponse) {
                                 res.status(500).send("Internal Server Error");
                                 return;
                                 }
                                 });
         });

app.post("/refresh", function (req, res) {
         if (!req.body || !req.body.hasOwnProperty("refresh_token")) {
         res.status(550).send("Permission Denied");
         return;
         }
         
         var refresh_token = req.body.refresh_token;
         
         var form_data = {
         "grant_type": "refresh_token",
         "refresh_token": refresh_token
         };
         
         Parse.Cloud.httpRequest({
                                 method: "POST",
                                 url: url.resolve(config.get("spotify_endpoint"), "/api/token"),
                                 headers: {
                                 "Authorization": AUTH_HEADER,
                                 "Content-Type": "application/x-www-form-urlencoded"
                                 },
                                 body: form_data,
                                 success: function(httpResponse) {
                                 if (httpResponse.status != 200) {
                                 res.status(550).send("Permission Denied");
                                 return;
                                 }
                                 
                                 res.status(httpResponse.status).set({
                                                                     "Content-Type": "application/json"
                                                                     }).send(httpResponse.text);
                                 
                                 },
                                 error: function(httpResponse) {
                                 res.status(500).send("Internal Server Error");
                                 return;
                                 }
                                 });
         
         });

app.post("/api/token", function (req, res) {
         
         res.status(200).set({"Content-Type": "application/json"});
         
         switch (req.body.grant_type) {
         case "authorization_code": {
         res.status(200).set({"Content-Type": "application/json"})
         .send({"refresh_token": "REFRESH TOKEN"});
         } break;
         case "refresh_token": {
         res.status(200).set({"Content-Type": "application/json"})
         .send({"access_token": "ACCESS TOKEN"});
         } break;
         default: {
         res.status(550).set({"Content-Type": "text/html"})
         .send("<html><body><h1>Access Denied</h1></body></html>");
         } break;
         }
         });


app.get('/', function(req, res) {
    res.send("Hello");
});


app.listen();
