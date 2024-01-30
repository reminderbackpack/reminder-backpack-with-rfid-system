// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/utils.dart';
import 'package:myapp/main.dart';
import 'package:myapp/page-1/home_screen.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
        child: SizedBox(
      width: double.infinity,
      child: Container(
        // aboutusGP7 (4:18)
        padding: EdgeInsets.fromLTRB(16 * fem, 38 * fem, 16 * fem, 38 * fem),
        width: double.infinity,
        height: 800 * fem,
        decoration: const BoxDecoration(
          color: Color(0xffffffff),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/about-us-dashboard-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // backbuttonh73 (25:6)
              alignment: Alignment.topLeft,
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
                  'assets/page-1/images/back-button.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
