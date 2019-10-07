
import 'package:date_format/date_format.dart';
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
  final dateformat = DateFormat("yyyy-dd-MM");
  final timeformat = DateFormat("HH:mm");
  final dbRideRef = FirebaseDatabase.instance.reference().child('rides');

  @override
  Widget build(BuildContext context){


    String _mySelectionSource;
    String _mySelectionDest;

    
    List<Map> _myJson = [];
    List<String> sources = [];
    List<String> destinations = [];

    Future<List<Map>> _getDataForSource() async
    {
      final databaseReferenceRides = FirebaseDatabase.instance.reference().child("rides");
      var data;

      await databaseReferenceRides.once().then((DataSnapshot snapshot) {
        data = snapshot.value;
      });

      data.forEach((key,ride){
        _myJson.add(ride);

        if(!sources.contains(ride['source'])){
          sources.add(ride['source']);
        }
        if(!destinations.contains(ride['dest'])){
          destinations.add(ride['dest']);
        }
      });

//      _myJson = [{"id":0,"name":"<New>"},{"id":1,"name":"Test Practice"}];
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
              TextField(
                autocorrect: true,
                controller: sourceController,
                decoration: InputDecoration(
                labelText: 'Enter starting point',
                contentPadding: new EdgeInsets.fromLTRB(
                                      10.0, 30.0, 10.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            
              ),
              SizedBox(height: 20),
              TextField(
                autocorrect: true,
                controller: destController,
                decoration: InputDecoration(
                labelText: 'Enter destination',
                contentPadding: new EdgeInsets.fromLTRB(
                                      10.0, 30.0, 10.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              
              SizedBox(
                height: 50,
              ),
              new Container(
                child: FutureBuilder(
                    future: _getDataForSource(),
                    builder:(BuildContext context ,AsyncSnapshot snapshot ){
                      if(snapshot.data == null)
                        {
                          return Container(
                            child: Text("Loading Destinations"),
                          );
                        }
                      else{
                        return Column(
                          children:<Widget>[
                            new DropdownButton<String>(
                              isDense: true,
                              hint: new Text("Source"),
                              value: _mySelectionSource,
                              onChanged: (String newValue) {

                                setState(() {
                                  _mySelectionSource = newValue;
                                  sourceController.text = _mySelectionSource;
                                });

                                print (_mySelectionSource);
                              },
                              items: sources.map((String sourceValue) {                              
                                return DropdownMenuItem<String>(
                                  value: sourceValue.toString(),
                                  child: new Text(
                                    sourceValue,
                                  ),
                                );
                              }).toList(),
                            ),
                            new DropdownButton<String>(
                              isDense: true,
                              hint: new Text("Destination"),
                              value: _mySelectionDest,
                              onChanged: (String newValue) {

                                setState(() {
                                  _mySelectionDest = newValue;
                                  destController.text = _mySelectionDest;
                                });

                                print (_mySelectionDest);
                              },
                              items: destinations.map((String destValue) {                              
                                return DropdownMenuItem<String>(
                                  value: destValue.toString(),
                                  child: new Text(
                                    destValue,
                                  ),
                                );
                              }).toList(),
                            ),
                          ]
                        );
                      }
                    }
                ),
              ),

              SizedBox(height: 20,),

              Text('Date of Ride: (${dateformat.pattern})'),
              DateTimeField(
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

              Text('Time of ride : (${timeformat.pattern})'),
              DateTimeField(
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
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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

  
void goToViewRide()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> CardViewDataPage(sd: SourceDest(sourceController.text, destController.text,DateTime.parse("${myController3.text} ${timeController.text}"))),fullscreenDialog: true));
  }
}
