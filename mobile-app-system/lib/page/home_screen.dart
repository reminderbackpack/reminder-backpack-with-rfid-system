import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:myapp/global.dart';
import 'package:myapp/page/about_us.dart';
import 'package:myapp/page/bluetooth_pairing.dart';
import 'package:myapp/page/list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Timer? _discoverableTimeoutTimer;
  String messageBuffer = '';
  String messageRecieved = '';
  String pesan = '';
  bool status1 = false;
  bool status2 = false;
  bool status3 = false;
  int retryToConnect = 0;

  @override
  void initState() {
    customInit();
    super.initState();
  }

  customInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    editSensorController1.text = prefs.getString('namaSensor1') ?? 'Barang 1';
    editSensorController2.text = prefs.getString('namaSensor2') ?? 'Barang 2';
    editSensorController3.text = prefs.getString('namaSensor3') ?? 'Barang 3';
    statusSensor1 = prefs.getBool('statusSensor1') ?? true;
    statusSensor2 = prefs.getBool('statusSensor2') ?? true;
    statusSensor3 = prefs.getBool('statusSensor3') ?? true;
    deviceAddress = prefs.getString('deviceAddress') ?? '';

    await FlutterBluetoothSerial.instance.state.then((blState) async {
      if (blState.isEnabled) {
        setState(() {
          bluetoothEnable = blState.isEnabled;
        });
        if (deviceAddress != '') {
          await FlutterBluetoothSerial.instance.getBondStateForAddress(deviceAddress).then((bondedStatus) {
            if (bondedStatus.isBonded) {
              selectedDevice = BluetoothDevice(
                address: deviceAddress,
                bondState: bondedStatus,
              );
              connectBluetooth();
            } else {}
          });
        }
      }
    });

    Future.doWhile(() async {
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      setState(() {});
    });

    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        bluetoothState = state;
        bluetoothEnable = bluetoothState.isEnabled;
      });
    });
  }

  connectBluetooth() async {
    await BluetoothConnection.toAddress(selectedDevice.address).then((blConnection) {
      connection = blConnection;
      setState(() {
        deviceConnected = true;
      });
      connection!.input!.listen(_onDataReceived).onDone(() {
        connection?.dispose();
        connection = null;
        setState(() {
          deviceConnected = false;
        });
        tampilkanPesanPopUp('Perhatian!', 'Koneksi bluettoth dengan perangakat terputus.');
      });
    }).catchError((error) {
      if (retryToConnect <= 3) {
        Future.delayed(const Duration(milliseconds: 500), () {
          retryToConnect = retryToConnect + 1;
          connectBluetooth();
        });
      } else {
        setState(() {
          deviceConnected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    if (isConnected) {
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  Future<bool> onWillPop() async {
    MoveToBackground.moveTaskToBack();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return WillPopScope(
        onWillPop: onWillPop,
        child: SingleChildScrollView(
            child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(
                60 * fem, !bluetoothEnable || !deviceConnected ? 225 * fem : 288 * fem, 51 * fem, !bluetoothEnable || !deviceConnected ? 260 * fem : 260 * fem),
            // height: MediaQuery.of(context).size.height + 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/page-1/images/homepage-dashboard-bg.png',
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !bluetoothEnable || !deviceConnected,
                  child: Text(
                    !bluetoothEnable ? 'Aktifkan Bluetooth !.\n' : 'Tidak terhubung !, Silahkan pairing terlebih dahulu\n',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 67 * fem),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 63 * fem, 0 * fem),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              connection?.dispose();
                              connection = null;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BlueToothPage(connectBluetooth)),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: SizedBox(
                            width: 87 * fem,
                            height: 99 * fem,
                            child: Image.asset(
                              'assets/page-1/images/bluetooth-pairing-logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        // listlogops7 (3:11)
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SensorList()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: SizedBox(
                          width: 99 * fem,
                          height: 101 * fem,
                          child: Image.asset(
                            'assets/page-1/images/list-logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // aboutuslogoAAH (4:14)
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 6 * fem, 0 * fem),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutUs()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: SizedBox(
                      width: 91 * fem,
                      height: 91 * fem,
                      child: Image.asset(
                        'assets/page-1/images/about-us-logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      messageRecieved =
          backspacesCounter > 0 ? messageBuffer.substring(0, messageBuffer.length - backspacesCounter) : messageBuffer + dataString.substring(0, index);
      messageBuffer = dataString.substring(index);

      String diterima = messageRecieved.toString().trim();
      if (statusSensor1 && diterima == '10') {
        tampilkanPesanPopUp('RFID 1', '${editSensorController1.text} Barang Tertinggal !');
        statusBarang.value = '0${statusBarang.value.substring(1, 3)}';
      }
      if (statusSensor2 && diterima == '20') {
        tampilkanPesanPopUp('RFID 2', '${editSensorController2.text} Barang Tertinggal !');
        statusBarang.value = '${statusBarang.value.substring(0, 1)}0${statusBarang.value.substring(2, 3)}';
      }

      if (statusSensor3 && diterima == '30') {
        tampilkanPesanPopUp('RFID 3', '${editSensorController3.text} Barang Tertinggal!');
        statusBarang.value = '${statusBarang.value.substring(0, 2)}0';
      }

      if (statusSensor1 && diterima == '11') {
        statusBarang.value = '1${statusBarang.value.substring(1, 3)}';
      }

      if (statusSensor2 && diterima == '21') {
        statusBarang.value = '${statusBarang.value.substring(0, 1)}1${statusBarang.value.substring(2, 3)}';
      }

      if (statusSensor3 && diterima == '31') {
        statusBarang.value = '${statusBarang.value.substring(0, 2)}1';
      }
    } else {
      messageBuffer = (backspacesCounter > 0 ? messageBuffer.substring(0, messageBuffer.length - backspacesCounter) : messageBuffer + dataString);
    }
  }
}

tampilkanPesanPopUp(header, content) async {
  await flutterLocalNotificationsPlugin.show(
    1,
    header,
    content,
    notificationDetails,
  );
}
