var jsdom = require("jsdom");
var LocalStorage = require('node-localstorage').LocalStorage;

jsdom.env(
  "<html></html>",
  ["index.js"],
  { virtualConsole: jsdom.createVirtualConsole().sendTo(console) },
  function (err, window) {
    window.localStorage = new LocalStorage('./localStorageTemp');
    window.Elm.Main.embed(window.document.body)
  }
);
