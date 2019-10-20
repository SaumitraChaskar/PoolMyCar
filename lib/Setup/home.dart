import 'package:bbc_login/Setup/signin.dart';
import 'package:bbc_login/Setup/tabs.dart';
import 'package:bbc_login/Setup/welcome.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              WelcomePage(),
              TabPage(),
              LoginPage(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.rss_feed),
              ),
              Tab(
                icon: Icon(Icons.perm_identity),
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