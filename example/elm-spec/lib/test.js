var jsdom = require("jsdom");
var LocalStorage = require('node-localstorage').LocalStorage;
var colors = require('colors');

jsdom.env(
  "<html></html>",
  [__dirname + "/raf.js","index.js"],
  { virtualConsole: jsdom.createVirtualConsole().sendTo(console) },
  function (err, window) {
    window.localStorage = new LocalStorage('./localStorageTemp');
    var app = window.Elm.Main.embed(window.document.body)
    app.ports.report.subscribe(function(results){
      results.forEach(function(test){
        console.log("  " + test.name.bold)
        test.results.forEach(function(result){
          if(result.successfull) {
            console.log("   " + result.message.green)
          } else {
            console.log("   " + result.message.red)
          }
        })
        console.log("")
      })

      window.localStorage._deleteLocation()
    })
  }
);
