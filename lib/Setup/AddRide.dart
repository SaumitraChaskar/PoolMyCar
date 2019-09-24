import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class NewRidePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return NewRidePageState();
  }
}

class NewRidePageState extends State<NewRidePage> {
  final DBRef = FirebaseDatabase.instance.reference();

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final timeController = TextEditingController();
  final countController = TextEditingController();
  final preferenceController = TextEditingController();
  final priceppController = TextEditingController();
  final dateformat = DateFormat("yyyy-MM-dd");
  final timeformat = DateFormat("HH:mm");


  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
    myController2.addListener(_printLatestValue);
    myController3.addListener(_printLatestValue);
    countController.addListener(_printLatestValue);
    preferenceController.addListener(_printLatestValue);
    priceppController.addListener(_printLatestValue);
    timeController.addListener(_printLatestValue);
  }

    _printLatestValue() {
    //print("Second text field: ${countController.text}");
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    countController.dispose();
    preferenceController.dispose();
    priceppController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Create Ride"),
      ),
      body: Container(
      padding: EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        
        child: Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.all(10.0),
            child:
          TextFormField(
            autofocus: false,
            decoration: InputDecoration(
          labelText: 'Enter starting point',
          contentPadding: new EdgeInsets.fromLTRB(
                                10.0, 30.0, 10.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
  },
  controller: myController,

)),
          new Padding(
            padding: EdgeInsets.all(10.0),
            child:
          TextFormField(
            autofocus: false,
            decoration: InputDecoration(
          labelText: 'Enter destination',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), gapPadding: 30.0 ),
          ),
          validator: (input) {
          if (input.isEmpty) {
            return 'Please enter some text';
          }
          return null;
  },
  controller: myController2,
)),

Text('Date of Ride: (${dateformat.pattern})'),
DateTimeField(
  format: dateformat,
  onShowPicker: (context, currentValue) {
  return showDatePicker(
    context: context,
    firstDate: DateTime(1900),
    initialDate: currentValue ?? DateTime.now(),
    lastDate: DateTime(2100));
    },
    controller: myController3,
  ),
      Text('Time of ride : (${timeformat.pattern})'),
      DateTimeField(
        format: timeformat,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
        controller: timeController,
      ),

  
      new Padding(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
            autofocus: false,
                //controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
            labelText:"Number of passengers",
            border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)), 
            //hintText: "whatever you want",
        //icon: Icon(Icons.phone_iphone)
        ),
    controller: countController,
)),
new Padding(
  padding: EdgeInsets.all(10.0),
  child:
TextFormField(
            autofocus: false,
            decoration: InputDecoration(
          labelText: 'Preferences',
          border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
  controller: preferenceController,
)),
      new Padding(
        padding: EdgeInsets.all(10.0),
          child:
          TextFormField(
            autofocus: false,
                //controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
            labelText:"Price per passenger", 
            border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            //hintText: "whatever you want",
        //icon: Icon(Icons.phone_iphone)
        ),
    controller: priceppController,
)),

RaisedButton(
  child: Text('Create'),
  onPressed: (){
    writeRide();
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

  Future writeRide() async {
    final ridedbref = DBRef.child("rides");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String k = ridedbref.push().key;
    ridedbref.child(k).set({
      'source':myController.text,
      'dest': myController2.text,
      'date': myController3.text,
      'time': timeController.text,
      'numberofppl': int.parse(countController.text),
      'driverUid': user.uid,
      'pricepp': int.parse(priceppController.text),
      'preferences':preferenceController.text,
      'rideId':k,
    });

    DBRef.child("carowner").child(user.uid).child("rides").set({
      'rideid': k, 
    });
    print(DBRef);
  }
}