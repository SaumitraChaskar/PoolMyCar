
import 'package:bbc_login/Setup/data.dart';
import 'package:bbc_login/Setup/signin.dart';
import 'package:bbc_login/Setup/signup.dart';
import 'package:bbc_login/Setup/card_view.dart';
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
          child: new Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Assets/images/back1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: new Container(
              margin: EdgeInsets.fromLTRB(100,325,100,0),
              child:new ListView(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 200,
                    height: 50,
                    child : RaisedButton(
                      onPressed:navigateToCardData,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      child: Text("Offer A Ride"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  ButtonTheme(
                    minWidth: 200,
                    height: 50,
                    child : RaisedButton(
                      onPressed:navigateToCardData,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Text("Book A Ride"),
                    ),
                  ),
//                RaisedButton(
//                  onPressed:navigateToTabs,
//                  child: Text("Tabs"),
//                ),
//                RaisedButton(
//                  onPressed:navigateToHome,
//                  child: Text("Home"),
//                ),
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

  void navigateToData()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> DataPage(),fullscreenDialog: true));

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

