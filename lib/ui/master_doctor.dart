import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'masterdoctor_form.dart';

class MasterDoctor extends StatefulWidget {
  MasterDoctor({Key key}):super(key:key);

  @override
  _MasterDoctorState createState() => new _MasterDoctorState();
}

class _MasterDoctorState extends State<MasterDoctor> {

  GraphQLClient client;
  final TextEditingController _searchQuery = new TextEditingController();
  String searchQuery = "";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String query =
  """
  query Get {
    doctor {
      ket
      klp_pelaksana
      nipeg
      nm_dokter
      scan_ttd
      spesialis
      kode_dpjp_bpjs
      id_dokter
    }
    polyclinic {
      bpjs_code
      name
      polyclinik_id
    }
  }

  """;

  initMethod(context) {
    client = GraphQLProvider.of(context).value;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.dispose();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      query =
          """
            query Get {
              doctor(where: {nm_dokter: {_like: "%$newQuery%"}}) {
                ket
                klp_pelaksana
                nipeg
                nm_dokter
                spesialis
                kode_dpjp_bpjs
                id_dokter
              }
              polyclinic {
                bpjs_code
                name
                polyclinik_id
              }
            }
          """;
    });
  }
  
  Future<QueryResult> deleteDokter(int idDokter) async {
    print(idDokter);
    
    final MutationOptions _option = MutationOptions(
      documentNode: gql("""mutation delete_dokter {
                            delete_doctor(where: {id_dokter: {_eq: "$idDokter"}}) {
                              returning {
                                nm_dokter
                              }
                            }
                          }
      """)
    );
    return await client.mutate(_option);
  }

  Future<bool> promptUser(DismissDirection direction) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text("Are you sure you want to delete?"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              return Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => initMethod(context));
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Manajemen Tindakan Klinik'),
      ),
      body: Center(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(children: [
                Expanded(
                    child:TextField(
                      controller: _searchQuery,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,//this has no effect
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        suffixIcon:  IconButton(
                            icon: Icon(Icons.clear),
                            onPressed:
                            _searchQuery.clear
                          // },
                        ),
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 16.0),
                    )
                ),
                SizedBox(
                    width: 50,
                    child:IconButton(
                      icon: const Icon(Icons.search, size: 36.0),
                      onPressed: () {updateSearchQuery(_searchQuery.text);},
                    )
                )
              ]),
            ),
            Expanded(
                child:
                Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Query(
                        options: QueryOptions(documentNode: gql(query), pollInterval: 10000),
                        builder: (QueryResult result, {Future<QueryResult> Function() refetch, FetchMore fetchMore}) {
                          //print(json.encode(result));
                          if (result.hasException) {
                            print(result.exception.toString());
                            return Text(result.exception.toString());
                          }
                          if (result.loading) {
                            return Center(child: const CircularProgressIndicator());
                          }
                          if (result.data == null) {
                            return Center(child: const CircularProgressIndicator());
                          } else {
                            // print("masuk sini");
                            return ListView.builder(
                                itemCount: result.data["doctor"].length,
                                itemBuilder: (BuildContext context, int index) {
                                  final data = result.data["doctor"][index];
                                  return Dismissible(
                                    key: Key('$data$index'),
                                    direction: DismissDirection.endToStart,
                                    background: Container(color: Colors.red,
                                        alignment: AlignmentDirectional.centerEnd,
                                        child: Icon(Icons.delete, color: Colors.white)
                                    ),
                                    confirmDismiss: (direction) => promptUser(direction),
                                    onDismissed: (direction) {
                                      print(data["id_dokter"]);
                                      deleteDokter(result.data["doctor"][index]["id_dokter"]).then((value) {
                                        var d = value.data["delete_doctor"]["returning"];
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(content: Text("$d dihapus")));
                                        setState((){});
                                      });
                                    },
                                    child: Card(
                                      elevation: 8.0,
                                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                        child:
                                        ListTile(
                                          title: Text(
                                            "${data["nm_dokter"]}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "NIPEG: ${result.data["doctor"][index]["nipeg"]}",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          trailing: IconButton(
                                              icon: Icon(Icons.mode_edit, color: Colors.white, size:30.0),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MasterDoctorForm(result.data["doctor"][index])),
                                                ).then((value) {
                                                  setState(() { // Supaya refresh page setelah kembali dari update
                                                  });
                                                });
                                              }
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          }
                        }
                    )
                )
            ),

          ],)
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MasterDoctorForm(null)),
          ).then((value) {
            setState(() { // Supaya refresh page setelah kembali dari add
            });
          });
        },
      ),
    );
  }

}