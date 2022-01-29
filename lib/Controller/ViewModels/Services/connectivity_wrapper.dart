import 'package:Decon/Controller/ViewModels/Services/auth_wrapper.dart';
import 'package:Decon/Models/Consts/NointernetScreen.dart';
import 'package:Decon/View_Android/Authentication/Wait.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivitytWrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

      return StreamBuilder(
        stream: Connectivity().onConnectivityChanged ,
        builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.active){
               print("ccccccccccccccccccc");
               print(snapshot.data.toString());
               print("ccccccccccccccccccc");
              if(snapshot.data.toString()  != ConnectivityResult.none.toString())
              {
                return AuthWrapper();
              }
              
              else{
              if(Navigator.canPop(context)){
          
                Navigator.of(context).pop();
              }  
              return  NoInternetScreen();       
              }
              }
        
        return Wait();
     
        }, 
      ); 
}
}