import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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

    String _mySelection;
    List<Map> _myJson;

    List<Map> _getDataForSource()
    {
         _myJson = [{"id":0,"name":"<New>"},{"id":1,"name":"Test Practice"}];
    }


    return Scaffold(
      appBar: AppBar(
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
                            content: Text("Ride created!"),
        );
      },
    );
  },
),
             DropdownButton<String>(
                isDense: true,
                hint: Text("Select"),
                value: _mySelection,
                onChanged: (String newValue) {

                  setState(() {
                    _mySelection = newValue;
                  });

                  print (_mySelection);
                },
                items: _myJson.map((Map map) {
                  return DropdownMenuItem<String>(
                    value: map["id"].toString(),
                    child: Text(
                      map["name"],
                    ),
                  );
                }).toList(),
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