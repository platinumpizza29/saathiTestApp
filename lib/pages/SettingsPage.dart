// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkThemeValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "Settings",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            trailing: CupertinoSwitch(
                value: darkThemeValue,
                onChanged: (value) {
                  setState(() {
                    darkThemeValue = !darkThemeValue;
                  });
                }),
          )
        ],
      ),
    );
  }
}
