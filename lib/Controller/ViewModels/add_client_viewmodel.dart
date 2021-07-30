import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Consts/database_calls.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/Dialogs/please_wait_dialog.dart';
import 'package:Decon/View_Android/clients/add_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class AddClientVM {
  static AddClientVM instance = AddClientVM._();
  AddClientVM._();
  DatabaseCallServices _databaseCallServices = DatabaseCallServices();
  String seriesValue;
  List<SeriesControllerModel> seriesList;
  String selectedSeries;
  ClientDetailModel clientDetailModel;
  List<ClientListModel> _dupClientList;
  bool isClientSearched = false;
 
  init(){
    selectedSeries = ""; 
    seriesList = null;
    clientDetailModel = ClientDetailModel();
  }

  getSeriesList(bool isEdit, String clientCode) async{
     try{
      String series =  await _databaseCallServices.getSeriesList();
      if(series != null){
        List list =  series.split(",");
        seriesList = [];
        for(int i =0; i<list.length ; i++){
          if(isEdit){
          String sheetUrl = (await FirebaseDatabase.instance.reference().child("clients/$clientCode/series/${list[i]}/DeviceSetting/sheetURL").once()).value; 
           seriesList.add(SeriesControllerModel(seriesName: list[i], sheetController: TextEditingController(text: sheetUrl??"")));
          }else{
           seriesList.add(SeriesControllerModel(seriesName: list[i], sheetController: TextEditingController(text: "")));
          }
        }
      }
      else
      seriesList = [];
     }
     catch(e){
       print(e);
     }
  }
  
  getClientDetail(String clientCode) async{
   try{
    clientDetailModel =  await _databaseCallServices.getClientDetail(clientCode);
    selectedSeries = clientDetailModel.selectedSeries;
   }
   catch(e){
     print(e);
   }
  }

  getManagerDetail() async{
    try{
     return await _databaseCallServices.getManagerCredentails(clientDetailModel.selectedManager.trim());
    }catch(e){
      print(e);
    }
  }
  
  Future showPleaseWaitDialog(BuildContext context) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,  
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return PleaseWait();
        });
  }
  onPressedDone(BuildContext context,UserDetailModel previousManagerModel, String previousClientsVisible, bool isedit, ClientDetailModel clientDetailModel, ClientListModel clientListModel  ) async{
     showPleaseWaitDialog(context);
     String res1 = await _databaseCallServices.setClientList(clientListModel);
     String res2 =  await _databaseCallServices.setClientDetail(clientListModel.clientCode, clientDetailModel );
     String res3 = await _databaseCallServices.activateClient(clientListModel.clientCode);
     if(!previousClientsVisible.contains(clientListModel.clientCode)){
     String clientsVisible =  previousClientsVisible + "," + clientListModel.clientCode;
     String res4 = await _databaseCallServices.setManagerClientVisible(clientDetailModel.selectedManager, clientsVisible);
     print(res4);
     }
     if(isedit && previousManagerModel!=null && clientDetailModel.selectedManager != previousManagerModel?.key  ){
      previousManagerModel.clientsVisible = previousManagerModel?.clientsVisible?.replaceAll(",${clientListModel.clientCode}", "");
      String res5 = await _databaseCallServices.setManagerClientVisible(previousManagerModel?.key, previousManagerModel.clientsVisible );   
      print(res5);
     }
     await _setDeviceSetting( clientListModel.clientCode, clientDetailModel.selectedSeries.replaceFirst(",","" ).split(","));
     print(res1);
     print(res2);
     print(res3);
     HomePageVM.instance.onFirstLoad();
     
     Navigator.of(context).pop();

     if(res3 == "Done Successfully"){
     AppConstant.showSuccessToast(context, res3);
     Navigator.of(context).pop("Updated");
     }
     else
     AppConstant.showFailToast(context, "Error Occured");

     
  }

  _setDeviceSetting(String clientCode, List<String> _selectedSeries) async{
     for(int i = 0; i < _selectedSeries.length; i++ ){
       try{
       String sheetUrl = seriesList.firstWhere((element) => element.seriesName.trim() == _selectedSeries[i].trim()).sheetController.text.trim();
       String res6 = await _databaseCallServices.setDeviceSettingDefault(clientCode,_selectedSeries[i], sheetUrl );
       }
       catch(e){
         print(e);
       }
      
     }
  }


  onDeactivatePressed(String clientCode) async{
    try{
      await _databaseCallServices.deactivateClient(clientCode);
    }
    catch(e){
      print(e);
    }
  }
  onActivatePressed(String clientCode) async{
    try{
      await _databaseCallServices.activateClient(clientCode);
    }
    catch(e){
      print(e);
    }
  }

  List<ClientListModel> onSearchClient(String val ){
     List<ClientListModel> list = [];
     if(val.isNotEmpty){
       List<ClientListModel> _searchedList = [];
       _searchedList = _dupClientList.where((element) => element.clientCode.toLowerCase().contains(val)|| element.clientName.toLowerCase().contains(val)).toList();
       list.addAll(_searchedList);
       isClientSearched = true;
       return list;
       }
      else{
        isClientSearched = false;
        list  = List.from(_dupClientList);
        return list;
      }
  }
  
 set setClientList(List<ClientListModel> _list){
    _dupClientList = _list;
  } 
  

}