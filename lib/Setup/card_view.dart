
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CardViewDataPage extends StatelessWidget {
  // This widget is the root of your application.
  CardViewDataPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home:new MyCard()
    );
  }
}
class MyCard extends StatelessWidget{


  MyCard({Key key}) : super(key: key);

  final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");
  static final databaseReference = FirebaseDatabase.instance.reference();
  static int numRides = 0;

  Future<List<CustomCard>> _getData() async{
        var data;
        var dataCarowner;
        List<Ride> rides = [];

        print("Hey");

        await databaseReference.once().then((DataSnapshot snapshot) {
        data = snapshot.value;
        });


        await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
          dataCarowner = snapshot.value;
        });

        print(dataCarowner);
        var carOwnerDetails = new Map();

        dataCarowner.forEach((k ,v){
          print(k);
          print(v["username"]);
          carOwnerDetails[k] = v["username"];
          print(k);
        });


        var rideDetails = data['rides'];

        List<CustomCard> newCards = [];
        int i = 0;

        rideDetails.forEach((k ,v) {
            i++;
            Ride ride = Ride(i,v["numberofppl"],v["driverUid"],v["dest"],v["source"],v["pricepp"],v["date"],k,v["time"]);
            rides.add(ride);
            print(v);
            print("After ride");
            CustomCard c = new CustomCard(username :carOwnerDetails[v["driverUid"]],preferences:v["preferences"],time:v["time"],pricepp:v["pricepp"],source:v["source"],dest:v["dest"],driveruid:v["driverUid"],numberofppl:v["numberofppl"],date:v["date"],rideId:k);
            newCards.add(c);

        }
    );

    numRides = i;
    print(numRides);

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
                        child:Text("Loading...")
                    ),
                  );
                }
                else {
                      return new Container(
                        child: ListView(
                          children: snapshot.data,
                        )
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





  @override
  Future<Widget> build(BuildContext context) async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(driveruid == user.uid)
    {
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
                  child: RaisedButton(
                    child: Text('delete'),
                    onPressed: (){
                      deleteRide(rideId);
                    },),
                ),
                new FloatingActionButton(
                  //heroTag: rideId.toString(),
                    onPressed:(){
                      writeBooking(rideId);
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
  }

  Future writeBooking(rideId)
  async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final ridedbref = FirebaseDatabase.instance.reference().child("bookings");
    String k = ridedbref.push().key;
    ridedbref.child(k).set({
      'ride_id':rideId,
      'user_id': user.uid,
      'timestamp created': DateTime.now().millisecondsSinceEpoch,
    });
    
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
