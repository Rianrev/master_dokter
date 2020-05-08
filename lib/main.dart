import 'package:E_Klinik_web/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:E_Klinik_web/ui/login.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'client_provider.dart';

String username;
String role;
String jwtToken;

initState() async {
  LocalStorageInterface prefs = await LocalStorage.getInstance();
  jwtToken = prefs.getString('jwtToken') ?? "";
  role = prefs.getString('role') ?? "";
}

final String GRAPHQL_ENDPOINT = 'http://103.133.149.7:8080/v1/graphql';
final String SUBSCRIPTION_ENDPOINT = 'ws://103.133.149.7:8080/v1/subscriptions';

void main() {
  initState().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return jwtToken == "" ? MaterialApp (
      title: 'E-Klinik',
      theme: ThemeData (
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    ):
    ClientProvider (
      uri: GRAPHQL_ENDPOINT,
      subscriptionUri: SUBSCRIPTION_ENDPOINT,
      token: jwtToken,
      role: role,
      child: MaterialApp (
        title: 'E-Klinik',
        theme: ThemeData (
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

}