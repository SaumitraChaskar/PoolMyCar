import 'package:bbc_login/Setup/Show_ride_plus_booking.dart';
import 'package:bbc_login/Setup/card_view.dart';
import 'package:bbc_login/Setup/userhome.dart';
import 'package:bbc_login/Setup/userrides.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 3,
        child: new Scaffold(
          body: TabBarView(
            children: [
              new Container(
                child: new UserHomePage(),
              ),
              new Container(
                child:Scaffold(
                  appBar: AppBar(
                    title: Text("My Rides")
                  ),
                  body: //UserRideDataPage(),
                  DriverViewPage(),
              ),
              ),
              new Container(  
                child:Scaffold(
                  appBar: AppBar(
                      title: Text("My Profile")
                  ),
                  body: new Icon(Icons.perm_contact_calendar),
                ),
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.rss_feed),
              ),
              Tab(
                icon: new Icon(Icons.perm_identity),
              ),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
