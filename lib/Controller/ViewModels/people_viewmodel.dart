import 'package:Decon/Models/Consts/database_calls.dart';
import 'package:Decon/Models/Models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeopleVM {
   static PeopleVM instance = PeopleVM._();
  PeopleVM._();
  DatabaseCallServices _databaseCallServices = DatabaseCallServices();
  bool isManagerSearched, isAdminSearched;
  bool isManagerTeamSearched, isAdminTeamSearched;
  List<UserDetailModel> _dupListManager ;
  List<UserDetailModel> _dupListAdmin;
  List<UserDetailModel> _dupListManagerTeam ;
  List<UserDetailModel> _dupListAdminTeam;
  
  init(){
  isManagerSearched = false;
  isAdminSearched = false;
  isManagerTeamSearched = false;
  isAdminTeamSearched = false;
    
  }
  Future<dynamic> getClientDetail(String clientCode) async{
   try{
    ClientDetailModel clientDetailModel =  await _databaseCallServices.getClientDetail(clientCode);
    return clientDetailModel;
   }
   catch(e){
     print(e);
   }
  }

  List<UserDetailModel> onSearchManager(String val ){
     List<UserDetailModel> list = [];
     if(val.isNotEmpty){
       List<UserDetailModel> _searchedList = [];
       _searchedList = _dupListManager.where((element) => element.name.contains(val) ||element.phoneNo.contains(val) ).toList();
       list.addAll(_searchedList);
       isManagerSearched = true;
       return list;
       }
      else{
        isManagerSearched = false;
        list  = List.from(_dupListManager);
        return list;
      }
  }
  
  List<UserDetailModel> onSearchAdmin(String val ){
     List<UserDetailModel> list = [];
     if(val.isNotEmpty){
       List<UserDetailModel> _searchedList = [];
       _searchedList = _dupListAdmin.where((element) => element.name.contains(val)|| element.phoneNo.contains(val)).toList();
       list.addAll(_searchedList);
       isAdminSearched = true;
       return list;
       }
      else{
        isAdminSearched = false;
        list  = List.from(_dupListAdmin);
        return list;
      }
  }

  List<UserDetailModel> onSearchManagerTeam(String val ){
     List<UserDetailModel> list = [];
     if(val.isNotEmpty){
       List<UserDetailModel> _searchedList = [];
       _searchedList = _dupListManagerTeam.where((element) => element.name.contains(val) ||element.phoneNo.contains(val) ).toList();
       list.addAll(_searchedList);
       isManagerTeamSearched = true;
       return list;
       }
      else{
        isManagerSearched = false;
        list  = List.from(_dupListManagerTeam);
        return list;
      }
  }
  
  List<UserDetailModel> onSearchAdminTeam(String val ){
     List<UserDetailModel> list = [];
     if(val.isNotEmpty){
       List<UserDetailModel> _searchedList = [];
       _searchedList = _dupListAdminTeam.where((element) => element.name.contains(val)|| element.phoneNo.contains(val)).toList();
       list.addAll(_searchedList);
       isAdminTeamSearched = true;
       return list;
       }
      else{
        isAdminTeamSearched = false;
        list  = List.from(_dupListAdminTeam);
        return list;
      }
  }
  

  set setManagerList(List<UserDetailModel> _list){
    _dupListManager = _list;
  } 
  
  set setAdminList(List<UserDetailModel> _list){
    _dupListAdmin = _list;
  }

  set setManagerTeamList(List<UserDetailModel> _list){
    _dupListManagerTeam = _list;
  } 
  
  set setAdminTeamList(List<UserDetailModel> _list){
    _dupListAdminTeam = _list;
  }
  
}