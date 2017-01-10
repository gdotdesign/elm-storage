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
      var steps = results.reduce(function(memo, test) {
        return memo + test.results.length
      }, 0)

      var failed = results.reduce(function(memo, test) {
        return memo +  test.results.filter(function(result){ return !result.successfull }).length
      }, 0)

      var successfull = results.reduce(function(memo, test) {
        return memo + test.results.filter(function(result){ return result.successfull }).length
      }, 0)

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

      console.log(`${results.length} tests: ${steps} steps ${successfull} successfull ${failed} failed`)

      window.localStorage._deleteLocation()
    })
  }
);
