import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class FirebaseDataPage extends StatefulWidget {
  @override
  _FirebaseDataPageState createState() => _FirebaseDataPageState();
}

class _FirebaseDataPageState extends State<FirebaseDataPage> {

  final databaseReference = FirebaseDatabase.instance.reference();

  Future<List<Ride>> _getData() async{
    var data;
    List<Ride> rides = [];
    await databaseReference.once().then((DataSnapshot snapshot) {
      //print('Data : ${snapshot.value}');
      data = snapshot.value;
    });

    var rideDetails = data['rides'];
    print(rideDetails);

    int i = 0;

    rideDetails.forEach((k ,v) {

        i++;
        Ride ride = Ride(i,v["numberofppl"],v["driverUid"],v["dest"],v["source"]);
        rides.add(ride);
        });

    print(rides[0]);
    return rides;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data'),
        ),
        body:Container(
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
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: new Text(snapshot.data[index].source),
                          subtitle: Text("Seats: " + snapshot.data[index].numberofppl.toString())
                      );
                    }

                );
              }
            },
          ),
        )

    );

  }
}

class Ride
{
  final int index;
  final int numberofppl;
  final String driverUid;
  final String source;
  final String dest;

  Ride(this.index,this.numberofppl,this.driverUid,this.source,this.dest);
}
