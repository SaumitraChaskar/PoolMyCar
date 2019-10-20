import 'package:bbc_login/Setup/userpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _password,_email;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body:
      Form(
          key: _formkey,
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
                    decoration: new InputDecoration(
                        fillColor: Colors.lightBlueAccent,
                        filled: true,
                        contentPadding: new EdgeInsets.fromLTRB(
                            10.0, 30.0, 10.0, 10.0),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        labelText: ' Email '),
                  ),
                ),

                Padding(
                  padding : const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    validator:(input){
                      if(input.length < 6) {
                        return 'Password not correct';
                      }
                      return null;
                    } ,
                    onSaved: (input) => _password = input,
                    decoration: new InputDecoration(
                      fillColor: Colors.lightBlueAccent,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 30.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      labelText: ' Password '),
                  ),
                ),

                SizedBox(height: 50),
                ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed:signIn,
                    child: Text("Sign In"),
                  ),
                ),
              ],
            ),
          )
      )
    );
  }

  Future<void> signIn() async{
    final formstate = _formkey.currentState;
    if(formstate.validate() == true){
      formstate.save();
      try
      {
        AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(context,MaterialPageRoute(builder: (context)=> UserPage()));
      }
      catch(e)
      {
        print(e.message);
      }
    }
  }
}
