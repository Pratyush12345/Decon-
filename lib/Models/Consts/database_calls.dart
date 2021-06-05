import 'dart:convert';

import 'package:Decon/Models/Consts/base_calls.dart';
import 'package:Decon/Models/Consts/database_path.dart';
import 'package:Decon/Models/Models.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseCallServices extends BaseCall{
  
  Future<UserDetailModel> getSuperAdminCrdentails(String uid) async {
   String url = "${DatabasePath.getSuperAdminCredentials}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }

  Future<UserDetailModel> getManagerCrdentails(String uid) async {
   String url = "${DatabasePath.getManagerCredentials}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }

  Future<String> getSeriesList() async {
   String url = "${DatabasePath.getSeriesList}";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return snapshot.value;
  }

  Future<String> setClientDetail(String clientCode, ClientDetailModel model) async {
    String url = "${DatabasePath.setClientDetail}/$clientCode/Detail";
    String message = await databaseUpdateCall(url, model.toJson());
    return message;
  }

  
  Future setClientList(ClientListModel model) async {
    String url = "${DatabasePath.setClientList}";
    String message = await databaseUpdateCall(url, model.toJson());
    return message;
  }

}