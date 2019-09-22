import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';


class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

final databaseReference = FirebaseDatabase.instance.reference();

class _DataPageState extends State<DataPage> {

  var jsonData = [
    { "index":0,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email1@g",
      "name":"ABC1",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":1,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email2@g",
      "name":"ABC2",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":2,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email3@g",
      "name":"ABC3",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },
    { "index":3,
      "about":"cajbav a, ajva v,andvlabvjd, adv alnvlanv",
      "email":"email4@g",
      "name":"ABC4",
      "image":"https://img.icons8.com/bubbles/50/000000/user.png"
    },

  ];



  Future<List<User>> _getUsers() async{

    List<User> users = [];

    for(var u  in jsonData)
    {
      User user =  User(u["index"],u["about"],u["name"],u["email"],u["image"]);

      users.add(user);

    }
    print(users[0].index);
    print(users.length);


    return users;

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
      ),
      body:Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder:(BuildContext context ,AsyncSnapshot snapshot ){

            if(snapshot.data == null)
            {
              return Container(
                child: Center(
                    child:Text("Loading...")
                ),
              );
            }
            else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index].image
                        ),
                      ),
                      title: Text(snapshot.data[index].name),
                    );
                  }

              );
            }
          },
        ),
      )

    );


  }
}

class User{

  final int index;
  final String about;
  final String name;
  final String email;
  final String image;

  User(this.index,this.about,this.name,this.email,this.image);

}
