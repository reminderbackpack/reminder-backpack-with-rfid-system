import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditnamaSensor extends StatelessWidget {
  const EditnamaSensor({
    super.key,
    required this.context,
  });
  // ignore: prefer_typing_uninitialized_variables
  final context;

  @override
  Widget 
  build(BuildContext context) => SizedBox(
        height: 270,
        width: MediaQuery.of(context).size.width,
        child:
        
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: Color.fromARGB(255, 109, 187, 255)),
              child: Text("Edit Nama Sensor",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sensor 1:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 270,
                          height: 35,
                          child: TextFormField(
                            autofocus: true,
                            enableInteractiveSelection: false,
                            controller: editSensorController1,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder(), hintText: "", fillColor: Color.fromARGB(186, 255, 255, 255), filled: true),
                            cursorColor: Colors.black,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sensor 2:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 270,
                          height: 35,
                          child: TextFormField(
                            autofocus: true,
                            enableInteractiveSelection: false,
                            controller: editSensorController2,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder(), hintText: "", fillColor: Color.fromARGB(186, 255, 255, 255), filled: true),
                            cursorColor: Colors.black,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sensor 3:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 270,
                          height: 35,
                          child: TextFormField(
                            autofocus: true,
                            enableInteractiveSelection: false,
                            controller: editSensorController3,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder(), hintText: "", fillColor: Color.fromARGB(186, 255, 255, 255), filled: true),
                            cursorColor: Colors.black,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 9, 0, 81)),
                      child: const Row(
                        children: [
                          Icon(Icons.cancel),
                          SizedBox(width: 5),
                          Text(
                            'Batal',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        rekamdData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 136, 11),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.save_alt_sharp),
                          SizedBox(width: 5),
                          Text(
                            'Rekam',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  rekamdData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('namaSensor1', editSensorController1.text);
    prefs.setString('namaSensor2', editSensorController2.text);
    prefs.setString('namaSensor3', editSensorController3.text);
    Navigator.of(context).pop();
  }
}
