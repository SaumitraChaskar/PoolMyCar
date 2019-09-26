
import 'dart:collection';

import 'package:bbc_login/Setup/userhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'searchRide.dart';
import 'package:date_format/date_format.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';

class CardViewDataPage extends StatelessWidget {

final SourceDest sd;

  // This widget is the root of your application.
  CardViewDataPage({Key key,@required this.sd}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home:new MyCard(sd : sd),
    );
  }
}
class MyCard extends StatelessWidget{

  final SourceDest sd;

  MyCard({Key key,@required this.sd}) : super(key: key);

  final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");
  static final databaseReference = FirebaseDatabase.instance.reference();
  static int numRides = 0;

  Future<List<CustomCard>> _getData() async{
        var data;
        var dataCarowner;
        List<Ride> rides = [];


        await databaseReference.once().then((DataSnapshot snapshot) {
        data = snapshot.value;
        });


        await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
          dataCarowner = snapshot.value;
        });

        var carOwnerDetails = new Map();

        dataCarowner.forEach((k ,v){
          carOwnerDetails[k] = v["username"];
        });

        final databaseReferencePassengerStop = FirebaseDatabase.instance.reference().child("bookings");
        var dataBookings;
        await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
          dataBookings = snapshot.value;
        });

        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        var userUid = user.uid;





        var rideDetails = data['rides'];

        List<CustomCard> newCards = [];

        rideDetails.forEach((k ,v) {
            var source = sd.source.toString();
            var dest  = sd.dest.toString();
            DateTime date = sd.dateTime;
            DateTime rideDate = DateTime.parse(v["date"] + " " + v["time"]);
            if( date.isAfter(rideDate) && source == v["source"] && dest == v["dest"] && v["numberofppl"] > 0 )
            {
              var flag = 0;
              if(v["passengers"] != null){
                print(userUid.toString());
                v["passengers"].forEach((key,passenger)
                {
                  if(userUid.toString() == passenger.toString())
                  {
                      flag = 1;
                  }
                });
                if(flag == 0)
                  {
                    CustomCard c = new CustomCard(username :carOwnerDetails[v["driverUid"]],preferences:v["preferences"],time:v["time"],pricepp:v["pricepp"],source:v["source"],dest:v["dest"],driveruid:v["driverUid"],numberofppl:v["numberofppl"],date:v["date"],rideId:k);
                    newCards.add(c);

                  }
              }
              else
                {
                  CustomCard c = new CustomCard(username :carOwnerDetails[v["driverUid"]],preferences:v["preferences"],time:v["time"],pricepp:v["pricepp"],source:v["source"],dest:v["dest"],driveruid:v["driverUid"],numberofppl:v["numberofppl"],date:v["date"],rideId:k);
                  newCards.add(c);
                }
            }
          }

        );
        return newCards;
        }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('View Ride'),
          backgroundColor:new Color(0xFF673AB7),
        ),
        body: new Container(
            child: FutureBuilder(
              future: _getData(),
              builder:(BuildContext context ,AsyncSnapshot snapshot ){
                if(snapshot.data == null)
                {
                  return Container(
                    child: Center(
                        child:Text("Please wait wheels are rolling  ....")
                    ),
                  );
                }
                else {
                      return new Column(
                        children: <Widget>[
                      Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.album),
                            title: Text('Book Your Rides Here !'),
                            subtitle: Text('Travel to Unravel'),
                          ),
                        ],
                      ),
                ),
                          Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: snapshot.data,
                              )
                          )
                        ],
                      );
                }
              },
            )
        ),


    );
  }
}

class CustomCard extends StatelessWidget {

  CustomCard({
    this.rideId,
    this.username,
    this.preferences,
    this.time,
    this.pricepp,
    this.source,
    this.dest,
    this.driveruid,
    this.numberofppl,
    this.date,
  });

  final String username;
  final String time;
  final String date;
  final String preferences;
  final int pricepp;
  final String source;
  final String dest;
  final String driveruid;
  final int numberofppl;
  final String rideId;

