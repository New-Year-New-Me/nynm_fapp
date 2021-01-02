import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nynm_fapp/components/auth/forgetPassword.dart';
import 'package:nynm_fapp/components/resolution/addResolution.dart';

import 'components/auth/login.dart';
import 'components/auth/register.dart';
import 'components/auth/splash.dart';

void main() async {
  // https://stackoverflow.com/a/63740416
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Year New Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext ctx) => LoginPage(),
        '/register': (BuildContext ctx) => RegisterPage(),
        '/forgetPassword': (BuildContext ctx) => ForgetPassword(),
        '/addResolution': (BuildContext context) => AddResolution()
      },
    );
  }
}
