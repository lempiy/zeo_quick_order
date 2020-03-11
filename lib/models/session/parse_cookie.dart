import 'package:zeointranet/models/session/http_datetime.dart';

class CookieValue {
  final String key;
  final String value;
  DateTime expires;
  CookieValue(this.key, this.value, {expires}) : this.expires = expires;
}

Map<String, CookieValue> parseCookie(String allSetCookie) {
  if (allSetCookie != null) {
    var setCookies = [allSetCookie];
    return setCookies.fold(Map<String, CookieValue>(), (acc, setCookie) {
      List<String> cookies = setCookie.split(';');
      CookieValue _lastCookie;
      cookies.forEach((cookie) {
        CookieValue c = _getCookie(cookie);
        if (c != null) {
          if (c.expires != null) {
            if (_lastCookie == null) {
              return;
            }
            _lastCookie.expires = c.expires;
            return;
          } else if (_lastCookie != null) {
            acc[_lastCookie.key] = _lastCookie;
          }
          _lastCookie = c;
        }
        if (_lastCookie != null) {
          acc[_lastCookie.key] = _lastCookie;
        }
      });
      return acc;
    });
  }
  return null;
}

CookieValue _getCookie(String rawCookie) {
  if (rawCookie.length > 0) {
    var keyValue = rawCookie.split('=');
    if (keyValue.length == 2) {
      var key = keyValue[0].split(",").last.trim().toLowerCase();
      var value = keyValue[1];
      if (key == 'expires') {
        print(value);
        print(parseHttpDate(value));
        return CookieValue(key, value, expires: parseHttpDate(value));
      }
      // ignore keys that aren't cookies
      if (key == 'path' ||
          key == 'domain' ||
          key == 'secure' ||
          key == 'httponly') return null;

      return CookieValue(key, value);
    }
  }
  return null;
}
