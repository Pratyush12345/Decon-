import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:flutter/material.dart';

class ErrorOccurred extends StatelessWidget {
  final String msg;
  ErrorOccurred({ Key key, @required this.msg }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: b * 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 12),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          sh(16),
                      Text(
                          msg,
                          style: TextStyle(
                            fontSize: b * 16,
                            color: dc,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
          sh(16),
        ]),
      ),
    );

  }
}