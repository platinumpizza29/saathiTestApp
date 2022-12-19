// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:saathitest/components/SaveComp.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Saathi",
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  icon: Icon(Icons.savings_outlined, color: Colors.black),
                  text: "Save",
                ),
                Tab(
                  icon: Icon(Icons.attach_money_rounded, color: Colors.black),
                  text: "Earn",
                ),
                Tab(
                  icon: Icon(Icons.menu_book_rounded, color: Colors.black),
                  text: "Learn",
                ),
              ]),
        ),
        body: TabBarView(children: [
          SaveComp(),
          Center(
            child: Text("It's rainy here"),
          ),
          Center(
            child: Text("It's sunny here"),
          ),
        ]),
      ),
    );
  }
}
