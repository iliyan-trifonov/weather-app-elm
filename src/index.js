"use strict";

require("ace-css/css/ace.css");
require("font-awesome/css/font-awesome.css");
require("./styles.css");
require("./YourFavFontHere.ttf");

require("./index.html");

var Elm = require("./App.elm");
var mountNode = document.getElementById("main");

var app = Elm.App.embed(mountNode);
