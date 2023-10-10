import 'dart:io';

import 'package:flutter/foundation.dart';

class CompatabilityService {
  bool isWeb = false;
  bool isMac = false;
  bool isMobile = false;

  CompatabilityService() {
    if (kIsWeb) {
      isWeb = true;
    } else {
      if (Platform.isIOS || Platform.isAndroid) {
        isMobile = true;
      } else {
        isMac = true;
      }
    }
  }
}
