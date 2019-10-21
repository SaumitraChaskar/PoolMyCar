
import 'package:bbc_login/Setup/editprofile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'UserAccount.dart';

class UserProfile extends StatefulWidget {

  String uid;

  UserProfile(String uid){
    this.uid = uid;
  }

  @override
  _UserProfileState createState() => _UserProfileState(this.uid);
}

class _UserProfileState extends State<UserProfile> with AutomaticKeepAliveClientMixin<UserProfile>{
  String uid;
  Future<UserAccount> userAccount;

  _UserProfileState(this.uid);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    this.userAccount = getUserAccount(this.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: this.userAccount,
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
          print(asyncSnapshot.toString());
          if(asyncSnapshot.data == null)
          {
            return Container(
              child: Center(
                  child: Container(
                      child: CircularProgressIndicator(),
                alignment: Alignment(0.0, 0.0),
                  ),
              )
          );
          }else{
              UserAccount userAccount = asyncSnapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage("Assets/images/user.png"),
                      radius: 42,
                    ),
                    SizedBox(height: 20,),
                    UserCard(userAccount),
                    RaisedButton(
                      child: Text('Edit'),
                      onPressed: (){
                        print('edit profile pressed');
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfile(userAccount),fullscreenDialog: true));
                      },
                    )
                  ],
                ),
              );
            }
       
        },
      )
    );
  }

  Future<UserAccount> getUserAccount(String uid) async{
    UserAccount userAccount;
    dynamic userJson;
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance.reference();
    userAccount = await firebaseDatabase.child('carowner').child(uid).once()
      .then((DataSnapshot dataSnapshot) {
        UserAccount userAcc;
        if(dataSnapshot.value != null){
          userJson = dataSnapshot.value;
          userAcc = UserAccount(userJson['username'], userJson['email'], userJson['contactNo'], carRegeNo: userJson['carRegeNo'], licenseNo: userJson['licenseNo']);
        }
        return userAcc;
      });

      if(userJson == null){
        userAccount = await firebaseDatabase.child('passenger').child(uid).once()
        .then((DataSnapshot dataSnapshot) {
          UserAccount userAcc;
        if(dataSnapshot.value != null){
          userJson = dataSnapshot.value;
          userAcc =  UserAccount(userJson['username'].toString(), userJson['email'].toString(), userJson['contactNo'].toString());
          
        }
        return userAcc;
      });
      }
      return userAccount;
    }
}

class UserCard extends StatelessWidget {
  
  UserAccount userAccount;

  UserCard(this.userAccount);
  
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
               Text(userAccount.username,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.phone_android, color:Colors.blue, size:42),
               SizedBox(width:16),
               Text(userAccount.contactNo,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.email, color:Colors.blue, size:42),
               SizedBox(width:16),
               Text(userAccount.email,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.credit_card, color:Colors.blue, size:42),
               SizedBox(width:16),
               Text(userAccount.licenseNo,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
           ),
           SizedBox(
             height: 16,
           ),
          Row(
             children: <Widget>[
               Icon(Icons.directions_car, color:Colors.blue, size:42),
               SizedBox(width:16),
               Text(userAccount.carRegeNo,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
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
               Text(userAccount.username,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
           ),
           SizedBox(
             height: 16,
           ),
            Row(
             children: <Widget>[
               Icon(Icons.phone_android, color:Colors.blue, size:42),
               SizedBox(width:16),
               Text(userAccount.contactNo,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
           ),
           SizedBox(
             height: 16,
           ),
           Row(
             children: <Widget>[
               Icon(Icons.email, color:Colors.blue, size:42),
               SizedBox(width:16),
               Text(userAccount.email,
               style: TextStyle(
                 fontSize: 18,
               )),
             ],
           ),
         ],
       ) 
      );
    }
  }
}