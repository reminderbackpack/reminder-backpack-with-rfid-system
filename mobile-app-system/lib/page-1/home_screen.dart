// ignore_for_file: unused_import, unused_local_variable
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/global.dart';
import 'package:myapp/page-1/about_us.dart';
import 'package:myapp/page-1/bluetooth_pairing.dart';
import 'package:myapp/page-1/list_page.dart';
import 'package:myapp/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_beep/flutter_beep.dart';

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

  @override
  void initState() {
    customInit();
    super.initState();
  }

  customInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    editSensorController1.text = 'RFID 1';
    editSensorController2.text = 'RFID 2';
    editSensorController3.text = 'RFID 3';
    editSensorController1.text = prefs.getString('namaSensor1') ?? '';
    editSensorController2.text = prefs.getString('namaSensor2') ?? '';
    editSensorController3.text = prefs.getString('namaSensor3') ?? '';
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
          await FlutterBluetoothSerial.instance
              .getBondStateForAddress(deviceAddress)
              .then((bondedStatus) {
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

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothState = state;
        bluetoothEnable = bluetoothState.isEnabled;
      });
    });
  }

  connectBluetooth() async {
    await BluetoothConnection.toAddress(selectedDevice.address)
        .then((blConnection) {
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
        Vibration.vibrate(duration: 1000);
        Vibration.vibrate(duration: 1000);
        FlutterBeep.beep(false);
        FlutterBeep.beep(false);
        FlutterBeep.beep(false);
      });
    }).catchError((error) {
      setState(() {
        deviceConnected = false;
      });
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
        child: SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            60 * fem,
            !bluetoothEnable || !deviceConnected ? 251 * fem : 288 * fem,
            51 * fem,
            !bluetoothEnable || !deviceConnected ? 260 * fem : 260 * fem),
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
                !bluetoothEnable
                    ? 'Aktifkan Bluetooth !.\n'
                    : 'Tidak terhubung !\n',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 67 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 63 * fem, 0 * fem),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          connection?.dispose();
                          connection = null;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BlueToothPage(connectBluetooth)),
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
                        MaterialPageRoute(
                            builder: (context) => const SensorList()),
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
    ));
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
      setState(() async {
        messageRecieved = backspacesCounter > 0
            ? messageBuffer.substring(
                0, messageBuffer.length - backspacesCounter)
            : messageBuffer + dataString.substring(0, index);
        messageBuffer = dataString.substring(index);

        String diterima = messageRecieved.toString().trim();
        if (statusSensor1 && diterima == '10') {
          pesanDitampilkan1.value = editSensorController1.text;
          Vibration.vibrate(duration: 1000);
          FlutterBeep.beep(false);
        }
        if (statusSensor2 && diterima == '20') {
          pesanDitampilkan2.value = editSensorController2.text;
          Vibration.vibrate(duration: 1000);
          FlutterBeep.beep(false);
        }

        if (statusSensor3 && diterima == '30') {
          pesanDitampilkan3.value = editSensorController3.text;
          Vibration.vibrate(duration: 1000);
          FlutterBeep.beep(false);
        }

        if (statusSensor1 && diterima == '11') {
          pesanDitampilkan1.value = '';
        }
        if (statusSensor2 && diterima == '21') {
          pesanDitampilkan2.value = '';
        }

        if (statusSensor3 && diterima == '31') {
          pesanDitampilkan3.value = '';
        }

        if (statusPesan &&
            (pesanDitampilkan1.value == '' &&
                pesanDitampilkan2.value == '' &&
                pesanDitampilkan3.value == '')) {
          statusPesan = false;
          Navigator.pop(context);
        }

        if ((pesanDitampilkan1.value != '' ||
                pesanDitampilkan2.value != '' ||
                pesanDitampilkan3.value != '') &&
            !statusPesan) {
          tampilkanPesan(context);
        }
      });
    } else {
      messageBuffer = (backspacesCounter > 0
          ? messageBuffer.substring(0, messageBuffer.length - backspacesCounter)
          : messageBuffer + dataString);
    }
  }
}

Future<String?> tampilkanPesan(BuildContext context) {
  statusPesan = true;
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Perhatian !'),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 150),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder(
                  valueListenable: pesanDitampilkan1,
                  builder: (context, value, _) {
                    return Text(
                      pesanDitampilkan1.value,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: pesanDitampilkan2,
                  builder: (context, value, _) {
                    return Text(
                      pesanDitampilkan2.value,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: pesanDitampilkan3,
                  builder: (context, value, _) {
                    return Text(
                      pesanDitampilkan3.value,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Barang hilang !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 252, 3, 3)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 35,
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                statusPesan = false;
                pesanDitampilkan1.value = '';
                pesanDitampilkan2.value = '';
                pesanDitampilkan3.value = '';
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFff0000),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tutup',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
