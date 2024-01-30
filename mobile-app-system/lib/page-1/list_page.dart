import 'package:flutter/material.dart';
import 'package:myapp/global.dart';
import 'package:myapp/page-1/edit_nama_sensor.dart';
import 'package:myapp/page-1/home_screen.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorList extends StatefulWidget {
  const SensorList({super.key});

  @override
  SensorListState createState() => SensorListState();
}

class SensorListState extends State<SensorList> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return SingleChildScrollView(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 90 * fem),
                width: 23 * fem,
                height: 18 * fem,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Image.asset(
                    'assets/page-1/images/back-button-Zqf.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                // listdashboardtextf1F (201:9)
                margin: EdgeInsets.fromLTRB(111 * fem, 0 * fem, 0 * fem, 40 * fem),
                width: 105 * fem,
                // height: 45 * fem,
                child: Image.asset(
                  'assets/page-1/images/list-dashboard-text.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 250,
                child: SettingsList(
                    lightTheme: const SettingsThemeData(
                      settingsListBackground: Colors.white,
                      settingsSectionBackground: Colors.amber,
                    ),
                    sections: [
                      SettingsSection(tiles: [
                        SettingsTile.switchTile(
                          activeSwitchColor: const Color.fromARGB(255, 27, 124, 203),
                          initialValue: statusSensor1,
                          onToggle: (_) async {
                            setState(() {
                              statusSensor1 = !statusSensor1;
                            });
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('statusSensor1', statusSensor1);
                          },
                          title: Text(editSensorController1.text),
                          description: const Text('Aktifkan/matikan sensor'),
                        ),
                        SettingsTile.switchTile(
                          activeSwitchColor: const Color.fromARGB(255, 27, 124, 203),
                          initialValue: statusSensor2,
                          onToggle: (_) async {
                            setState(() {
                              statusSensor2 = !statusSensor2;
                            });
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('statusSensor2', statusSensor2);
                          },
                          title: Text(editSensorController2.text),
                          description: const Text('Aktifkan/matikan sensor'),
                        ),
                        SettingsTile.switchTile(
                          activeSwitchColor: const Color.fromARGB(255, 27, 124, 203),
                          initialValue: statusSensor3,
                          onToggle: (_) async {
                            setState(() {
                              statusSensor3 = !statusSensor3;
                            });
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('statusSensor3', statusSensor3);
                          },
                          title: Text(editSensorController3.text),
                          description: const Text('Aktifkan/matikan sensor'),
                        ),
                      ]),
                    ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 54, 76, 244),
                      elevation: 0,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 1.2),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                                child: Container(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: EditnamaSensor(context: context),
                            ));
                          });
                      setState(() {});
                    },
                    child: const Text("Ubah Nama Sensor")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
