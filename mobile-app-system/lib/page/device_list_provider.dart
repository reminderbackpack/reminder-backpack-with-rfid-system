import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceListProvider extends ChangeNotifier {
  StreamSubscription<BluetoothDiscoveryResult>? streamSubscription;
  List<BluetoothDiscoveryResult> discoveredDevice = [];
  bool isDiscovering = false;

  void searchDevice() {
    discoveredDevice.clear();
    isDiscovering = true;
    // notifyListeners();

    streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      final existingIndex = discoveredDevice.indexWhere((element) => element.device.address == r.device.address);
      if (existingIndex >= 0) {
        discoveredDevice[existingIndex] = r;
      } else {
        discoveredDevice.add(r);
      }
      notifyListeners();
    });

    streamSubscription!.onDone(() {
      isDiscovering = false;
      notifyListeners();
    });
  }
}
