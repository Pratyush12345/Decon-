import 'package:Decon/View_Android/Authentication/Wait.dart';
import 'package:Decon/View_Android/MainPage/HomePage.dart';
import 'package:Decon/Controller/Services/Auth.dart';
import 'package:Decon/Controller/Services/SplashCarousel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Wrapper2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Auth.instance.pref.getBool("isSignedIn")??false ? Auth.instance.updateClaims(FirebaseAuth.instance.currentUser)  : Auth.instance.delayedLogin(FirebaseAuth.instance.currentUser),
        builder: (context, snap) {
          if (snap.hasData) {
            return HomePage();      
          } else {
            // if(Auth.instance.pref.getBool("isSignedIn"))
            // return Wait();
            // else
            // return SplashCarousel();
            return Wait();
          }
        },
      );
  }
}

// Future<String> _getFlare(BuildContext context) async{
//   return await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => FlareLoading(
//                 name: 'assets/gurucool.flr',
//                 onSuccess: (_) {
//                   Navigator.of(context).pop();
//                   return "done";
//                 },
//                 onError: (_, __) {},
//                 startAnimation: 'animation',
//                 endAnimation: '',
//                 until: () => Future.delayed(Duration(seconds: 10)),
//               ),
//             ),
//           );

// }