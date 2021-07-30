import 'package:Decon/Models/Consts/base_calls.dart';
import 'package:Decon/Models/Consts/database_path.dart';
import 'package:Decon/Models/Models.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseCallServices extends BaseCall{
  
  Future<UserDetailModel> getSuperAdminCredentails(String uid) async {
   String url = "${DatabasePath.getSuperAdminCredentials}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }

  Future<UserDetailModel> getManagerCredentails(String uid) async {
   String url = "${DatabasePath.getManagerCredentials}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }
  Future setManagerClientVisible(String uid, String clientsVisible) async {
   String url = "${DatabasePath.getManagerCredentials}/$uid";
   return await databaseUpdateCall(url, {"clientsVisible": clientsVisible });
  }
  

  Future<UserDetailModel> getAdminCredentails(String uid) async {
   String url = "${DatabasePath.getAdminCredentials}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }

  Future<UserDetailModel> getManagerTeamCredentails(String uid) async {
   String url = "${DatabasePath.getManagerTeamCredentials}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }

  Future<UserDetailModel> getAdminTeamCredentails(String uid) async {
   String url = "${DatabasePath.getAdminCredentials}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }

  Future<UserDetailModel> getRandomUserCredentails(String uid) async {
   String url = "${DatabasePath.getRandomUser}/$uid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return UserDetailModel.fromJson(snapshot.key, snapshot.value);
  }

  Future<String> getManagerClientsVisible(String headUid) async {
   String url = "${DatabasePath.getManagerCredentials}/$headUid/clientsVisible";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return snapshot.value.toString();
  }

  Future<String> getAdminClientsVisible(String headUid) async {
   String url = "${DatabasePath.getAdminCredentials}/$headUid/clientsVisible";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return snapshot.value.toString();
  }

  Future<List<UserDetailModel>> getManagerTeamCredentailsList(String managerUid) async {
   String url = "${DatabasePath.getManagerTeamCredentials}/$managerUid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   List<UserDetailModel> _list = [];
   (snapshot.value as Map)?.forEach((key, value) { 
     _list.add(UserDetailModel.fromJson(key, value));
   });
    return _list;
    }

  Future<List<UserDetailModel>> getAdminTeamCredentailsList(String adminUid) async {
   String url = "${DatabasePath.getAdminTeamCredentials}/$adminUid";
   DataSnapshot snapshot = await databaseOnceCall(url);
   List<UserDetailModel> _list = [];
   (snapshot.value as Map)?.forEach((key, value) { 
     _list.add(UserDetailModel.fromJson(key, value));
   });
    return _list;
    }  

  Future<ClientDetailModel> getClientDetail(String clientCode) async {
   String url = "${DatabasePath.getClientDetail}/$clientCode/Detail";
   DataSnapshot snapshot = await databaseOnceCall(url);
   return ClientDetailModel.fromJson(snapshot.value);
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

  DatabaseReference getDatabaseReference(String path){
   String url = "$path";
   return FirebaseDatabase.instance.reference().child(url).push();
  }

  Future pushUserDetail(DatabaseReference ref ,Map<String, dynamic> json) async {
    String message = await databasePushUpdateCall(ref, json);
    return message;
  }
  Future pushFirestoreLoginDetail(String phoneNo ,Map<String, dynamic> json) async {
    String url = "+91$phoneNo";
    String message = await firestoreSetCall(url, json);
    return message;
  }
  Future setSelectAdmin(String clientCode, Map<String, dynamic> json) async{
    String url = "${DatabasePath.client}/$clientCode/Detail";
    return await databaseUpdateCall(url, json );
  }
  Future setSelectManager(String clientCode, Map<String, dynamic> json) async{
    String url = "${DatabasePath.client}/$clientCode/Detail";
    return await databaseUpdateCall(url, json );
  }

  Future<Map<String, dynamic>> getManagerTeamMap(String managerUid) async{
   String url = "${DatabasePath.getManagerTeamCredentials}";
   DataSnapshot snapshot = await databaseOrderByChildCall(url, "headUid", managerUid);
  if(snapshot.value!=null) 
  return Map<String, dynamic>.from(snapshot.value);
  else
  return null;
  }

  Future<Map<String, dynamic>> getAdminTeamMap(String adminUid ) async{
   String url = "${DatabasePath.getAdminTeamCredentials}";
   DataSnapshot snapshot = await databaseOrderByChildCall(url, "headUid", adminUid);
  if(snapshot.value!=null) 
  return Map<String, dynamic>.from(snapshot.value);
  else
  return null;
  }

  Future setManagerTeamMap(String managerUid, Map<String, dynamic> json) async{
    String url = "${DatabasePath.getManagerTeamCredentials}";
    return await databaseUpdateCall(url, json);
  }

  Future setAdminTeamMap(String adminUid, Map<String, dynamic> json) async{
    String url = "${DatabasePath.getAdminTeamCredentials}";
    return await databaseUpdateCall(url, json);
  }

  Future removeAdmin(String uid) async{
    String url = "${DatabasePath.getAdminCredentials}/$uid";
    return await databaseRemoveCall(url);
  }
  Future removeManager(String uid) async{
    String url = "${DatabasePath.getManagerCredentials}/$uid";
    return await databaseRemoveCall(url);
  }
  
  Future deactivateClient(String clientCode) async{
    String url = "${DatabasePath.client}/$clientCode";
    return await databaseUpdateCall(url, {"isActive" : 0} );
  }
  

  Future activateClient(String clientCode) async{
    String url = "${DatabasePath.client}/$clientCode";
    return await databaseUpdateCall(url, {"isActive" : 1} );
  }

  Future setDeviceSettingDefault(String clientCode, String seriesCode, String sheetUrl) async{
    String url = "${DatabasePath.client}/$clientCode/series/$seriesCode/DeviceSetting";
    if(seriesCode == "S0"){
    return await databaseUpdateCall(url, S0DeviceSettingModel(sheetURL: sheetUrl).toDefaultJson());
    }
    else if(seriesCode == "S1"){
    return await databaseUpdateCall(url, S1DeviceSettingModel(sheetURL: sheetUrl ).toDefaultJson());
    }
  }
 Future setDeviceSetting(String clientCode, String seriesCode, Map<String, dynamic> jsonData ) async{
    String url = "${DatabasePath.client}/$clientCode/series/$seriesCode/DeviceSetting";
    if(seriesCode == "S0"){
    return await databaseUpdateCall(url, jsonData);
    }
    else if(seriesCode == "S1"){
    return await databaseUpdateCall(url, jsonData);
    }
  }
}