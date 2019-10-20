
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bbc_login/Setup/signin.dart';
import 'package:email_validator/email_validator.dart';



class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  String _password,_email,_username,_contactNo,_licenseNo,_carRegNo;
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child:Scaffold(
          resizeToAvoidBottomPadding: false,
            appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.supervised_user_circle)),
                Tab(icon: Icon(Icons.directions_car)),
              ],
            ),
              title: Text('Sign Up'),
          ),
            body: TabBarView(
            children: [
                Scaffold(
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    title: Text("Passenger"),
                  ),
                  body:
                  Form(
                    key: _formkey1,
                    child: SingleChildScrollView(
                      child : Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Padding(
                            padding : const EdgeInsets.all(10),
                            child: TextFormField(
                              validator:(input){
                                if(input.isEmpty) {
                                  return 'Please fill the email';
                                }
                                if(EmailValidator.validate(input) == false) {
                                  return 'Email invalid';
                                }
                                return null;
                              } ,
                              onSaved: (input) => _email = input,
                              decoration: InputDecoration(
                                  fillColor: Colors.lightBlueAccent,
                                  filled: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 30.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  labelText: ' Email '),
                        
                            ),
                          ),

                          Padding(
                            padding : const EdgeInsets.all(10),
                            child: TextFormField(
                              validator:(input){
                                if(input.length < 6) {
                                  return 'Password not strong';
                                }
                                if(input.length > 20) {
                                  return 'Password too long please limit';
                                }
                                return null;
                              } ,
                              onSaved: (input) => _password = input,
                              decoration: InputDecoration(
                                  fillColor: Colors.lightBlueAccent,
                                  filled: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 30.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  labelText: ' Password '),
                                  obscureText: true,
                            ),
                          ),
                          Padding(
                            padding : const EdgeInsets.all(10),
                            child: TextFormField(
                              validator:(input){
                                if(input.isEmpty) {
                                  return 'Please fill the Username';
                                }
                                return null;
                              } ,
                              onSaved: (input) => _username = input,
                              decoration: InputDecoration(
                                  fillColor: Colors.lightBlueAccent,
                                  filled: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 30.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  labelText: ' Username '),
                            ),
                          ),
                          Padding(
                            padding : const EdgeInsets.all(10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator:(input){
                                if(input.length != 10) {
                                  return 'Please enter a valid phone mumber';
                                }
                                return null;
                              } ,
                              onSaved: (input) => _contactNo = input,
                              decoration: InputDecoration(
                                  fillColor: Colors.lightBlueAccent,
                                  filled: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 30.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  labelText: ' Contact No. '),
                            ),
                          ),
                          SizedBox(height: 30),
                          ButtonTheme(
                            minWidth: 200.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: Colors.blue,
                              onPressed:signUpPassenger,
                              child: Text("Sign Up"),
                            ),
                          ),
                        ],
                      ),
                    )
                )
            ),
              Scaffold(
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    title: Text("Car Owner"),
                  ),
                  body:
                  Form(
                      key: _formkey2,
                      child: SingleChildScrollView(
                        child : Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Padding(
                              padding : const EdgeInsets.all(10),
                              child: TextFormField(
                                validator:(input){
                                  if(input.isEmpty) {
                                    return 'Please fill the email';
                                  }
                                  if(EmailValidator.validate(input) == false) {
                                    return 'Email invalid';
                                  }
                                  return null;
                                } ,
                                onSaved: (input) => _email = input,
                                decoration: InputDecoration(
                                    fillColor: Colors.lightBlueAccent,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 30.0, 10.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelText: ' Email '),
                              ),
                            ),

                            Padding(
                              padding : const EdgeInsets.all(10),
                              child: TextFormField(
                                validator:(input){
                                  if(input.length < 6) {
                                    return 'Password not strong';
                                  }
                                  if(input.length > 20) {
                                    return 'Password too long please limit';
                                  }
                                  return null;
                                } ,
                                onSaved: (input) => _password = input,
                                decoration: InputDecoration(
                                    fillColor: Colors.lightBlueAccent,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 30.0, 10.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelText: ' Password '),
                                obscureText: true,
                              ),
                            ),
                            Padding(
                              padding : const EdgeInsets.all(10),
                              child: TextFormField(
                                validator:(input){
                                  if(input.isEmpty) {
                                    return 'Please fill the Username';
                                  }
                                  return null;
                                } ,
                                onSaved: (input) => _username = input,
                                decoration: InputDecoration(
                                    fillColor: Colors.lightBlueAccent,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 30.0, 10.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelText: ' Username '),
                              ),
                            ),
                            Padding(
                              padding : const EdgeInsets.all(10),
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                validator:(input){
                                  if(input.isEmpty) {
                                    return "Enter contact number";
                                  }
                                  if(input.length != 10) {
                                    return "Invalid Contact";
                                  }
                                  return null;
                                } ,
                                onSaved: (input) => _contactNo = input,
                                decoration: InputDecoration(
                                    fillColor: Colors.lightBlueAccent,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 30.0, 10.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelText: ' Contact No. '),
                              ),
                            ),
                            Padding(
                              padding : const EdgeInsets.all(10),
                              child: TextFormField(
                                validator:(input){
                                  if(input.isEmpty) {
                                    return 'Please fill Your license ID';
                                  }
                                  return null;
                                } ,
                                onSaved: (input) => _licenseNo = input,
                                decoration: InputDecoration(
                                    fillColor: Colors.lightBlueAccent,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 30.0, 10.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelText: ' License Id. '),
                              ),
                            ),
                            SizedBox(height:10),
                            Padding(
                              padding : const EdgeInsets.all(10),
                              child: TextFormField(
                                validator:(input){
                                  if(input.isEmpty) {
                                    return 'Please fill Your Car Registration Number';
                                  }
                                  return null;
                                } ,
                                onSaved: (input) => _carRegNo = input,
                                decoration: InputDecoration(
                                    fillColor: Colors.lightBlueAccent,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 30.0, 10.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelText: ' Car Registration No. '),
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 200.0,
                              height: 50.0,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed:signUpCarOwner,
                                child: Text("Sign Up"),
                              ),
                            ),
                          ],
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      );
  }


  Future<void> signUpPassenger() async{
    final formstate = _formkey1.currentState;
    if(formstate.validate() == true){
      print(formstate);
      formstate.save();
      var userUid;
      try
      {
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LoginPage()));
        userUid = user.uid;
      }
      catch(e)
      {
        print(e.message);
      }

      final databaseReference = FirebaseDatabase.instance.reference();

      databaseReference.child("passenger").child(userUid).set({
        'username':_username,
        'contactNo':_contactNo,
        'email':_email,
      });
    }
  }

  Future<void> signUpCarOwner() async{
    final formstate = _formkey2.currentState;
    if(formstate.validate() == true){
      formstate.save();
      var userUid;
      try
      {
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LoginPage()));
        userUid = user.uid;
      }
      catch(e)
      {
        print(e.message);
      }

      final databaseReference = FirebaseDatabase.instance.reference();

      databaseReference.child("carowner").child(userUid).set({
        'username':_username,
        'contactNo':_contactNo,
        'email':_email,
        'licenseNo':_licenseNo,
        'carRegeNo' : _carRegNo,
      });

      final databaseReference1 = FirebaseDatabase.instance.reference();

      databaseReference1.child("passenger").child(userUid).set({
        'username':_username,
        'contactNo':_contactNo,
        'email':_email,
      });
    }
  }
}

