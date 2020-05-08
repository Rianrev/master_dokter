import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker_web/image_picker_web.dart';

class MasterDoctorForm extends StatefulWidget {
  final dynamic _data;
  MasterDoctorForm(this._data);

  @override
  _MasterDoctorFormState createState() => new _MasterDoctorFormState();
}

class _MasterDoctorFormState extends State<MasterDoctorForm> {
  String name = '';
  String error;
  Uint8List data;

  Uint8List _TTD;
  TextEditingController _NAMA_DOKTER;
  TextEditingController _NIPEG;
  int _SPESIALIS;
  String _KELOMPOK;
  TextEditingController _KODE_BPJS;
  TextEditingController _KETERANGAN;
  int _ID_DOKTER;

  final formKey = new GlobalKey<FormState>();

  bool edit = false;
  bool _uploadInProgress = false;
  GraphQLClient client;
  int idDokter;
  String namaDokter;
  String nipeg;
  int spesialis;
  String kodeBpjs;
  String kelompok;
  String keterangan;
  Uint8List ttd;

  @override
  initState() {
    super.initState();
    if (widget._data != null) {
      edit = true;
      _NAMA_DOKTER = TextEditingController(text: widget._data["nm_dokter"]);
      _NIPEG = TextEditingController(text: widget._data["nipeg"]);
      _SPESIALIS = widget._data["spesialis"];
      _KELOMPOK = widget._data["klp_pelaksana"];
      _KODE_BPJS = TextEditingController(text: widget._data['kode_dpjp_bpjs']);
      _KETERANGAN = TextEditingController(text: widget._data["ket"]);
      _ID_DOKTER = widget._data["id_dokter"];
    }
  }

  @override
  void dispose() {
    _NAMA_DOKTER.dispose();
    _NIPEG.dispose();
    _KODE_BPJS.dispose();
    _KETERANGAN.dispose();

    super.dispose();
  }

  Future<QueryResult> insertDokter() async {
    final MutationOptions _option = MutationOptions(
      documentNode: gql("""mutation insertDokter {
                              insert_doctor(objects: {
                              id_dokter: "$idDokter",
                              nm_dokter: "$namaDokter", 
                              nipeg: "$nipeg", 
                              klp_pelaksana: "$kelompok",
                              spesialis: "$spesialis",
                              ket: "$keterangan",
                              kode_dpjp_bpjs: "$kodeBpjs"})
                             {
                                returning {
                                  nm_dokter
                                } 
                             }
      }""")
    );
    return await client.mutate(_option);
  }

  Future<QueryResult> updateDokter() async {
    final MutationOptions _option = MutationOptions(
      documentNode: gql(""" mutation UpdateTask {
                              update_doctor(where: {id_dokter: {_eq: "$_ID_DOKTER"}}, 
                              _set: {
                                ket: "$keterangan", 
                                nipeg: "$nipeg", 
                                klp_pelaksana: "$kelompok",
                                spesialis: "$spesialis",
                                nm_dokter: "$namaDokter",
                                kode_dpjp_bpjs: "$kodeBpjs"}) 
                              {
                                returning {
                                  nm_dokter
                                }
                              }
      }""")
    );
    return await client.mutate(_option);
  }
  
  initMethod(context) {
    client = GraphQLProvider.of(context).value;
  }

//  getFile() {
//    final html.InputElement input = html.document.createElement('input');
//    input
//      ..t0ype = 'file'
//      ..accept = 'image/*';
//
//    input.onChange.listen((e) {
//      if (input.files.isEmpty) return;
//      final reader = html.FileReader();
//      reader.readAsDataUrl(input.files[0]);
//      reader.onError.listen((err) => setState(() {
//        error = err.toString();
//      }));
//      reader.onLoad.first.then((res) {
//        final encoded = reader.result as String;
//        // remove data:image/*;base64 preambule
//        final stripped =
//        encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
//
//        setState(() {
//          name = input.files[0].name;
//          data = base64.decode(stripped);
//          error = null;
//        });
//      });
//    });
//
//    input.click();
//  }

