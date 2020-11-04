import 'package:Decon/Authentication/Phoneverif.dart';
import 'package:Decon/Dialogs/UploadDialog.dart';
import 'package:Decon/MainPage/HomePage.dart';
import 'package:Decon/Services/Auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences pref;
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  SharedPreferences prefs;
  
  @override
  Widget build(BuildContext context) {
    _getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(
              0xFFFFFFFFF,
              <int, Color>{
                50: Color(0xFFFBE9E7),
                100: Color(0xFFFFCCBC),
                200: Color(0xFFFFAB91),
                300: Color(0xFFFF8A65),
                400: Color(0xFFFF7043),
                500: Color(0xffF36C24),
                600: Color(0xFFF4511E),
                700: Color(0xFFE64A19),
                800: Color(0xFFD84315),
                900: Color(0xFFBF360C),
              },
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
     // home: pref.getBool("isSignedIn")??false ?Auth.instance.handleAfterSignIn() : Auth.instance.handleAuth(),
      home: FutureBuilder(
        future: _getPrefs(),
        builder: (context, snap) {
          if (snap.hasData) {
            if (prefs?.getBool('isSignedIn') == true) {
              Auth.instance.handleAfterSignIn();
              return UploadDialog(warning: 'Logging In');
            }
            return PhoneVerif();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

