var _gdotdesign$elm_storage$Native_Storage = function() {
  var tuple0 = _elm_lang$core$Native_Utils.Tuple0
  var err = _elm_lang$core$Result$Err
  var ok = _elm_lang$core$Result$Ok
  var just = _elm_lang$core$Maybe$Just
  var nothing = _elm_lang$core$Maybe$Nothing

  var error = function(type) {
    return err({ ctor: type })
  }

  var withStorage = function(kind, method) {
    try {
      var storage;

      switch(kind) {
        case 'local':
          storage = window.localStorage
          break
        case 'session':
          storage = window.sessionStorage
          break
      }

      var result = method(storage)

      return ok(result)
    } catch (error) {
      switch(error.type) {
        case 'SecurityError':
          return err('NotAllowed')
        case 'QuotaExceededError':
          return err('QuotaExceeded')
        default:
          return err('Unknown')
      }
    }
  }

  var get = function(kind, key) {
    return withStorage(kind, function(storage) {
      var result = storage.getItem(key)

      if(result) {
        return just(result)
      } else {
        return nothing
      }
    })
  }

  var set = function(kind, key, value) {
    return withStorage(kind, function(storage) {
      storage.setItem(key, value)
      return tuple0
    })
  }

  var clear = function(kind) {
    return withStorage(kind, function(storage) {
      storage.clear()
      return tuple0
    })
  }

  var remove = function(kind, key) {
    return withStorage(kind, function(storage) {
      storage.removeItem(kind)
      return tuple0
    })
  }

  return {
    remove: F2(remove),
    clear: clear,
    get: F2(get),
    set: F3(set)
  }
}()
