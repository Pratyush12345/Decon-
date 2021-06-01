import 'dart:async';

import 'package:Decon/Controller/Providers/devie_setting_provider.dart';
import 'package:Decon/Controller/ViewModels/Services/Auth.dart';
import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/DrawerFragments/Home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageVM {
  static HomePageVM instance = HomePageVM._();
  HomePageVM._();
  bool isfromDrawer = true;
  Widget selectedDrawerWidget = Home();
  int selectedDrawerIndex = 0;
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey<ScaffoldState>();

  String _sheetURL;
  BuildContext context;
  Map _clientsMap;
  List<String> citieslist = [];
  Query _query;
  StreamSubscription<Event> _onDataAddedSubscription;
  StreamSubscription<Event> _onDataChangedSubscription;
  List<DeviceData> _allDeviceData = [];
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  //String _ccode = Auth.instance.cityCode;
  
  
  onDeviceAdded(Event event) {
    if (event.snapshot.value["address"] != null) {
    
      Provider.of<ChangeCity>(context, listen: false).changecity("onDeviceAdded", newDeviceData: DeviceData.fromSnapshot(event.snapshot));
    }
  }

  onDeviceChanged(Event event) {
    try {
      if (event.snapshot.value["address"] != null) {
        int index =_allDeviceData.indexWhere((element) => element.id.split("_")[2] == event.snapshot.key);
        Provider.of<ChangeCity>(context, listen: false).changecity("onDeviceChanged",index: index, newDeviceData: DeviceData.fromSnapshot(event.snapshot));
      }
    } catch (e) {
        Provider.of<ChangeCity>(context, listen: false).changecity("onDeviceChanged", newDeviceData: DeviceData.fromSnapshot(event.snapshot));
     }
  }

  _loadDeviceSettings(String ccode) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child("cities/$ccode/DeviceSettings")
        .once();
    DeviceSettingModel deviceSettingModel =
        DeviceSettingModel.fromSnapshot(snapshot);
    Auth.instance.manholedepth = double.parse(deviceSettingModel.manholedepth);
    Auth.instance.criticalLevelAbove =
        double.parse(deviceSettingModel.criticallevelabove);
    Auth.instance.informativelevelabove =
        double.parse(deviceSettingModel.informativelevelabove);
    Auth.instance.normalLevelabove =
        double.parse(deviceSettingModel.nomrallevelabove);
    Auth.instance.groundlevelbelow =
        double.parse(deviceSettingModel.groundlevelbelow);
    Auth.instance.tempThresholdValue =
        double.parse(deviceSettingModel.tempthresholdvalue);
    Auth.instance.batteryThresholdvalue =
        double.parse(deviceSettingModel.batterythresholdvalue);
    Provider.of<ChangeDeviceSeting>(context, listen:  false).changeDeviceSetting();    
  }

  _getsheetURL(String cityCode) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child("cities/$cityCode/sheetURL")
        .once();
    _sheetURL = snapshot.value.toString();
  }


  _getClientsList() async { 
    DataSnapshot citiesSnapshot =
        await FirebaseDatabase.instance.reference().child("clientsList").once();
    _clientsMap = citiesSnapshot.value??{};
    Provider.of<ChangeWhenGetClientsList>(context, listen: false).changeWhenGetClientsList(_clientsMap);
  }

  // _setQuery(String cityCode) async {
  //   if (Auth.instance.post == "Manager") {
  //     _query =
  //         _database.reference().child("cities/$cityCode/Series/S1/Devices");
  //     await _loadDeviceSettings(cityCode);
  //     _getsheetURL(cityCode);
  //   } else {
  //     _query =
  //         _database.reference().child("cities/$cityCode/Series/S1/Devices");
  //     _getsheetURL(cityCode);
  //   }

  //   _onDataAddedSubscription = _query.onChildAdded.listen(onDeviceAdded);
  //   _onDataChangedSubscription = _query.onChildChanged.listen(onDeviceChanged);
  // }
  void callSetQuery(){
   //_setQuery(_ccode);
  }
  void initialize(BuildContext context){
    this.context = context;
    _getClientsList();
    // if (Auth.instance.post == "Manager") {
    //   _getClientsList();
    //  // _setQuery("C0");
    // } else {
    //   _getClientsList();
    //   //_setQuery(Auth.instance.cityCode ?? "C0");
    // }
  }

  void dispose(){
    _onDataChangedSubscription.cancel();
    _onDataAddedSubscription.cancel();  
  }

  Map get getCitiesMap => _clientsMap;

  //String get getCityCode => _ccode;
  String get getCityCode => "C0";

  String get getSheetURL => _sheetURL; 
  
  set setCityCode(String cityCode){
    //_ccode = cityCode;
  } 
  

}