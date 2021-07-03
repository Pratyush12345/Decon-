import 'package:Decon/Models/Models.dart';
import 'package:flutter/cupertino.dart';

class PeopleProvider extends ChangeNotifier {
 Map<String, ClientDetailModel> listClientDetailModel = {};
  
 void changeClientDetail(Map<String, ClientDetailModel> _list ){
  listClientDetailModel = _list;
  notifyListeners();
 }
}

class AfterManagerChangeProvider extends ChangeNotifier {
 List<UserDetailModel> listManager = [];  
 reinitialize(){
   listManager = [];
   notifyListeners();
 }
 void afterManagerChangeProvider(List<UserDetailModel> _list ){
  listManager = _list;
  print("length of list manager ==========${listManager.length}");
  notifyListeners();
 }
}

class AfterAdminChangeProvider extends ChangeNotifier {
 List<UserDetailModel> listAdmin = [];  
 reinitialize(){
   listAdmin = [];
   notifyListeners();
 }
 void afterAdminChangeProvider(List<UserDetailModel> _list ){
  listAdmin = _list;
  notifyListeners();
 }
}