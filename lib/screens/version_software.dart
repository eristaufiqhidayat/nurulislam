// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class version_software extends StatefulWidget {
  const version_software({super.key});

  @override
  State<version_software> createState() => _version_softwareState();
}

class _version_softwareState extends State<version_software> {
  String appName = "";
  String version = "";
  String buildNumber = "";
  String packageName = "";

  @override
  void initState() {
    super.initState();
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      appName = info.appName;
      version = info.version;
      buildNumber = info.buildNumber;
      packageName = info.packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Version'),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            const SizedBox(height: 20),
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  "https://khandaq.lembaharafah.com/public/asset/dist/img/logoArafah.jpg",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                )),
            const SizedBox(height: 20),

            // 🔥 AUTO VERSION & APP INFO
            Text(
              "$appName — Version $version+$buildNumber",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            Text("Package: $packageName"),

            const SizedBox(height: 20),
            const Text("Designation: IT High School Lembah Arafah"),
            const Text("Email: info@lembaharafah.com"),
            const Text("Phone_number: wa : 08118684222"),
          ]),
        ));
  }
}