  Future<int> _isUser() async{

    final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");
    var dataCarOwner;
    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataCarOwner = snapshot.value;
    });


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUid = user.uid;
    var flag = 0;
    dataCarOwner.forEach((k,v){
      if(userUid.toString() == k.toString()){
        flag = 1;
      }
    });

    return flag;

  }



  @override
  Widget build(BuildContext context)  {
      return  new Card(
      child: new Column(
        children: <Widget>[
          new ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://img.icons8.com/bubbles/50/000000/user.png",
                ),
                radius: 35,
              ),
              title: new Text(username),
              subtitle: Text("Pref : " + preferences)
          ),
//         new Image.network("https://img.icons8.com/bubbles/50/000000/user.png"),
          new Padding(
              padding: new EdgeInsets.all(7.0),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text("Departure: "+ time.toString() +"      Date: " + date.toString() ,style: new TextStyle(fontSize: 12.0),),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text("  Ride Price: "+ pricepp.toString(),style: new TextStyle(fontSize: 12.0)),
                  ),
                ],
              ),

          ),
          new Padding(
            padding: new EdgeInsets.all(7.0),
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(7.0),
                ),
                new Padding(
                  padding: new EdgeInsets.all(7.0),
                  child: new Text('From: ' + source,style: new TextStyle(fontSize: 12.0),),
                ),
                new Padding(
                  padding: new EdgeInsets.all(7.0),
                  child: new Text('To: ' + dest.toString(),style: new TextStyle(fontSize: 12.0)),
                ),
                Spacer(),
                new Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Container(
                    child: FutureBuilder(
                      future: _isUser(),
              builder:(BuildContext context ,AsyncSnapshot snapshot ){
                if(snapshot.data == 1)
                {
                  print(snapshot.data);
                      return new RaisedButton(
                        onPressed:(){
                        deleteRide(rideId);
                        return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // Retrieve the text the user has entered by using the
                            // TextEditingController.
                            content: Text("Deleted ride!"),
                          );
                        },
                      );
                    },
                            child: Text("Delete"),
                );
                }
                else {
                      return new Container(
                      );
                }
              }

                    ),
                  )
                  
                ),
                new FloatingActionButton(
                  //heroTag: rideId.toString(),
                    onPressed:(){
                      writeBooking(rideId,driveruid,source,dest,date,time,context,numberofppl);
                      return showDialog(
                        context: context,
                        builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the user has entered by using the
                              // TextEditingController.
                              content: Text("Booking created!"),
                              );
                            },
                        );
                    },
                    child: Text("Book"),
                ),
              ],
            ),

          )
        ],
      ),
    );
    
  }

  Future writeBooking(rideId,driveruid,source,dest,date,time,BuildContext context,numberofppl) async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final ridedbref = FirebaseDatabase.instance.reference().child("bookings");
    String k = ridedbref.push().key;
    ridedbref.child(k).set({
      'ride_id':rideId,
      'user_id': user.uid,
      'timestamp created': DateTime.now().millisecondsSinceEpoch,
    });

    final rideRefPushBookings = FirebaseDatabase.instance.reference().child("rides").child(rideId.toString()).child("passengers");
    rideRefPushBookings.update({
      'passenger_id$numberofppl': user.uid,
    });

    final sendOwner = FirebaseDatabase.instance.reference().child("carowner");
    var dataCarowner;
    await sendOwner.once().then((DataSnapshot snapshot) {
      dataCarowner = snapshot.value;
    });

    dataCarowner.forEach((k,v) async {
      if(driveruid.toString() == k.toString())
      {
        var mailId = v["email"];

        final databaseUpdate = FirebaseDatabase.instance.reference();
        databaseUpdate.child("rides").child(rideId.toString()).update({
          'numberofppl': numberofppl - 1,
        });

        print(numberofppl);

//        String body = "A ride has been booked against your ride $rideId &from $source to $dest \n Dated: $date -- $time ";
//        var url = 'mailto:$mailId?subject=Ride Booking notification &body=$body';
//        await launch(url);
//        print("email sent ");

//        final Email email = Email(
//          body: "A ride has been booked against your ride $rideId &from $source to $dest \n Dated: $date -- $time ",
//          subject: 'Ride Notification',
//          recipients: [mailId],
//        );
//        print("Here");
//        await FlutterEmailSender.send(email);
//        print("sent");
      }
    });
    Navigator.push(context,MaterialPageRoute(builder: (context)=> UserHomePage(),fullscreenDialog: true));

  }

  Future deleteRide(rideId)
  async {
      final ridedbref = FirebaseDatabase.instance.reference().child("rides");
      print("deleteride : id"+ rideId.toString());
      await ridedbref.child(rideId).remove().then((_) {
      print('Transaction  committed.');
    });
      
  }
}

class Ride
{
  final int index;
  final int numberofppl;
  final String driverUid;
  final String source;
  final String dest;
  final int pricepp;
  final String time;
  final String rideId;
  final String date;
  Ride(this.index,this.numberofppl,this.driverUid,this.source,this.dest,this.pricepp,this.date,this.rideId,this.time);
}

class SourceDest
{
  String source;
  String dest;
  DateTime dateTime = DateTime.parse("2019-09-26 10:00:00");

  SourceDest(this.source,this.dest,this.dateTime);
}
