
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class FeedbackPage extends StatefulWidget {

  final String rideId;


  FeedbackPage({Key key, @required this.rideId}) : super(key: key);


  @override
  _FeedbackPageState createState() => _FeedbackPageState(rideId : this.rideId,);
}

class _FeedbackPageState extends State<FeedbackPage> {
  final String rideId;

  _FeedbackPageState({@required this.rideId,});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text("Feedback Page"),
      ),
      body:MyCustomForm(rideId: this.rideId,)
    );
  }
}

class MyCustomForm extends StatefulWidget {

  final String rideId;


  MyCustomForm({Key key, @required this.rideId}) : super(key: key);

  @override
  MyCustomFormState createState() {
//    return MyCustomFormState(rideId: this.rideId);
  }
}

final databaseReference = FirebaseDatabase.instance.reference();



class MyCustomFormState extends State<MyCustomForm> {

  final String rideId;
  final String passengerId;
  String bookingId;

  MyCustomFormState({Key key, @required this.rideId,@required this.passengerId});

  final _formKey = GlobalKey<FormState>();


  Future<String> _getBooking() async
  {

    print("HEllllaslclacc");
    final databaseReferenceBookings = FirebaseDatabase.instance.reference().child("bookings");

    var dataBookings;
    await databaseReferenceBookings.once().then((DataSnapshot snapshot) {
      dataBookings = snapshot.value;
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid.toString();
    print("////////");
    print(uid);
    print("///////");
    var flag = 0;
    var bid;
    dataBookings.forEach((k,v){
      if(v["ride_id"] == rideId && v["user_id"] == uid)
        {
          bid  = k.toString();
          flag = 1;
        }
    });
    if(flag == 0)
      return null;
    else
      return bid;
  }


  final ratingPoints = TextEditingController();
  final comments = TextEditingController();


  Future setFeedback() async {

    final DBRef = FirebaseDatabase.instance.reference();

    final ridedbref = DBRef.child("feedback");
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();


    final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("rides");
    var rides;
    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      rides = snapshot.value;
    });

    var captureDriver;

    print("1");

    rides.forEach((key,value){

      if(key.toString() == rideId)
      {
        captureDriver = value["driverUid"];
      }

    });

    print("2");

    String k = ridedbref.push().key;
    ridedbref.child(k).set({
      'bokingId':await _getBooking(),
      'ratings': int.parse(ratingPoints.text),
      'comments': comments.text,
      'driverUid': captureDriver,
      'rideId':rideId.toString(),
    });

    print("3");

    print("Done");
    print(DBRef);

    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {


    print("*********************");
    print(rideId);
    print("*********************");




    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
              ),
              Text(
                'Please rate your ride according to your experience \nand help your Pals !',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
              ),
              FutureBuilder(
                  future: _getBooking(),
                  builder:(BuildContext context ,AsyncSnapshot snapshot ){
                    print(snapshot.data);
                    if(snapshot.data != null)
                      {
                        var d = snapshot.data;
                        return Container(
                          child: Text(
                            'Ride Id: $rideId \n Booking Id: $d',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    else
                      {
                        return Container(
                          child: Text("WAIT...."),
                        );
                      }
                  }
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
              ),
              SizedBox(height: 10),
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
                controller: comments,
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
              ButtonTheme(
                minWidth: 200,
                height: 50,
                child : RaisedButton(
                  onPressed:(){
                    setFeedback();
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the user has entered by using the
                          // TextEditingController.
                          content: Text("Feedback Recorded !"),
                        );
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: Text('Submit !',
                    style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
    );
  }
}
