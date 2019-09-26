import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class FindRidePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FindRidePageState();
  }
}

class FindRidePageState extends State<FindRidePage> {
  final DBRef = FirebaseDatabase.instance.reference();

  final myController = TextEditingController();
  final myController2 = TextEditingController();


  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
    myController2.addListener(_printLatestValue);
  }

    _printLatestValue() {
    //print("Second text field: ${noofpplController.text}");
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("PoolMyCar"),
      ),
        body: Container(
        padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
            children: <Widget>[
                TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                labelText: 'Enter starting point',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            validator: (value) {
            if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
  },
  controller: myController,

),
                TextFormField(
            autofocus: false,
            decoration: InputDecoration(
          labelText: 'Enter destination',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), gapPadding: 30.0),
          ),
          validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
  },
  controller: myController2,
),


RaisedButton(
  child: Text('Find ride'),
  onPressed: (){
    findRide();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the user has entered by using the
          // TextEditingController.
          content: Text("Ride created!"),
        );
      },
    );
  },
),
         ] ),
    )
    )
    );
  }

  void findRide() {
    final ridedbref = DBRef.child("rides");
    ridedbref
    .child("source")
    .equalTo(myController)
    .once()
    .then((DataSnapshot snapshot) {
      print("Snapshot value:" + snapshot.value.toString());
    });
    print(DBRef);
  }
}