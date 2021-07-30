import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/View_Android/Dialogs/Error_occurred.dart';
import 'package:Decon/View_Android/Dialogs/please_wait_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
class MaintainenceReport extends StatefulWidget {
  const MaintainenceReport({ Key key }) : super(key: key);

  @override
  _MaintainenceReportState createState() => _MaintainenceReportState();
}

class _MaintainenceReportState extends State<MaintainenceReport> {
  
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
        initialUrl: model.clientDetailModel.maintainenceSheetURL,
        //initialUrl: "https://docs.google.com/spreadsheets/d/1iQOqabuCeGCVBhlINeGHQbWHEEb20hQsaBysybOcwjA/edit#gid=0",
      ),
    );
  }
}