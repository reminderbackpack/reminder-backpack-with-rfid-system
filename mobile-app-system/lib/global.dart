import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var editSensorController1 = TextEditingController();
var editSensorController2 = TextEditingController();
var editSensorController3 = TextEditingController();

bool statusSensor1 = true;
bool statusSensor2 = true;
bool statusSensor3 = true;

String deviceAddress = '';
bool bluetoothEnable = false;
bool deviceConnected = false;

ValueNotifier<String> statusBarang = ValueNotifier('222');

BluetoothState bluetoothState = BluetoothState.UNKNOWN;
BluetoothDevice selectedDevice = const BluetoothDevice(address: '');
BluetoothConnection? connection;
bool get isConnected => (connection?.isConnected ?? false);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('Backpack', 'Warning',
    channelDescription: 'Warning lost item', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

