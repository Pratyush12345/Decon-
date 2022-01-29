import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/View_Android/Dialogs/Error_occurred.dart';
import 'package:Decon/View_Android/Dialogs/please_wait_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({ Key key }) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  
  Future showPleaseWaitDialog(BuildContext context) {
    return showAnimatedDialog(
        barrierDismissible: false,
        context: context,  
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return PleaseWait();
        });
  }

  Future showErrorDialog(BuildContext context, String msg) {
    return showAnimatedDialog(
        barrierDismissible: false,
        context: context,  
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return ErrorOccurred(msg: msg,);
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeClient>(
      builder: (context, model, child)=>
       WebView(
        onWebResourceError: (var val){
          print("Error Occurred");
          showErrorDialog(context, "Error Occured in loading page");
        }, 
        onWebViewCreated: (var controller){
          showPleaseWaitDialog(context);
        },
        onPageStarted: (String val){
         
        },
        onPageFinished: (String val){
          if(Navigator.of(context).canPop())
          Navigator.of(context).pop();
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: "https://docs.google.com/document/d/1zh_NVGkU8hlnc8sdfQF3Ia0sfFE-JaBA4HHJ_vk3ZoY/edit?usp=sharing",
        //initialUrl: "https://docs.google.com/spreadsheets/d/1iQOqabuCeGCVBhlINeGHQbWHEEb20hQsaBysybOcwjA/edit#gid=0",
      ),
    );
  }
}