  
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
class Wait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    
    return Scaffold(
      body: Center(
        child: Container(
               color: Colors.transparent,
               height: h *200,
               width: b * 200,
               child: RiveAnimation.asset('images/loading7.riv',
               animation: "loading",
               ),
             ),
      ),
    );
  }
}