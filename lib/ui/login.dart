import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import '../main.dart';


//import 'dart:async';

class User {
    User();

    String userName;
    String password;
    
    //factory User.fromJson(Map<String,dynamic> json) => _UserFromJson(json);
    //Map<String, dynamic> toJson() => _UserToJson(this);

    User fromJson(Map<String, dynamic> json) {
      return User()
        ..userName = json['userName'] as String
        ..password = json['password'] as String;
    }

    Map<String, dynamic> toJson(User instance) => <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password
    };
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = "";
  User user = new User();

  updateState(String username, String role, String jwtToken) async {
    LocalStorageInterface prefs = await LocalStorage.getInstance();
    prefs.setString("jwtToken", jwtToken);
    prefs.setString("username", username);
    prefs.setString("role", role);
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: buildPageContent(),
    );
  }

  Widget buildPageContent() {
    var appName = Text(
      "e-Clinique",
      style: TextStyle(fontSize: 16, color: Colors.green),
      textScaleFactor: 3.2,
    );
    return Container(
      color: Colors.blue.shade100,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 60.0,
          ),
          Center(child: appName),
          SizedBox(
            height: 20.0,
          ),
          buildLoginForm(),
        ],
      ),
    );
  }

  Container buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          Center(
            child: ClipPath(
              clipper: WaveClipperTwo(reverse: true),
              child: Container(
                width: 500,
                height: 400,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.white,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: TextFormField(
                          initialValue: user.userName,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            icon: Icon(
                              Icons.people,
                              color: Colors.blue,
                            ),
                          ),
                          onSaved: (v) {
                            user.userName = v;
                          },
                          validator: (v) {
                            return v.isEmpty ? 'Username diperlukan' : null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: TextFormField(
                          obscureText: true,
                          initialValue: user.password,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            icon: Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                          ),
                          onSaved: (v) {
                            user.password = v;
                          },
                          validator: (v) {
                            return v.isEmpty ? 'Password diperlukan.' : null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {}//register(),
                          ),
                          FlatButton(
                            child: Text(
                              "Lupa password",
                              style: TextStyle(color: Colors.black45),
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: Icon(Icons.person),
              ),
            ],
          ),
          Container(
            height: 380,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 420,
              child: RaisedButton(
                onPressed: () {
                  login();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                child: Text("Login", style: TextStyle(color: Colors.white70, fontSize: 20)),
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  login() async {
    var form = formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();
    var body = {"username": "${user.userName}", "password": "${user.password}" };
    print(json.encode(body));
    await http.post('http://103.133.149.7:8090/login',
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode(body)).then((http.Response response) {
                          print(response.body);
                          var map = json.decode(response.body);
                          //error = map["error"];
                          if (map.containsKey("error")) {
                            print(map["error"]);
                            Toast.show(map["error"], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                            setState(() {});
                          } else
                          {
                            String r = map["roles"][0];
                            print(r);
                            updateState(map["username"], r, map["token"]);
                            jwtToken = map["token"];
                            role = r;
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
                          }

                        }).catchError((e) {
                          error = e;
                          setState(() {});
                        });

  }
}