import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'card_view.dart';

class SearchRidePage extends StatefulWidget {
  // This widget is the root of your application.
  SearchRidePage({Key key}) : super(key: key);

  @override
  _SearchRidePageState createState() => _SearchRidePageState();
}

class _SearchRidePageState extends State<SearchRidePage> {

  static final sourceController = TextEditingController();
  static final destController = TextEditingController();
  final dbRideRef = FirebaseDatabase.instance.reference().child('rides');

  


//   Future<Map> _getSourceDest(sourceController,destController) async {

//     var rideData;
//     await dbRideRef.once().then((DataSnapshot snapshot) {
//           rideData = snapshot.value;
//         });

//     Map SourceData = new Map();

//     rideData.forEach((k,v){
      
//       if(v["source"] == sourceController.text && v["destination"] == destController.text)
//       {
//         SourceData[]
//       }


//     });

//   }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('PoolMyCar'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              autocorrect: true,
              controller: sourceController,
              decoration: InputDecoration(
                hintText: 'Source',
              ),
            ),
            TextField(
              autocorrect: true,
              controller: destController,
              decoration: InputDecoration(
                hintText: 'Destination',
              ),
            ),
            RaisedButton(
              child: Text("Enter"),
              onPressed:goToViewRide,
            ),
            SizedBox(
              height: 50,
            ),
            // FutureBuilder(
            //   future: dbRideRef.orderByChild('source').equalTo('${sourceController.text}').once(),
            //   builder: (BuildContext context, AsyncSnapshot snapshot){
            //     if(snapshot.hasData){
            //       var dataFrame = snapshot.data;
            //       var mappedFrame = dataFrame.value;

            //       //return Text(mappedFrame.toString());
            //     }else{
            //       return Text('No data found');
            //     }
            //   }
            // ),
          ],
        )
      ),
    );
  }

  
void goToViewRide()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> CardViewDataPage(sd: SourceDest(sourceController.text, destController.text,DateTime.parse("2019-26-09 10:00:00"))),fullscreenDialog: true));
  }
}
