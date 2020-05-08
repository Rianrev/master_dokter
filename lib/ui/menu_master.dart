import 'package:flutter/material.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'master_doctor.dart';
//import '../style/theme.dart' as Theme;

class MenuMasterPage extends StatefulWidget {
  @override
  _MenuMasterState  createState() => new _MenuMasterState();
  MenuMasterPage({Key key}) : super(key: key);
}
class _MenuMasterState extends State<MenuMasterPage> {
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
          automaticallyImplyLeading: true,
          title: Text('Master Data: Klinik Widya Bakti Inti'),
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
//                  onPressed: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => MasterCPT()),
//                    );
//                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.book,
                            color: Colors.white,
                            size:28.0),
                        Text("Data Tindakan",
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
                        Text("Data Obat",
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
                        Text("Data Diagnosa",
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MasterDoctor()),
                    );
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.attach_money,
                            color: Colors.white,
                            size:28),
                        Text("Data Dokter",
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
                    Navigator.pop(context);
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.exit_to_app,
                            color: Colors.white,
                            size:28),
                        Text("Kembali",
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