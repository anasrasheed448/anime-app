import 'package:flutter/services.dart';

class TVInfoProvider {
  bool isTV;

  Future initialize() async {
    try {
      isTV = await MethodChannel('tv_info').invokeMethod('isTV');
    } on PlatformException {
      isTV = false;
    } catch (e) {
      isTV = false;
    }
  }
}
