
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Feedback Page"),
      ),
      body:MyCustomForm()
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

final databaseReference = FirebaseDatabase.instance.reference();

void getData(){
  databaseReference.once().then((DataSnapshot snapshot) {
    var store =  snapshot.value;
    var rides = store['feedback'];
    print('Data :' + rides.toString());
  });
}


List<String> setFeedback(int bookingId)
{

  List<String> cotravellersList = [];

  var ref = databaseReference.child('/bookings/'+bookingId.toString());
  var ref1 = databaseReference.child('/bookings/');

  int rideId;
  String passId;

  ref.once().then((DataSnapshot dataSnapshot)
  {
    var booking = dataSnapshot.value;
    rideId = booking['rideId'];
    passId = booking['passengerId'];
    print(rideId);
    }
  );

  ref1.once().then((DataSnapshot dataSnapshot)
  {
    var booking = dataSnapshot.value;

    booking.forEach((k,v){
      print(v["passengerId"]);
      if(v["rideId"] == rideId  && v["passengerId"] != passId)
        {
          print("in");
          cotravellersList.add(passId);
        }
    });
  }
  );


  return cotravellersList;

}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Options for List
  List<String> options = ["A","B","C"];
  int index = 0;



  @override
  Widget build(BuildContext context) {

    List<String> p =  setFeedback(121);
    print(p);

    final bookingId = TextEditingController();
    final coTravellerId = TextEditingController();
    final ratingPoints = TextEditingController();

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
              ),
              TextField(
                controller: bookingId,
                decoration: new InputDecoration(
                    fillColor: Colors.lightBlueAccent,
                    filled: true,
                    contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 30.0, 10.0, 10.0),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    labelText: 'Booking Id '),
                style: Theme.of(context).textTheme.body1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
              ),
              SizedBox(height: 10),
              TextField(
                controller: coTravellerId,
                decoration: new InputDecoration(
                    fillColor: Colors.lightBlueAccent,
                    filled: true,
                    contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 30.0, 10.0, 10.0),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    labelText: 'Co-Traveller Id '),
                style: Theme.of(context).textTheme.body1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ratingPoints,
                decoration: new InputDecoration(
                    fillColor: Colors.lightBlueAccent,
                    filled: true,
                    contentPadding: new EdgeInsets.fromLTRB(
                    10.0, 30.0, 10.0, 10.0),
                    border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                    ),
                    labelText: 'Ratings '),
                style: Theme.of(context).textTheme.body1,
                maxLength: 1,
                maxLengthEnforced: true,
                keyboardType: TextInputType.number,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: new InputDecoration(
                    contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 30.0, 10.0, 10.0),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    labelText: 'Comments',alignLabelWithHint: true),
                style: Theme.of(context).textTheme.body1,
                maxLength: 100,
                maxLengthEnforced: true,
              ),
              DropdownButton(
                value: options[index],
                items: options.map((String newValue) {
                  return new DropdownMenuItem(
                    child: new Text(newValue,style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                    value: newValue,
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    index = options.indexOf(newValue);
                  });
                },
              )
            ],
          ),
    );
  }
}
