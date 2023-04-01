import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PleaseWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: b * 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 12),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: EdgeInsets.fromLTRB(b * 14, h * 16, b * 14, h * 16),
          child: Column(children: [
             Container(
               height: h *100,
               width: b * 100,
               child: Center( 
                  child: RiveAnimation.asset('images/loading3.riv',
                  animations: ["Animation 1"],
                  ),
                ),
             ),
            Text(
              "Please Wait...",
              textAlign: TextAlign.center,
              style: txtS(dc, b * 16, FontWeight.w400),
            ),
            sh(38),
            
          ]),
        ),
      ]),
    );
  }
}


