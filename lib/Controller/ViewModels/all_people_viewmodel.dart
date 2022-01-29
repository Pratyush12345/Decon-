import 'package:Decon/Controller/Providers/People_provider.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Models/Consts/client_not_found.dart';
import 'package:Decon/Models/Consts/database_calls.dart';
import 'package:Decon/Models/Models.dart';
import 'package:provider/provider.dart';

class AllPeopleVM{
  static AllPeopleVM instance = AllPeopleVM._();
  AllPeopleVM._();
  DatabaseCallServices _databaseCallServices = DatabaseCallServices();
  UserDetailModel managerDetailModel, adminDetailModel;
  List<UserDetailModel> listOfMangerTeam;
  List<UserDetailModel> listOfAdminTeam;
  
  init(context){
    managerDetailModel = null;
    adminDetailModel = null;
    listOfAdminTeam = null; 
    listOfMangerTeam = null;
    Provider.of<AfterManagerChangeProvider>(context, listen:  false).reinitialize();
    Provider.of<AfterAdminChangeProvider>(context, listen:  false).reinitialize();
      
    
  }
  

  Future<dynamic> getManagerDetail(String manageruid) async{
   try{
    managerDetailModel =  await _databaseCallServices.getManagerCredentails(manageruid);
    return managerDetailModel ?? (managerDetailModel = UserDetailModel(key: null, name: "null"));
     }
   catch(e){
     print(e);
   }
  }

  getManagerDetailDummy(){
   managerDetailModel =  UserDetailModel(clientsVisible: ",C0", post: "Manager", phoneNo: "+919245789001", name: "Ajay Patel", delegate: "Manager", key: "DummyManager");
   return managerDetailModel;
  }

  Future<dynamic> getAdminDetail(String adminuid) async{
   try{
    adminDetailModel =  await _databaseCallServices.getAdminCredentails(adminuid);
    return adminDetailModel ?? (adminDetailModel = UserDetailModel(key: null, name: "null"));
    
    }
   catch(e){
     print(e);
   }
  }

  getAdminDetailDummy(){
    adminDetailModel =  UserDetailModel(clientsVisible: ",C0", post: "Admin", phoneNo: "+917893421010", name: "Nikunj Shah", delegate: "Admin", key: "DummyAdmin");
   return adminDetailModel;
  }

  Future<dynamic> getManagerTeamDetailList(String manageruid) async{
   try{
    listOfMangerTeam =  await _databaseCallServices.getManagerTeamCredentailsList(manageruid);
    return listOfMangerTeam;
   }
   catch(e){
     print(e);
   }
  }

  Future<dynamic> getAdminTeamDetailList(String adminuid) async{
   try{
    listOfAdminTeam =  await _databaseCallServices.getAdminTeamCredentailsList(adminuid);
    return listOfAdminTeam;
   }
   catch(e){
     print(e);
   }
  }



}