import 'package:flutter/foundation.dart';

printInDebug(String msg) {
  if(kDebugMode) {
    print(msg);
  }
}