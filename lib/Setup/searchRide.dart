
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

    Future<List<Map>> _getDataForSource() async
    {
      final databaseReferenceRides = FirebaseDatabase.instance.reference().child("rides");
      var data;

      await databaseReferenceRides.once().then((DataSnapshot snapshot) {
        data = snapshot.value;
      });

      print(_myJson);
      data.forEach((key,ride){
        print(ride);
        _myJson.add(ride);
      });

      print(_myJson);
//      _myJson = [{"id":0,"name":"<New>"},{"id":1,"name":"Test Practice"}];
      return _myJson;
    }



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
                            items: _myJson.map((Map map) {                              
                              return new DropdownMenuItem<String>(
                                value: map["source"].toString(),
                                child: new Text(
                                  map["source"],
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
                            items: _myJson.map((Map map) {
                              return new DropdownMenuItem<String>(
                                value: map["dest"].toString(),
                                child: new Text(
                                  map["dest"],
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
          ],
        )
      ),
    );
  }

  
void goToViewRide()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> CardViewDataPage(sd: SourceDest(sourceController.text, destController.text,DateTime.parse("${myController3.text} ${timeController.text}"))),fullscreenDialog: true));
  }
}
