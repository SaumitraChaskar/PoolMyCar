
import 'package:bbc_login/Setup/userhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'mailHandler.dart';

//import 'package:flutter_email_sender/flutter_email_sender.dart';

class CardViewDataPage extends StatelessWidget {

final SourceDest sd;

  // This widget is the root of your application.
  CardViewDataPage({Key key,@required this.sd}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('View Ride'),
          //backgroundColor:new Color(0xFF673AB7),
        ),
      body:MyCard(sd : sd)
      );
  }
}
class MyCard extends StatelessWidget{

  final SourceDest sd;

  MyCard({Key key,@required this.sd}) : super(key: key);

  final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");
  static final databaseReference = FirebaseDatabase.instance.reference();
  static final databaseReferenceFeedback = FirebaseDatabase.instance.reference().child("feedback");

  static int numRides = 0;

  Future<List<CustomCard>> _getData() async{
        var data;
        var dataCarowner;
        var dataFeedback;



        await databaseReference.once().then((DataSnapshot snapshot) {
        data = snapshot.value;
        });


        await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
          dataCarowner = snapshot.value;
        });

        await databaseReferenceFeedback.once().then((DataSnapshot snapshot) {
          dataFeedback = snapshot.value;
        });

        var carOwnerDetails = new Map();

        dataCarowner.forEach((k ,v){
          carOwnerDetails[k] = v["username"];
        });

        var carOwnerRatings = new Map();

        dataCarowner.forEach((k,v){
          List<double> rData = [0,0];
          carOwnerRatings[k] = rData;
        });


        dataFeedback.forEach((k,v){
          print(v["driverUid"]);
          print(carOwnerRatings[v["driverUid"]]);
          carOwnerRatings[v["driverUid"]][0]+=1;
          carOwnerRatings[v["driverUid"]][1]+=v["ratings"];
        });



        final databaseReferencePassengerStop = FirebaseDatabase.instance.reference().child("bookings");
        var dataBookings;

        await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
          dataBookings = snapshot.value;
        });

        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        var userUid = user.uid;

        var rc = 0;

        var rideDetails = data['rides'];

        List<CustomCard> newCards = [];

        rideDetails.forEach((k ,v) {
            var source = sd.source.toString();
            var dest  = sd.dest.toString();

            DateTime date = sd.dateTime;
            DateTime rideDate = DateTime.parse(v["date"] + " " + v["time"]);

            if(date.isBefore(rideDate) && source == v["subsource"] && dest == v["subdest"] && v["numberofppl"] > 0 && v["driverUid"] != userUid.toString())
            {
              rc+=1;
              var flag = 0;
              if(v["passengers"] != null){
                v["passengers"].forEach((key,passenger)
                {
                  if(userUid.toString() == passenger.toString())
                  {
                      flag = 1;
                  }
                });

                if(flag == 0)
                  {
                    double ratings = 0;
                    if (carOwnerRatings[v["driverUid"]][0] != 0)
                      {
                        double n = carOwnerRatings[v["driverUid"]][1];
                        double d = carOwnerRatings[v["driverUid"]][0];
                        ratings = n/d;
                      }

                    CustomCard c = new CustomCard(username :carOwnerDetails[v["driverUid"]],preferences:v["preferences"],time:v["time"],pricepp:v["pricepp"],source:v["subsource"],dest:v["subdest"],driveruid:v["driverUid"],numberofppl:v["numberofppl"],date:v["date"],rideId:k,ratings: ratings,);
                    newCards.add(c);

                  }
              }
              else
                {

                  double ratings = 0;

                  if (carOwnerRatings[v["driverUid"]][0] != 0)
                  {
                    double n = carOwnerRatings[v["driverUid"]][1];
                    double d = carOwnerRatings[v["driverUid"]][0];
                    ratings = n/d;
                  }


                  CustomCard c = new CustomCard(username :carOwnerDetails[v["driverUid"]],preferences:v["preferences"],time:v["time"],pricepp:v["pricepp"],source:v["subsource"],dest:v["subdest"],driveruid:v["driverUid"],numberofppl:v["numberofppl"],date:v["date"],rideId:k,ratings: ratings,);
                  newCards.add(c);

                }
            }
          }

        );
        print("newCards");
        print(newCards);
        return newCards;
    }

  @override
  Widget build(BuildContext context) {

    return Container(
            child: FutureBuilder(
              future: _getData(),
              builder:(BuildContext context ,AsyncSnapshot snapshot ){
                if(snapshot.data == null)
                {
                  return Container(
                    child: Center(
                        child: Container(
                            child: CircularProgressIndicator(),
                      alignment: Alignment(0.0, 0.0),
                ),
                )
                  );
                }
                else {
                      return Column(
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
    this.ratings,
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
  final double ratings;

  Future<int> _isUser(driveruid) async{

    final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");
    var dataCarOwner;
    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataCarOwner = snapshot.value;
    });


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUid = user.uid;
    var flag = 0;
    dataCarOwner.forEach((k,v){
      if(userUid.toString() == k.toString() && userUid == driveruid){
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
              title: new Text(username + "  (" + ratings.toString()  + ")"),
              subtitle: Text("Pref : " + preferences)
          ),
//         new Image.network("https://img.icons8.com/bubbles/50/000000/user.png"),
          new Padding(
              padding: new EdgeInsets.all(5.0),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(5.0),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(5.0),
                    child: new Text("DEPARTURE: "+ time.toString() +"      DATE: " + date.toString() ,style: new TextStyle(fontSize: 12.0,),),
                  ),
                ],
              ),


          ),
          new Padding(
            padding: new EdgeInsets.all(5.0),
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                  child: new Text("PRICE: "+ pricepp.toString(),style: new TextStyle(fontSize: 12.0)),
                ),
              ],
            ),


          ),
          new Padding(
            padding: new EdgeInsets.all(5.0),
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                  child: new Text('FROM: ' + source,style: new TextStyle(fontSize: 12.0),),
                ),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                  child: new Text('TO: ' + dest.toString(),style: new TextStyle(fontSize: 12.0)),
                ),
                Spacer(),
                new Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    child: FutureBuilder(
                      future: _isUser(driveruid),
              builder:(BuildContext context ,AsyncSnapshot snapshot ){
                if(snapshot.data == 1)
                {
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
                        child: new FloatingActionButton(
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
                      );
                }
              }

                    ),
                  )
                  
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
    final ride = FirebaseDatabase.instance.reference().child("rides").child("");

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

      }
    });
    Navigator.push(context,MaterialPageRoute(builder: (context)=> UserHomePage(),fullscreenDialog: true));
    sendBookingMail(user.email.toString());
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
  DateTime dateTime;

  SourceDest(this.source,this.dest,this.dateTime);
}
