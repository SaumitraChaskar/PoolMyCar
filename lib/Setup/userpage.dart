import 'package:bbc_login/Setup/userhome.dart';
import 'package:bbc_login/Setup/userrides.dart';
import 'package:flutter/material.dart';

import 'Show_ride_plus_booking.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
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
              Scaffold(
                appBar: AppBar(
                    title: Text("My Profile")
                ),
                body: new Icon(Icons.perm_contact_calendar)
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