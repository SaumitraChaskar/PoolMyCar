import 'package:bbc_login/Setup/UserAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {

  UserAccount userAccount;

  EditProfile(this.userAccount);

  @override
  Widget build(BuildContext context) {
    
  return Scaffold(
    appBar: AppBar(title:Text('Manage Profile')),
    resizeToAvoidBottomInset: false,
      body: Container(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage("Assets/images/user.png"),
              radius: 42,
            ),
            SizedBox(height: 20,),
            UserEditableCard(this.userAccount),
            
            ],
          ),
        ),
      ),
  );
  }

}

class UserEditableCard extends StatefulWidget {
  
  UserAccount userAccount;
 
  UserEditableCard(this.userAccount);

  @override
  _UserEditableCardState createState() => _UserEditableCardState(userAccount);
}

class _UserEditableCardState extends State<UserEditableCard> {

  UserAccount userAccount;
  TextEditingController unameController,conNoController,emailController,licNoController,carRegController;

  _UserEditableCardState(this.userAccount);

  @override
  void initState(){
    unameController = TextEditingController(text:userAccount.username);
    conNoController = TextEditingController(text:userAccount.contactNo);
    emailController = TextEditingController(text:userAccount.email);
    if(userAccount.isCarOwner){
      licNoController = TextEditingController(text:userAccount.licenseNo);
      carRegController = TextEditingController(text:userAccount.carRegeNo);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    if(userAccount.isCarOwner)
    {
      return Container(
       child: Column(
         children: <Widget>[
          Row(
             children: <Widget>[
               Icon(Icons.person, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                  child: TextField(
                  controller: unameController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 18,
                  )),
               ),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.phone_android, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                  child: TextField(
                 controller: conNoController,
                 keyboardType: TextInputType.phone,
                 style: TextStyle(
                   fontSize: 18,
                 )),
               ),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.email, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                   child: TextField(
                   controller: emailController,
                   keyboardType: TextInputType.emailAddress,
                   style: TextStyle(
                   fontSize: 18,
                 )),
               ),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.credit_card, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                   child: TextField(
                     autocorrect: true,
                   controller: licNoController,
                   keyboardType: TextInputType.text,
                 style: TextStyle(
                   fontSize: 18,
                 )),
               ),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.directions_car, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                  child: TextField(
                    autocorrect: true,
                  controller: carRegController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                  fontSize: 18,
                 )),
               ),
             ],
           ),
           RaisedButton(
              child: Text('Submit'),
              onPressed: () async{
                print('submit profile pressed');
                // showDialog(context: context, child: 
                //   AlertDialog(
                //     title: Text('Confirm Changes'),
                //     actions: <Widget>[
                //       Text()
                //     ],
                //   ))

                userAccount.username = unameController.text;
                userAccount.contactNo = conNoController.text;
                userAccount.email = emailController.text;
                userAccount.carRegeNo = carRegController.text;
                userAccount.licenseNo = licNoController.text;

                await updateAccount(userAccount);

                Navigator.pop(context);
            },
          ),
           
         ],
       ) 
      );
    }
    else{
      return Container(
       child: Column(
         children: <Widget>[
          Row(
             children: <Widget>[
               Icon(Icons.person, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                  child: TextField(
                  controller: unameController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 18,
                  )),
               ),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.phone_android, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                  child: TextField(
                 controller: conNoController,
                 keyboardType: TextInputType.phone,
                 style: TextStyle(
                   fontSize: 18,
                 )),
               ),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.email, color:Colors.blue, size:42),
               SizedBox(width:16),
               Expanded(
                   child: TextField(
                   controller: emailController,
                   keyboardType: TextInputType.emailAddress,
                   style: TextStyle(
                   fontSize: 18,
                 )),
               ),
             ],
           ),
           RaisedButton(
              child: Text('Submit'),
              onPressed: () async {
                print('submit profile pressed');
                  userAccount.username = unameController.text;
                  userAccount.contactNo = conNoController.text;
                  userAccount.email = emailController.text;            

                  await updateAccount(userAccount);

                  Navigator.pop(context);

                },
              ),           
         ],
       ) 
      );
    }
  }
}

void updateAccount(UserAccount userAccount) async{
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if(userAccount.isCarOwner)
  {
    await databaseReference.child('carowner').child(firebaseUser.uid).update({
      'username':userAccount.username,
      'email':userAccount.email,
      'contactNo':userAccount.contactNo,
      'licenseNo':userAccount.licenseNo,
      'carRegeNo':userAccount.carRegeNo,
    });
  } else{
    await databaseReference.child('passenger').child(firebaseUser.uid).update({
      'username':userAccount.username,
      'email':userAccount.email,
      'contactNo':userAccount.contactNo,
    });
  }

}