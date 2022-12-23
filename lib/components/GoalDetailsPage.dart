// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoalDetails extends StatefulWidget {
  const GoalDetails({super.key, required this.id});
  final id;

  @override
  State<GoalDetails> createState() => _GoalDetailsState();
}

class _GoalDetailsState extends State<GoalDetails> {
  var goalDetails;
  var switchValue = true;

  getGoalDetails() async {
    var uri =
        "https://06c7-2a00-23c5-ba10-a701-c41b-5c6e-69e4-f283.eu.ngrok.io/goal/findOneGoal/";
    var id = widget.id;
    http.Response response = await http.post(Uri.parse(uri), body: {"id": id});
    var decodedGoal = json.decode(response.body);
    setState(() {
      goalDetails = decodedGoal;
      print(goalDetails);
    });
  }

  @override
  void initState() {
    super.initState();
    getGoalDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: goalDetails['goalImageUrl'] == null
                    ? CupertinoActivityIndicator()
                    : Image(image: NetworkImage(goalDetails['goalImageUrl'])),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                goalDetails['goalName'],
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text("Amount"),
                subtitle: Text(goalDetails['goalAmount'].toString()),
              ),
              ListTile(
                title: Text("Duration"),
                subtitle: Text(goalDetails['goalDuration'].toString()),
              ),
              ListTile(
                title: Text("Currency"),
                subtitle: Text(goalDetails['goalCurrency'].toString()),
              ),
              ListTile(
                title: Text("Duration"),
                subtitle: Text(goalDetails['goalDuration'].toString()),
              ),
              ListTile(
                title: Text("Duration Type"),
                subtitle: Text(goalDetails['goalDurationType'].toString()),
              ),
              ListTile(
                title: Text("Duration Amount"),
                subtitle: Text(goalDetails['goalDurationAmount'].toString()),
              ),
              ListTile(
                title: Text("Creation Date"),
                subtitle: Text(goalDetails['goalCreatedDate'].toString()),
              ),
              ListTile(
                title: Text("State"),
                subtitle: Text(goalDetails['goalState'].toString()),
                trailing: CupertinoSwitch(
                    value: switchValue,
                    onChanged: (val) async {
                      setState(() {
                        switchValue = val;
                      });
                      var id = goalDetails["_id"];
                      print(id);
                      var uri =
                          "https://06c7-2a00-23c5-ba10-a701-c41b-5c6e-69e4-f283.eu.ngrok.io/goal/updateGoal/";
                      http.Response response = await http.post(Uri.parse(uri),
                          body: {"status": switchValue.toString(), "id": id});
                    }),
              ),
            ],
          ),
        ));
  }
}
