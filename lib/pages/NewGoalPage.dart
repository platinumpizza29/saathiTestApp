// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saathitest/components/ImageComp.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:http/http.dart' as http;

class NewGoal extends StatefulWidget {
  const NewGoal({super.key});

  @override
  State<NewGoal> createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  var _index = 0;
  var imgUrl = "";
  var totalAmount;
  var selectedDate;
  var initialDate = DateTime.now();
  var goalEndDate;
  TextEditingController goalNameController = TextEditingController();
  TextEditingController goalAmountController = TextEditingController();
  TextEditingController goalCurrencyController = TextEditingController();
  TextEditingController goalDurationController = TextEditingController();
  TextEditingController goalDurationTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              child: Center(
                child: Text(
                  "NEW GOAL",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Stepper(
                currentStep: _index,
                onStepCancel: () {
                  if (_index > 0) {
                    setState(() {
                      _index -= 1;
                    });
                  }
                },
                onStepContinue: () {
                  if (_index <= 0) {
                    setState(() {
                      _index += 1;
                    });
                  }
                },
                onStepTapped: (value) {
                  setState(() {
                    _index = value;
                  });
                },
                steps: [
                  Step(
                    title: Text('Enter name for your goal'),
                    content: CupertinoTextField(
                      autofocus: true,
                      controller: goalNameController,
                      placeholder: 'Name',
                    ),
                  ),
                  Step(
                    title: Text('Select Image for your goal'),
                    content: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () async {
                              var result = await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ImageComp()));
                              setState(() {
                                imgUrl = result;
                              });
                            },
                            child: Text("Select Image"))),
                  ),
                  Step(
                    title: Text('Goal Amount'),
                    content: CupertinoTextField(
                      autofocus: true,
                      controller: goalAmountController,
                      keyboardType: TextInputType.number,
                      placeholder: 'Amount e.g 2000',
                    ),
                  ),
                  Step(
                    title: Text('Goal Currency'),
                    content: CupertinoTextField(
                      autofocus: true,
                      controller: goalCurrencyController,
                      keyboardType: TextInputType.text,
                      placeholder: 'Currency e.g. Rupees or Dollars',
                    ),
                  ),
                  Step(
                    title: Text('Goal Duration'),
                    content: CupertinoTextField(
                      autofocus: true,
                      controller: goalDurationController,
                      keyboardType: TextInputType.number,
                      placeholder: 'Amount',
                    ),
                  ),
                  Step(
                      title: Text('Goal Duration Type'),
                      content: CupertinoTextField(
                        autofocus: true,
                        controller: goalDurationTypeController,
                        keyboardType: TextInputType.text,
                        placeholder: 'E.g. Months or Year',
                      )),
                  Step(
                      title: Text('Goal Creation Time'),
                      content: Text(DateTime.now().toString())),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(40),
                      backgroundColor: Colors.black),
                  onPressed: () async {
                    var uri =
                        "https://06c7-2a00-23c5-ba10-a701-c41b-5c6e-69e4-f283.eu.ngrok.io/goal/createGoal";
                    var goalName = goalNameController.text;
                    var goalAmount = goalAmountController.text;
                    var goalCurrency = goalCurrencyController.text;
                    var goalDuration = goalDurationController.text;
                    var goalDurationType =
                        goalDurationTypeController.text.toUpperCase();
                    var timeStamp = DateTime.now().toString();
                    http.Response response =
                        await http.post(Uri.parse(uri), body: {
                      "goalName": goalName,
                      "goalImageUrl": imgUrl,
                      "goalAmount": goalAmount,
                      "goalCurrency": goalCurrency,
                      "goalDuration": goalDuration,
                      "goalDurationType": goalDurationType,
                      "goalCreatedDate": timeStamp,
                    });
                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.upload),
                  label: Text("Create New Goal")),
            )
          ],
        ),
      ),
    );
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  calcDate(duration, timeStamp, type) {
    if (type == 'weeks') {
      setState(() {
        var currentDate = DateTime.now();
        goalEndDate = currentDate.add(Duration(days: duration * 7));
        print(goalEndDate);
      });
    } else if (type == 'months') {
    } else if (type == 'years') {}
  }
}
