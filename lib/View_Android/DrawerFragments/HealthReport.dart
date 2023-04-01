
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthReport extends StatelessWidget{
  
  HealthReport();
  launchUrl() async{
    const url='https://docs.google.com/spreadsheets/d/1iQOqabuCeGCVBhlINeGHQbWHEEb20hQsaBysybOcwjA/edit#gid=0';
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw 'Could not lauch url';
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: MaterialButton(
        onPressed: launchUrl,
        child: Text('health_report_message'),
      )
    );
  } 

}