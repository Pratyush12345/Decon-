import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/Dialogs/Error_occurred.dart';
import 'package:Decon/View_Android/Dialogs/please_wait_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
class MonthlyReport extends StatefulWidget {
  const MonthlyReport({ Key key }) : super(key: key);

  @override
  _MonthlyReportState createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  WebViewController controller ;
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
    return Consumer<ChangeSeries>(
      builder: (context, model, child){
        String url;
        if(HomePageVM.instance.getSeriesCode == "S0"){
          url = (GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].model as S0DeviceSettingModel)?.sheetURL??"";
        }
        else if(HomePageVM.instance.getSeriesCode == "S1"){
         url = (GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].model as S1DeviceSettingModel)?.sheetURL??"";
        }
        if(controller!=null){
          controller.loadUrl(url);
        }
       return WebView(

         onWebResourceError: (var val){
          print("Error Occurred");
          showErrorDialog(context, "Error Occured in loading page");
        }, 
        onWebViewCreated: (WebViewController _controller){
         showPleaseWaitDialog(context);
         controller = _controller;
         
        },
        onPageStarted: (String val){
         
        },
        onPageFinished: (String val){
          if(Navigator.of(context).canPop())
          Navigator.of(context).pop();
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url,
        //initialUrl: "https://docs.google.com/spreadsheets/d/1iQOqabuCeGCVBhlINeGHQbWHEEb20hQsaBysybOcwjA/edit#gid=0",
      );
      }
    );
  }
}