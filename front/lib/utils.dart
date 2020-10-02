import 'package:universal_html/html.dart';

String getLocalStorage() {
  var loc = window.localStorage['editorvisual_login_info'];
  return loc;
}

void setLocalStorage(String sessionId) {
  window.localStorage['editorvisual_login_info'] = sessionId;
}
