import 'package:Decon/Models/Models.dart';
import 'package:flutter/cupertino.dart';

class ChangeDeviceData extends ChangeNotifier{
  
  List<DeviceData> allDeviceData = [];
  
  void _sortList(){
    allDeviceData.sort((a, b) =>
          int.parse(a.id.split("_")[2].substring(1, a.id.split("_")[2].length))
              .compareTo(int.parse(b.id.split("_")[2].substring(1, b.id.split("_")[2].length))));
  }

  void reinitialize(){
    allDeviceData = [];
    notifyListeners();
  }

  void changeDeviceData(String methodName, { DeviceData newDeviceData } ){
    
    if(methodName == "onDeviceAdded" && allDeviceData!=null){
      allDeviceData.add(newDeviceData);
      _sortList();
    }
    else if(methodName == "onDeviceChanged" && allDeviceData!=null ){
      int index = allDeviceData.indexWhere((element) => element.id == newDeviceData.id); 
      if(index!=-1){
        allDeviceData[index] = newDeviceData;
      }else{
        allDeviceData.add(newDeviceData);
        _sortList();
      }
    }
    notifyListeners();
  }

  
}

class ChangeClient extends ChangeNotifier {
  ClientDetailModel clientDetailModel;

  reinitialize(){
    clientDetailModel = ClientDetailModel();
    notifyListeners();
  }

  void changeClientDetail(ClientDetailModel _clientDetailModel){
    clientDetailModel = _clientDetailModel;
    notifyListeners();
  }

}

class ChangeSeries extends ChangeNotifier {
  String selectedSeries;
  List<String> seriesList;

  reinitialize(){
    selectedSeries = "";
    seriesList = [];
  }

  void changeDeconSeries(String _selectedSeries, List<String> _seriesList){
    selectedSeries = _selectedSeries;
    seriesList = _seriesList;
    notifyListeners();
  }

}

class ChangeWhenGetClientsList extends ChangeNotifier{
   
   List<ClientListModel> clientsList;
   void changeWhenGetClientsList(List<ClientListModel> _clientsList){
           
      clientsList = _clientsList;

     notifyListeners();
   }
   
}

class ChangeDrawerItems extends ChangeNotifier {
  void changeDrawerItem(){
    notifyListeners();
  }
}


class ChangeOnActive extends ChangeNotifier{
  void changeOnActive(){
    notifyListeners();
  }
}