// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

class SaveComp extends StatefulWidget {
  const SaveComp({super.key});

  @override
  State<SaveComp> createState() => _SaveCompState();
}

class _SaveCompState extends State<SaveComp> {
  var savingsValue = 10000;
  var allGoals = [];

  getAllGoals() async {
    var path = 'http://192.168.1.137:4000/goal/allGoals';
    http.Response response = await http.get(Uri.parse(path));
    try {
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        allGoals = decodedData;
        print(allGoals);
      } else {
        print("error fetching Data");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  label: Text("Goal")),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 400,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: allGoals.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      enableFeedback: true,
                      onTap: () {
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
                                    /// This parameter indicates the action would be a default
                                    /// defualt behavior, turns the action's text to bold text.
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Status'),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Update'),
                                  ),
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
                      enabled: allGoals[index]['goalState'] == 'Active'
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
                        allGoals[index]['goalAmount'].toString().toUpperCase(),
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
          ],
        ),
      ),
    );
  }

  deleteConfirmation() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to delete the goal"),
            actions: [
              CupertinoDialogAction(
                child: Text("No"),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("Yes"),
                onPressed: () {},
              )
            ],
          );
        });
  }

  Future handleDeleteGoal(var id) async {
    var url = 'http://192.168.1.137:4000/goal/deleteGoal';
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
