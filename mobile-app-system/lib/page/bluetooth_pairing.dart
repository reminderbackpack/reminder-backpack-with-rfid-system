import 'package:flutter/material.dart';
import 'package:myapp/global.dart';
import 'package:myapp/page/device_list_provider.dart';
import 'package:myapp/page/device_listentry.dart';
import 'package:myapp/utils.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlueToothPage extends StatefulWidget {
  final VoidCallback connectBluetooth;
  const BlueToothPage(this.connectBluetooth, {super.key});

  @override
  BlueToothState createState() => BlueToothState();
}

class BlueToothState extends State<BlueToothPage> {
  @override
  void initState() {
    DeviceListProvider deviceListProvider = Provider.of<DeviceListProvider>(context, listen: false);
    deviceListProvider.searchDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
              padding: EdgeInsets.fromLTRB(16 * fem, 38 * fem, 16 * fem, 38 * fem),
              width: double.infinity,
              height: MediaQuery.of(context).size.height + 150,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/page-1/images/bluetooth-pairing-dashboard-bg.png',
                  ),
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 23 * fem,
                    height: 18 * fem,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Image.asset(
                        'assets/page-1/images/back-button-BsK.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<DeviceListProvider>(builder: (__, deviceListdata, _) {
                    if (deviceListdata.discoveredDevice.isNotEmpty) {
                      return ListView.builder(
                        itemCount: deviceListdata.discoveredDevice.length,
                        itemBuilder: (BuildContext context, index) {
                          BluetoothDiscoveryResult result = deviceListdata.discoveredDevice[index];
                          final device = result.device;
                          final address = device.address;
                          return BluetoothDeviceListEntry(
                            device: device,
                            rssi: result.rssi,
                            onTap: () async {
                              try {
                                bool bonded = true;
                                if (!device.isBonded) {
                                  bonded = (await FlutterBluetoothSerial.instance.bondDeviceAtAddress(address, pin: "1234"))!;
                                }
                                deviceListdata.discoveredDevice[deviceListdata.discoveredDevice.indexOf(result)] = BluetoothDiscoveryResult(
                                    device: BluetoothDevice(
                                      name: device.name ?? '',
                                      address: address,
                                      type: device.type,
                                      bondState: bonded ? BluetoothBondState.bonded : BluetoothBondState.none,
                                    ),
                                    rssi: result.rssi);
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('deviceAddress', device.address);
                                deviceAddress = device.address;
                                setState(() {
                                  selectedDevice = device;
                                  widget.connectBluetooth();
                                  Navigator.of(context).pop();
                                });
                              } catch (ex) {
                                // ignore: use_build_context_synchronously
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error occured while bonding'),
                                      content: Text(ex.toString()),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("Close"),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return tunggu('Mencari..!', context);
                    }
                  }),
                )
              ])),
        ),
      ),
    );
  }
}