  pickImage() async {
    Uint8List fromPicker = await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    if (fromPicker != null) {
      setState(() {
        ttd = fromPicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => initMethod(context));
    return Scaffold(
      appBar: AppBar(
        title: Text("Dokter"),
        actions: [
          Container(
            padding: EdgeInsets.all(10.0) ,
            child: RaisedButton.icon(
              elevation: 1,
              padding: EdgeInsets.all(10.0),
              label: edit?Text("Update"):Text("Save"),
              icon: Icon(Icons.save),
              onPressed: (){
                if (edit) {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    updateDokter().then((value) {
                      if (value.data!=null) {
                        var d = value.data["update_doctor"]["returning"];
                        print(d);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    });
                  }
                } else {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    insertDokter().then((value) {
                      if (value.data!=null) {
                        var d = value.data["insert_doctor"]["returning"];
                        print(d);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    });
                  }
                }
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(10.0))
        ],
        automaticallyImplyLeading: true,
      ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Center(
                child:Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width>700?700:MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Form(
                      key: formKey,
                      child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _NAMA_DOKTER,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(labelText: 'Nama Dokter'),
                              maxLength: 100,
                              onSaved: (value) {
                                namaDokter = value;
                                idDokter = 1;
                              },
                              validator: (v) {
                                return v.isEmpty ? 'Nama Dokter diperlukan.' : null;
                              },
                            ),
                            TextFormField(
                              controller: _NIPEG,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'NIPEG'
                              ),
                              maxLength: 100,
                              onSaved: (value) {
                                nipeg = value;
                              },
                              validator: (v) {
                                return v.isEmpty ? 'NIPEG diperlukan' : null;
                              },
                            ),
                            TextFormField(
                              controller: _KODE_BPJS,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(labelText: 'Kode BPJS'),
                              maxLength: 100,
                              onSaved: (value) {
                                kodeBpjs = value;
                              },
                              validator: (v) {
                                return v.isEmpty ? 'Kode BPJS diperlukan.' : null;
                              },
                            ),
                            DropdownButtonFormField(
                              //key: formKey,
                              items: [
                                DropdownMenuItem(
                                    value: "Kelompok 1",
                                    child: new Text("Kelompok 1")),
                                DropdownMenuItem(
                                    value: "Kelompok 2",
                                    child: new Text("Kelompok 2")),
                              ],
                              value: widget._data==null?_KETERANGAN: widget._data["klp_pelaksana"],
                              decoration: InputDecoration(labelText: "Kelompok"),
                              onSaved: (value) {
                                setState(() {
                                  kelompok = value;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  kelompok = value;
                                });
                              },
                              // ignore: missing_return
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Mohon pilih kelompok';
                                }
                              },
                            ),
                            Padding(padding: new EdgeInsets.all(5.0)),
                            Query(
                                options: QueryOptions(documentNode: gql("{polyclinic {name,polyclinik_id,bpjs_code}}"), pollInterval: 10000),
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
                                    //print("-------");
                                    //print(json.encode(result));
                                    List myJson = result.data["polyclinic"];
                                    return DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: "Spesialis"),
                                      value: _SPESIALIS,
                                      items: myJson.map((dynamic map) {
                                        //print(map);
                                        return DropdownMenuItem(
                                            value: map["polyclinik_id"],
                                            child: new Text(map["name"]),
                                        );
                                      }
                                      ).toList(),
                                      onChanged: (v){
                                        spesialis = v;
                                      },
                                      onSaved: (v){
                                        spesialis = v;
                                      },
                                    );
                                  }
                                }
                            ),
                            Padding(padding: new EdgeInsets.all(5.0)),
                            TextFormField(
                              controller: _KETERANGAN,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(labelText: 'Keterangan'),
                              maxLength: 100,
                              onSaved: (value) {
                                keterangan = value;
                              },
                              validator: (v) {
                                return v.isEmpty ? 'Keterangan diperlukan.' : null;
                              },
                            ),
                            Padding(padding: new EdgeInsets.all(5.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    pickImage();
                                  },
                                  child: Text("Scan TTD"),
                                ),
                                Center(
                                  child: error != null
                                      ? Text(error)
                                      : ttd != null ? Image.memory(ttd) : Text('No data...'),
                                ),
                              ],
                            )
                          ]
                      )
                  ),
                )
            )
        )
    );
  }
}