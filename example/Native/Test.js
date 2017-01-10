var _gdotdesign$elm_storage$Native_Test = function() {
  window.localStorage.clear()
  var task = _elm_lang$core$Native_Scheduler.nativeBinding
  var succeed = _elm_lang$core$Native_Scheduler.succeed

  var assertText = function(selector, value){
    return task(function(callback){
      requestAnimationFrame(function(){
        try {
          var el = document.querySelector(selector)
          console.log(el, el.textContent, value)
          callback(succeed(el.textContent === value))
        } catch (e) {
          callback(succeed(false))
        }
      })
    })
  }

	var click = function(selector){
    return task(function(callback){
      requestAnimationFrame(function(){
        try {
          document.querySelector(selector).click()
          callback(succeed(true))
        } catch (e) {
          callback(succeed(false))
        }
      })
    })
	}

	function s(n) {
    return h((Math.random() * (1<<(n<<2)))^Date.now()).slice(-n)
  }

  function h(n) {
    return (n|0).toString(16)
  }

  function uid(){
    return [
      s(4) + s(4), s(4), '4' + s(3),
      h(8|(Math.random()*4)) + s(3),
      Date.now().toString(16).slice(-10) + s(2)
    ].join('-')
  }

	return {
    assertText: F2(assertText),
		click: click,
    uid: uid
	}
}()
