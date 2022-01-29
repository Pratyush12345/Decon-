import 'package:Decon/View_Android/Authentication/Wait.dart';
import 'package:Decon/View_Android/MainPage/HomePage.dart';
import 'package:Decon/Controller/ViewModels/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    _returnFuture() async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      print("issigned in mmmmmmmmmmmmmmmmmmmm");
      print(pref.getBool("isSignedIn"));
      print("issigned in mmmmmmmmmmmmmmmmmmmm");
      return pref.getBool("isSignedIn")!=null ? Auth.instance.alreadyLogin(FirebaseAuth.instance.currentUser)  : Auth.instance.firstTimeLogin(FirebaseAuth.instance.currentUser);
    }

    return FutureBuilder(
        future: _returnFuture(),
        builder: (context, snap) {
          if(snap.connectionState==ConnectionState.done){
        
          if (snap.hasData) {
            return HomePage();
                  
          }
           return Wait();
          } else {
            return Wait();
          }
        },
      );
  }
}

