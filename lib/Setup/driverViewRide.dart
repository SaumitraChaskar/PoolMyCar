import 'package:bbc_login/Setup/userhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'mailHandler.dart';

//import 'package:flutter_email_sender/flutter_email_sender.dart';

class DriverViewRidePage extends StatelessWidget {
  // This widget is the root of your application.
  DriverViewRidePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyDriverCard(),
    );
  }
}

class MyDriverCard extends StatelessWidget {
  MyDriverCard({Key key}) : super(key: key);

  final databaseReferenceCarOwner =
      FirebaseDatabase.instance.reference().child("carowner");
  static final databaseReference = FirebaseDatabase.instance.reference();
  static final databaseReferenceFeedback =
      FirebaseDatabase.instance.reference().child("feedback");

  static int numRides = 0;

  Future<List<CustomDriverViewRideCard>> _getData() async {
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

    dataCarowner.forEach((k, v) {
      carOwnerDetails[k] = v["username"];
    });

    var carOwnerRatings = new Map();

    dataCarowner.forEach((k, v) {
      List<double> rData = [0, 0];
      carOwnerRatings[k] = rData;
    });

    dataFeedback.forEach((k, v) {
      print(v["driverUid"]);
      print(carOwnerRatings[v["driverUid"]]);
      carOwnerRatings[v["driverUid"]][0] += 1;
      carOwnerRatings[v["driverUid"]][1] += v["ratings"];
    });

    final databaseReferencePassengerStop =
        FirebaseDatabase.instance.reference().child("bookings");
    var dataBookings;

    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataBookings = snapshot.value;
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUid = user.uid;

    var rc = 0;

    var rideDetails = data['rides'];

    List<CustomDriverViewRideCard> newCards = [];

    rideDetails.forEach((k, v) {
      DateTime date = DateTime.now();
      DateTime rideDate = DateTime.parse(v["date"] + " " + v["time"]);
      print("BOOLEAN");
//            print(date.isBefore(rideDate));
      print(date.isBefore(rideDate));
      print(date.isBefore(rideDate) && v["driverUid"] == user.uid.toString());
      if (date.isBefore(rideDate) && v["driverUid"] == user.uid.toString()) {
        rc += 1;
        var flag = 0;
        if (v["passengers"] != null) {
          v["passengers"].forEach((key, passenger) {
            if (userUid.toString() == passenger.toString()) {
              flag = 1;
            }
          });
          if (flag == 1) {
            double ratings = 0;
            if (carOwnerRatings[v["driverUid"]][0] != 0) {
              double n = carOwnerRatings[v["driverUid"]][1];
              double d = carOwnerRatings[v["driverUid"]][0];
              ratings = n / d;
            }

            CustomDriverViewRideCard c = new CustomDriverViewRideCard(
              username: carOwnerDetails[v["driverUid"]],
              preferences: v["preferences"],
              time: v["time"],
              pricepp: v["pricepp"],
              source: v["source"],
              dest: v["dest"],
              driveruid: v["driverUid"],
              numberofppl: v["numberofppl"],
              date: v["date"],
              rideId: k,
              ratings: ratings,
            );
            newCards.add(c);
          }
        } else {
          double ratings = 0;

          if (carOwnerRatings[v["driverUid"]][0] != 0) {
            double n = carOwnerRatings[v["driverUid"]][1];
            double d = carOwnerRatings[v["driverUid"]][0];
            ratings = n / d;
          }

          CustomDriverViewRideCard c = new CustomDriverViewRideCard(
            username: carOwnerDetails[v["driverUid"]],
            preferences: v["preferences"],
            time: v["time"],
            pricepp: v["pricepp"],
            source: v["source"],
            dest: v["dest"],
            driveruid: v["driverUid"],
            numberofppl: v["numberofppl"],
            date: v["date"],
            rideId: k,
            ratings: ratings,
          );
          newCards.add(c);
        }
      }
    });
    print("newCards");
    print(newCards);
    return newCards;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Center(child: Text("Please wait wheels are rolling  ....")),
          );
        } else {
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
              ))
            ],
          );
        }
      },
    ));
  }
}

class CustomDriverViewRideCard extends StatelessWidget {
  CustomDriverViewRideCard({
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

  Future<int> _isUser(driveruid) async {
    final databaseReferenceCarOwner =
        FirebaseDatabase.instance.reference().child("carowner");
    var dataCarOwner;
    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataCarOwner = snapshot.value;
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUid = user.uid;
    var flag = 0;
    dataCarOwner.forEach((k, v) {
      if (userUid.toString() == k.toString() && userUid == driveruid) {
        flag = 1;
      }
    });

    return flag;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://img.icons8.com/bubbles/50/000000/user.png",
                ),
                radius: 35,
              ),
              title: new Text(
                  username + " -------- Rating: " + ratings.toString()),
              subtitle: Text("Pref : " + preferences)),
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
                  child: new Text(
                    "Departure: " +
                        time.toString() +
                        "      Date: " +
                        date.toString(),
                    style: new TextStyle(fontSize: 12.0),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.all(7.0),
                  child: new Text("  Ride Price: " + pricepp.toString(),
                      style: new TextStyle(fontSize: 12.0)),
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
                  child: new Text(
                    'From: ' + source,
                    style: new TextStyle(fontSize: 12.0),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.all(7.0),
                  child: new Text('To: ' + dest.toString(),
                      style: new TextStyle(fontSize: 12.0)),
                ),
                Spacer(),
                new Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Container(
                      child: FutureBuilder(
                          future: _isUser(driveruid),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == 1) {
                              return new RaisedButton( child: Text('Delete'),
                                onPressed: () {
                                //deleteRide(rideId);
                                return showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Please confirm if you want delete ride')
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () =>
                                                _confirmResultForDeletion(
                                                    true, context),
                                            child: Text('confirm'),
                                          ),
                                          FlatButton(
                                            onPressed: () =>
                                                _confirmResultForDeletion(
                                                    false, context),
                                            child: Text('cancel'),
                                          )
                                        ],
                                      );
                                    });
                              });
                            } else {
                              return new Container();
                            }
                          }),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future deleteRide(rideId) async {
    final ridedbref = FirebaseDatabase.instance.reference().child("rides");
    print("deleteride : id" + rideId.toString());
    await ridedbref.child(rideId).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  _confirmResultForDeletion(bool isTrue, BuildContext context) {
    if (isTrue) {
      deleteRide(rideId);
      Navigator.pop(context);
      final snackBar =
          new SnackBar(content: new Text('Your Ride has been created!'));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context);
    }
  }
}

