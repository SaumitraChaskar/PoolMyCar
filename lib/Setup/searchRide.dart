
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'card_view.dart';
import 'package:intl/intl.dart';

class SearchRidePage extends StatefulWidget {
  // This widget is the root of your application.
  SearchRidePage({Key key}) : super(key: key);

  @override
  _SearchRidePageState createState() => _SearchRidePageState();
}

class _SearchRidePageState extends State<SearchRidePage> {

  static final sourceController = TextEditingController();
  static final destController = TextEditingController();
  final myController3 = TextEditingController();
  final timeController = TextEditingController();
  final dateformat = DateFormat("yyyy-MM-dd");
  final timeformat = DateFormat("HH:mm");
  final dbRideRef = FirebaseDatabase.instance.reference().child('rides');
  String selSubSource;
  String selSubDest;
  @override
  Widget build(BuildContext context){


    List<Map> _myJson = [];
    List<String> sources = [];
    List<String> destinations = [];

    Future<List<Map>> _getDataForSource(source,destination) async
    {
      final databaseReferenceRides = FirebaseDatabase.instance.reference().child("rides");
      var data;

      await databaseReferenceRides.once().then((DataSnapshot snapshot) {
        data = snapshot.value;
      });

      data.forEach((key,ride){
        _myJson.add(ride);

        if (ride['source'] == source && ride['dest'] == destination)
          {
            if(!sources.contains(ride['subsource'])){
              sources.add(ride['subsource']);
            }
            if(!destinations.contains(ride['subdest'])){
              destinations.add(ride['subdest']);
            }
          }

      });

      return _myJson;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('PoolMyCar'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                autocorrect: true,
                controller: sourceController,
            decoration: InputDecoration(
                fillColor: Colors.lightBlueAccent,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(
                    10.0, 30.0, 10.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              labelText: 'From',),
              ),
              SizedBox(height: 20),
              TextFormField(
                autocorrect: true,
                controller: destController,
                decoration: InputDecoration(
                  fillColor: Colors.lightBlueAccent,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(
                      10.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: 'Off to',),
              ),
              
              SizedBox(
                height: 50,
              ),
               Container(
                child: FutureBuilder(
                    future: _getDataForSource(sourceController.text,destController.text),
                    builder:(BuildContext context ,AsyncSnapshot snapshot ){
                      if(snapshot.data == null)
                        {
                          return Container(
                            child: Text("Loading Destinations......"),
                          );
                        }
                      else{
                        return Column(
                          children:<Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(
                            5.0, 5.0, 5.0, 5.0),
                              decoration:BoxDecoration(
                                color: Colors.lightBlueAccent
                          ),
                              child:DropdownButton<String>(
                                isDense: true,
                                hint:  Text("Source"),
                                value: selSubSource,
                                onChanged: (String value) {
                                  selSubSource =  value;
                                  setState(() {

                                  });
                                  print (selSubSource);
                                },
                                items: sources.map((String sourceValue) {
                                  return DropdownMenuItem<String>(
                                    value: sourceValue.toString(),
                                    child:  Text(
                                      sourceValue,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                             Padding(
                               padding: EdgeInsets.all(10),
                             ),
                             Container(
                               padding: EdgeInsets.fromLTRB(
                                   5.0, 5.0, 5.0, 5.0),
                               decoration:BoxDecoration(
                                   color: Colors.lightBlueAccent
                               ),
                               child: DropdownButton<String>(
                                 isDense: true,
                                 hint:  Text("Destination"),
                                 value: selSubDest,
                                 onChanged: (String value) {
                                   selSubDest =  value;
                                   setState(() {

                                   });

                                   print (selSubDest);
                                 },
                                 items: destinations.map((String destValue) {
                                   return DropdownMenuItem<String>(
                                     value: destValue.toString(),
                                     child:  Text(
                                       destValue,
                                     ),
                                   );
                                 }).toList(),
                               ),
                             ),


                          ]
                        );
                      }
                    }
                ),
              ),

              SizedBox(height: 20,),
              Text('Date of Ride'),
              DateTimeField(
                decoration: InputDecoration(
                  fillColor: Colors.lightBlueAccent,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(
                      10.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                format: dateformat,
                onShowPicker: (context, currentValue) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(Duration(days: 1)),
                  initialDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days:30)));
                  },
                  controller: myController3,
                ),

              Text('Time of ride '),
              DateTimeField(
                decoration: InputDecoration(
                  fillColor: Colors.lightBlueAccent,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(
                      10.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
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
              SizedBox(height: 25,),
              ButtonTheme(
                minWidth: 200,
                height: 50,
                child : RaisedButton(
                  onPressed:goToViewRide,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    "Search Ride",
                    style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  
String goToViewRide()
  {
    try
    {
      print(DateTime.parse("${myController3.text} ${timeController.text}"));
      Navigator.push(context,MaterialPageRoute(builder: (context)=> CardViewDataPage(sd: SourceDest(selSubSource, selSubDest,DateTime.parse("${myController3.text} ${timeController.text}"))),fullscreenDialog: true));
    }
    catch(e)
    {
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        return Scaffold(
            body: Center(
                child: Text(e)));
      };
      print("error");
    }
    return e.toString();
  }
}
