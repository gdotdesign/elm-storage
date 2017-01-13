var _gdotdesign$elm_storage$Native_Storage = function() {
  var fromArray = _elm_lang$core$Native_List.fromArray
  var tuple0 = _elm_lang$core$Native_Utils.Tuple0
  var nothing = _elm_lang$core$Maybe$Nothing
  var just = _elm_lang$core$Maybe$Just
  var err = _elm_lang$core$Result$Err
  var ok = _elm_lang$core$Result$Ok

  var error = function(type) {
    return err({ ctor: type })
  }

  var withErrors = function(method) {
    try {
      return method()
    } catch (error) {
      switch(error.name) {
        case 'SecurityError':
          return err('NotAllowed')
        case 'QUOTA_EXCEEDED_ERR':
          return err('QuotaExceeded')
        case 'QuotaExceededError':
          return err('QuotaExceeded')
        default:
          return err('Unknown')
      }
    }
  }

  var withStorage = function(kind, method) {
    return withErrors(function(){
      var storage;

      switch(kind) {
        case 'local':
          storage = window.localStorage
          break
        case 'session':
          storage = window.sessionStorage
          break
      }

      return method(storage)
    })
  }

  var get = function(kind, key) {
    return withStorage(kind, function(storage) {
      var result = storage.getItem(key)

      if(result) {
        return ok(just(result))
      } else {
        return ok(nothing)
      }
    })
  }

  var set = function(kind, key, value) {
    return withStorage(kind, function(storage) {
      storage.setItem(key, value)
      return ok(tuple0)
    })
  }

  var clear = function(kind) {
    return withStorage(kind, function(storage) {
      storage.clear()
      return ok(tuple0)
    })
  }

  var remove = function(kind, key) {
    return withStorage(kind, function(storage) {
      storage.removeItem(key)
      return ok(tuple0)
    })
  }

  var length = function(kind) {
    return withStorage(kind, function(storage) {
      return storage.length
    })
  }

  var keys = function(kind) {
    return withStorage(kind, function(storage) {
      var keys = []
      if(storage._keys) { return fromArray(storage._keys.sort()) }
      for (var key in storage) { keys.push(key) }
      return fromArray(keys.sort())
    })
  }

  var getCookie = function(name) {
    return withErrors(function(){
      var value = Cookies.get(name)
      if (value) {
        return ok(just(value))
      } else {
        return ok(nothing)
      }
    })
  }

  var setCookie = function(name, value, options) {
    return withErrors(function(){
      Cookies.set(name, value, options)
      return ok(tuple0)
    })
  }

  var clearCookies = function() {
    return withErrors(function(){
      for (var key in Cookies.get()) {
        Cookies.remove(key)
      }
      return ok(tuple0)
    })
  }

  var removeCookie = function(name) {
    return withErrors(function(){
      Cookies.remove(name)
      return ok(tuple0)
    })
  }

  var cookiesLength = function() {
    return withErrors(function(){
      return Object.keys(Cookies.get()).length
    })
  }

  var cookieKeys = function(){
    return withErrors(function(){
      return fromArray(Object.keys(Cookies.get()).sort())
    })
  }

  return {
    cookiesLength: cookiesLength,
    clearCookies: clearCookies,
    removeCookie: removeCookie,
    setCookie: F2(setCookie),
    cookieKeys: cookieKeys,
    getCookie: getCookie,
    remove: F2(remove),
    length: length,
    clear: clear,
    get: F2(get),
    set: F3(set),
    keys: keys
  }
}()
