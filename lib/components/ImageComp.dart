// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageComp extends StatefulWidget {
  const ImageComp({super.key});

  @override
  State<ImageComp> createState() => _ImageCompState();
}

class _ImageCompState extends State<ImageComp> {
  var imageDataUnsplash = [];
  var ImageUrl = "";

  getAllPhotosUnsplash() async {
    var uri =
        'https://api.unsplash.com/photos/?client_id=bOeO969jsu-vbkLm129Udy_-52DiBud-D-QZXbQRlyM';
    http.Response response = await http.get(Uri.parse(uri));
    var decodedResponse = json.decode(response.body);
    setState(() {
      imageDataUnsplash = decodedResponse;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPhotosUnsplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Center(
                  child: Text(
                "Choose a Image",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 20,
              ),
              CupertinoSearchTextField(),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 231,
                width: MediaQuery.of(context).size.width,
                child: imageDataUnsplash == null
                    ? CircularProgressIndicator()
                    : GridView.builder(
                        itemCount: imageDataUnsplash.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 6,
                            crossAxisCount: 2,
                            crossAxisSpacing: 6),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              var url = imageDataUnsplash[index]['urls']['full']
                                  .toString();
                              setState(() {
                                ImageUrl = url;
                              });
                              Navigator.pop(context, url);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(
                                    imageDataUnsplash[index]['urls']['full']),
                              )),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
