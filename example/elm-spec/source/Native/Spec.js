var _gdotdesign$elm_storage$Native_Spec = function() {
  var task = _elm_lang$core$Native_Scheduler.nativeBinding
  var succeed = _elm_lang$core$Native_Scheduler.succeed
  var fail = _elm_lang$core$Native_Scheduler.fail
  var tuple0 = _elm_lang$core$Native_Utils.Tuple0

  var haveText = function(value, selector){
    return task(function(callback){
      requestAnimationFrame(function(){
        try {
          var el = document.querySelector(selector)
          if(el.textContent === value) {
            callback(succeed("Text of " + selector + " equals " + value))
          } else {
            callback(fail("Text of " + selector + ": " + value + " <=> " + el.textContent))
          }
        } catch (e) {
          callback(fail("Element not found: " + selector))
        }
      })
    })
  }

	var click = function(selector){
    return task(function(callback){
      requestAnimationFrame(function(){
        try {
          document.querySelector(selector).click()
          callback(succeed("Clicked: " + selector))
        } catch (e) {
          callback(fail(""))
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
    haveText: F2(haveText),
		click: click,
    uid: uid
	}
}()
