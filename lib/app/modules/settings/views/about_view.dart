import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(
                size: Size.fromRadius(48),
                child: Image.asset('assets/images/ic_launcher-playstore.png'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ultimate Alarm Clock',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
                SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This project aims to build a non-conventional alarm clock with smart features such as auto-dismissal based on phone activity, weather and more!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ), backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      // GitHub URL.
                      String url =
                          "https://github.com/CCExtractor/ultimate_alarm_clock";
                      if (!await launchUrl(Uri.parse(url))) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/images/github.svg",
                      width: 30,
                      height: 30,
                    ),
                     label: Text(
                      "GitHub",
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ), backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      // Wensite Url
                      String url = "https://ccextractor.org/";
                      if (!await launchUrl(Uri.parse(url))) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/images/link.svg",
                      width: 30,
                      height: 30,
                    ),
                   label: Text(
                      "CCExtractor",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      return await launch(uri.toString());
    } else {
      return false;
    }
  }
}
