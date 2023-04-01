import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Consts/database_calls.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DialogVM {
  static DialogVM instance = DialogVM._();
  DialogVM._();
  DatabaseCallServices _databaseCallServices = DatabaseCallServices();
  

  onAddAdminPressed(BuildContext context, String name, String phoneNo,
      String adminPost, String clientVisible) {
    try {
      DatabaseReference _dbRef =
          _databaseCallServices.getDatabaseReference("admins");

      _databaseCallServices.pushUserDetail(_dbRef, {
        "name": name,
        "phoneNo": "+91$phoneNo", 
        "post": "Admin@$adminPost",
        "clientsVisible": clientVisible,
      });

      _databaseCallServices.pushFirestoreLoginDetail(
          phoneNo, {"value": "Admin@${adminPost}_ByManager"});
      _databaseCallServices.setSelectAdmin(clientVisible, {
        "selectedAdmin": _dbRef.key,
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }
  Future<bool> checkCustomClaim(String phoneNo, BuildContext context )async{
    bool data = await _databaseCallServices.getUserCustomClaim(phoneNo);

    if(data){
      return true;
    }
    else{
      AppConstant.showUpFailToast(context, "Number already taken");
      return false;
    }

  }
  onAddDelegatePressed(
      BuildContext context, String name, String post, String phoneNo) {
    try {
      String decidedTeam, byWhom;
      if (GlobalVar.strAccessLevel == "2") {
        decidedTeam = "managerTeam";
        byWhom = "ByManager";
      } else if (GlobalVar.strAccessLevel == "3") {
        decidedTeam = "adminTeam";
        byWhom = "ByAdmin";
      }
      DatabaseReference _dbRef = _databaseCallServices
          .getDatabaseReference("$decidedTeam");

      _databaseCallServices.pushUserDetail(_dbRef, {
        "name": name,
        "phoneNo": "+91$phoneNo",
        "post": "$post@Vysion",
        "clientsVisible": "",
        "headUid" : GlobalVar.userDetail.key
      });

      _databaseCallServices.pushFirestoreLoginDetail(phoneNo,
          {"value": "$post@Vysion_$byWhom"});
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  onAddManagerPressed(BuildContext context, String name, String phoneNo) {
    try {
      DatabaseReference _dbRef =
          _databaseCallServices.getDatabaseReference("managers");

      _databaseCallServices.pushUserDetail(_dbRef, {
        "name": name,
        "phoneNo": "+91$phoneNo",
        "post": "Manager@Vysion",
        "clientsVisible": ""
      });

      _databaseCallServices
          .pushFirestoreLoginDetail(phoneNo, {"value": "Manager_BySuperAdmin"});
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  onReplaceAdminPressed(BuildContext context, String name, String clientVisible,
      String phoneNo, String post, String uid)  async{
    try {
      DatabaseReference _dbRef =
          _databaseCallServices.getDatabaseReference("admins");

      _databaseCallServices.pushUserDetail(_dbRef, {
        "name": name,
        "phoneNo": "+91$phoneNo",
        "post": "Admin@$post",
        "clientsVisible": clientVisible,
      });

      _databaseCallServices.pushFirestoreLoginDetail(
          phoneNo, {"value": "Admin@${post}_ByManager"});

      _databaseCallServices.setSelectAdmin(clientVisible, {
        "selectedAdmin": _dbRef.key,
      });
      
      _updateClientDetailModel(context, "Admin", _dbRef.key);

       Map<String, dynamic> adminTeamData =  await _databaseCallServices.getAdminTeamMap(uid);
      if(adminTeamData!=null){
        adminTeamData.forEach((key, value) { 
                  value["headUid"] = _dbRef.key;
                });     
      _databaseCallServices.setAdminTeamMap(_dbRef.key, adminTeamData);
      }
      _databaseCallServices.removeAdmin(uid);

      Navigator.of(context).pop();
      
    } catch (e) {
      print(e);
    }
  }

  onReplaceManagerPressed(BuildContext context, String name,
      String clientVisible, String phoneNo, String uid) async {
    try {
      DatabaseReference _dbRef =
          _databaseCallServices.getDatabaseReference("managers");

      _databaseCallServices.pushUserDetail(_dbRef, {
        "name": name,
        "phoneNo": "+91$phoneNo",
        "post": "Manager@Vysion",
        "clientsVisible": clientVisible,
      });

      _databaseCallServices
          .pushFirestoreLoginDetail(phoneNo, {"value": "Manager_BySuperAdmin"});
      
      _updateClientDetailModel(context, "Manager", _dbRef.key);
      
      List<String> clientsList = clientVisible.split(",");
      for (int i = 0; i < clientsList.length; i++) {
        
        _databaseCallServices.setSelectManager(clientsList[i], {
          "selectedManager": _dbRef.key,
        });
      }
      Map<String, dynamic> managerData =  await _databaseCallServices.getManagerTeamMap(uid);
      if(managerData!=null){
      managerData.forEach((key, value) { 
                  value["headUid"] = _dbRef.key;
                });
                
      _databaseCallServices.setManagerTeamMap(_dbRef.key, managerData);
      
      }
      _databaseCallServices.removeManager(uid);

      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  _updateClientDetailModel(BuildContext context, String key, String id){
    
    if(key == "Admin")
    Provider.of<ChangeClient>(context, listen: false).clientDetailModel.selectedAdmin = id;
    else if(key== "Manager"){
    Provider.of<ChangeClient>(context, listen: false).clientDetailModel.selectedManager = id;
    }
  }

}
