import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:toast/toast.dart';

class AppConstant {
   static Widget progressIndicator(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget circulerProgressIndicator(){
    return Center(
      child: Container(
        height: 200.0,
        width: 200.0,
        child: RiveAnimation.asset('images/loading7.riv',
                    animations: ["loading"],
                    ),
      ),
    );
  }

  // static Widget noDataFound(){
  //   return Center(
  //     child: Text("No Data Found",
  //     ),
  //   );
  // }

  static Widget noDataFound(){
    
    return Center(
      child: Container(
        height: 150.0,
        width: 150.0,
        child: Column(
          children: [
            sh(10),
                Image.asset(
                      'images/nodata1.png',
                    height: 80.0),
                sh(10),
                Text(
                      'No Data Available!',
                  style: txtS(blc,  14, FontWeight.w700),
                ),
                
          ],
        ),
      ),
    );
  }
  static Widget deactivatedClient(){
    return Center(
      child: Container(
        height: 250.0,
        width: 250.0,
        child: Column(
          children: [
            sh(10),
                Image.asset(
                      'images/noInternet.png',
                    height: 80.0),
                sh(10),
                Text(
                      'Client Deactivated!',
                  style: txtS(blc,  14, FontWeight.w700),
                ),
          ]
            ),
        ),
      );
  }
  static Widget whitenoDataFound(){
    return Center(
      child: Text("No Data Found",
      style: TextStyle(
        color: Colors.white
      ),
      ),
    );
  }
  static Widget noClientFound(){
    return Center(
      child: Container(
        height: 150.0,
        width: 150.0,
        child: Column(
          children: [
                sh(10),
                Image.asset(
                      'images/nodata1.png',
                    height: 80.0),
                sh(10),
                Text(
                      'No client found!',
                  style: txtS(blc,  14, FontWeight.w700),
                ),
                
          ],
        ),
      ),
    );
  }
  static Widget addClient(){
    return Center(
      child: Text("Add Client",
      style: TextStyle(
        color: Colors.black
      ),
      ),
    );
  }

  static  void showSuccessToast(BuildContext context,String msg, {int duration, int gravity}) {
    Toast.show(msg,  duration: 5,backgroundColor: Colors.green);
  }
  static  void showFailToast(BuildContext context,String msg, {int duration, int gravity}) {
    Toast.show(msg,  duration: 5,backgroundColor: Colors.red);
  }
  static  void showUpFailToast(BuildContext context,String msg, {int duration, int gravity}) {
    Toast.show(msg,  duration: 5,backgroundColor: Colors.red, gravity: 1);
  }
}

String privacy_policy_url = "";

const Color tc = Color(0xff979797);
const Color dc = Color(0xff263238);
const Color blc = Color(0xff0099ff);

TextStyle txtS(Color col, double siz, FontWeight wg) {
  return TextStyle(
    color: col,
    fontWeight: wg,
    fontSize: SizeConfig.screenWidth / 375 * siz,
  );
}

SizedBox sh(double h) {
  return SizedBox(height: h * SizeConfig.screenHeight / 812);
}
