
import 'package:bbc_login/Setup/signin.dart';
import 'package:bbc_login/Setup/signup.dart';
import 'package:bbc_login/Setup/tabs.dart';
import 'package:flutter/material.dart';

import 'feedback.dart';
import 'home.dart';
import 'searchRide.dart';



class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PoolMyCar'),
      ),
      body: new Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Assets/images/back1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(100,325,100,0),
              child: ListView(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 200,
                    height: 50,
                    child : RaisedButton(
                      onPressed:navigateToSignIn,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      child: Text("Offer A Ride",
                      style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  ButtonTheme(
                    minWidth: 200,
                    height: 50,
                    child : RaisedButton(
                      onPressed:navigateToSignIn,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Text("Book A Ride",
                        style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(),
                  ),
                ],
              ),
            ),
        )
      )
    );
  }

  void navigateToSignIn()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> LoginPage(),fullscreenDialog: true));
  }

  void navigateToSignUp()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> SignUpPage(),fullscreenDialog: true));

  }

  void navigateToCardData()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> SearchRidePage(),fullscreenDialog: true));
  }

  void navigateToFeedbackPage()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> FeedbackPage(),fullscreenDialog: true));
  }

  void navigateToTabs()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> TabPage(),fullscreenDialog: true));
  }

  void navigateToHome()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> HomePage(),fullscreenDialog: true));

  }

}

