// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saathitest/components/GoalDetailsPage.dart';
import 'package:saathitest/pages/NewGoalPage.dart';

class SaveComp extends StatefulWidget {
  const SaveComp({super.key});

  @override
  State<SaveComp> createState() => _SaveCompState();
}

class _SaveCompState extends State<SaveComp> {
  var savingsValue = 10000;
  var allGoals = [];
  var amountToSave;
  var temp1;

  getAllGoals() async {
    var path =
        'https://06c7-2a00-23c5-ba10-a701-c41b-5c6e-69e4-f283.eu.ngrok.io/goal/allGoals';
    http.Response response = await http.get(Uri.parse(path));
    try {
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        setState(() {
          allGoals = decodedData;
        });
        print(amountToSave);
      } else {
        print("error fetching Data");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getAllGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "₹$savingsValue",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Saving Balance",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              trailing: ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => NewGoal()));
                  },
                  icon: Icon(Icons.add),
                  label: Text("Goal")),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getAllGoals();
                  },
                  child: ListView.builder(
                    itemCount: allGoals.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        enableFeedback: true,
                        onTap: () {
                          var id = allGoals[index]['_id'];
                          print(id);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => GoalDetails(
                                        id: id,
                                      )));
                        },
                        onLongPress: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  cancelButton: CupertinoButton.filled(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  title: Text("More Options for"),
                                  message: Text(allGoals[index]['goalName']
                                      .toString()
                                      .toUpperCase()),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        var goalID = allGoals[index]["_id"];
                                        handleDeleteGoal(goalID);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              });
                        },
                        enabled: allGoals[index]['goalState'] == 'Active' ||
                                allGoals[index]['goalState'] == 'true'
                            ? true
                            : false,
                        title: Text(
                          allGoals[index]['goalName'].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(allGoals[index]['goalState'].toString()),
                        trailing: Text(
                          allGoals[index]['goalAmount']
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future handleDeleteGoal(var id) async {
    var url =
        'https://06c7-2a00-23c5-ba10-a701-c41b-5c6e-69e4-f283.eu.ngrok.io/goal/deleteGoal';
    http.Response response = await http.post(Uri.parse(url), body: {"id": id});
    if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Text(
          "Successfully deleted",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: CupertinoColors.systemGreen,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(
        content: Text(
          "Error, Please try again later!",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: CupertinoColors.systemRed,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
