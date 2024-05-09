// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second/cat/food.dart';
import 'package:second/copm/logo.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<QueryDocumentSnapshot> data = [];
  
  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("category").get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }
  

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.of(context).pushNamed("addFood");
          },
          child: Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('this is home page'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 197),
        itemBuilder: (context, i) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                
                Image.network(
              data[i]['image'],
              height: 100,
              width: 190,
              fit: BoxFit.cover, // Adjust the BoxFit property as needed
            ),
            Text(" "),
            Text("${data[i]['name']}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold ), ),
            Text("${data[i]['prise']} "+"\$",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold )),
              ]),
            ),
          );
        },
      )
    );
  }
}
