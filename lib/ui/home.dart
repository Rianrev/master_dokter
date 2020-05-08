import 'package:flutter/material.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'login.dart';
import 'menu_master.dart';
//import '../style/theme.dart' as Theme;

class HomePage extends StatefulWidget {
  @override
  _HomePageState  createState() => new _HomePageState();
  HomePage({Key key}) : super(key: key);
}
class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  String username;
  String role;

  Future<bool>getData() async {
    LocalStorageInterface prefs = await LocalStorage.getInstance();
    username = prefs.getString('username') ?? "";
    role = prefs.getString('role') ?? "";
    setState(() {});
    return true;
  }

  underConstruction(){
    scaffoldStateKey.currentState.showSnackBar(SnackBar(content: Text("Masih dalam pengembangan.")));
  }


  Logout() async {
    LocalStorageInterface prefs = await LocalStorage.getInstance();
    prefs.setString("jwtToken", "");
    prefs.setString("username", "");
    prefs.setString("role", "");
  }

  @override
  void initState() {
    super.initState();
    getData().then((_) {
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Klineeq: Klinik Widya Bakti Inti'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Selamat datang, $username.",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Aller",
                      fontSize: 16.0,
                    )
                  ),
                  accountEmail: Text("Roles: $role.",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Aller",
                          fontSize: 16.0,
                      )
                  )
                ),
                ListTile(
                  title: Text('Master Data',
                    style: TextStyle(fontFamily: "Aller",
                        fontSize: 16.0,
                        color: Colors.black)
                  ),
                  trailing: Icon(Icons.book),
                  onTap: () {
                    Navigator.pop(context);
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuMasterPage()
                      ),
                    );
                  },               
                ),
                ListTile(
                  title: Text('Pendaftaran',
                    style: TextStyle(fontFamily: "Aller",
                        fontSize: 16.0,
                        color: Colors.black)
                  ),
                  trailing: Icon(Icons.account_circle),
                  onTap: () {
                   // Navigator.pop(context);
                  },               
                ),
                ListTile(
                  title: Text('Tindakan',
                    style: TextStyle(fontFamily: "Aller",
                        fontSize: 16.0,
                        color: Colors.black)
                  ),
                  trailing: Icon(Icons.work),
                  onTap: () {
                   // Navigator.pop(context);
                  },               
                ),
                ListTile(
                  title: Text('Billing',
                    style: TextStyle(fontFamily: "Aller",
                        fontSize: 16.0,
                        color: Colors.black)
                  ),
                  trailing: Icon(Icons.monetization_on),
                  onTap: () {
                   // Navigator.pop(context);
                  },               
                ),
                ListTile(
                  title: Text('Laporan',
                    style: TextStyle(fontFamily: "Aller",
                        fontSize: 16.0,
                        color: Colors.black)
                  ),
                  trailing: Icon(Icons.report),
                  onTap: () {
                   // Navigator.pop(context);
                  },               
                ),
                Divider(height: 15.0,color: Colors.red),
                ListTile(
                  title: Text('Logout',
                    style: TextStyle(fontFamily: "Aller",
                        fontSize: 16.0,
                        color: Colors.black)
                  ),
                  trailing: Icon(Icons.exit_to_app),
                  onTap: () {
                    Logout();
                    Navigator.pop(context);
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()
                    ),
                  );
                  },               
                ),
              ]
            )
        ),
        body: Center(
          child:Container(
            width: MediaQuery
                .of(context)
                .size
                .width>700?700:MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: GridView.count(
            crossAxisCount: 3,
            primary: false,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                color: Colors.lightGreen[600],
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
  //                onPressed: () {
  //                  Navigator.push(
  //                    context,
  //                    MaterialPageRoute(
  //                        builder: (context) => NewProfilePage()),
  //                  );
  //                },
                  onPressed: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuMasterPage()
                      )
                    );
                   },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.book,
                            color: Colors.white,
                            size:28.0),
                        Text("Master Data",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
//                                fontFamily: Theme.Colors.text_font_home,
                            )
                        )
                      ]
                  )
                ),
              ),            
              Container(
                decoration: BoxDecoration(
                color: Colors.lightBlue[400],
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
  //                onPressed: () {
  //                  Navigator.push(
  //                    context,
  //                    MaterialPageRoute(
  //                        builder: (context) => NewProfilePage()),
  //                  );
  //                },
                  onPressed: () {  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.account_box,
                            color: Colors.white,
                            size:28.0),
                        Text("Pendaftaran",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
//                                fontFamily: Theme.Colors.text_font_home,
                            )
                        )
                      ]
                  )
                ),
              ),            
              Container(
                decoration: BoxDecoration(
                color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add,
                            color: Colors.white,
                            size:28),
                        Text("Tindakan",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
//                                fontFamily: Theme.Colors.text_font_home,
                            )
                        )
                      ]
                  )
                ),
              ),            
              Container(
                decoration: BoxDecoration(
                color: Colors.lime,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.attach_money,
                            color: Colors.white,
                            size:28),
                        Text("Billing",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
//                                fontFamily: Theme.Colors.text_font_home,
                            )
                        )
                      ]
                  )
                ),
              ),            
              Container(
                decoration: BoxDecoration(
                color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.report,
                            color: Colors.white,
                            size:28),
                        Text("Laporan",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
//                                fontFamily: Theme.Colors.text_font_home,
                            )
                        )
                      ]
                  )
                ),
              ),            
              Container(
                decoration: BoxDecoration(
                color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {  
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()
                    ));
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.exit_to_app,
                            color: Colors.white,
                            size:28),
                        Text("Logout",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
//                                fontFamily: Theme.Colors.text_font_home,
                            )
                        )
                      ]
                  )
                ),
              ),            
            ],
          )
        ),
        )
      );
  }
}