import 'package:Decon/Controller/Providers/devie_setting_provider.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Consts/database_calls.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceSettingS0VM {
  static DeviceSettingS0VM instance = DeviceSettingS0VM._();
  DeviceSettingS0VM._();
  DatabaseCallServices _databaseCallServices = DatabaseCallServices();
  TextEditingController maholesdepth = TextEditingController();
  TextEditingController batterythresholdvalue = TextEditingController();
  
  init(context){
   maholesdepth = TextEditingController();
   batterythresholdvalue = TextEditingController(); 
   Provider.of<ChangeDeviceSeting>(context, listen:  false).changeDeviceSetting("S0");
  }
  loadFromModel() {
    S0DeviceSettingModel _s0DeviceSettingModel = (GlobalVar.seriesMap["S0"].model) as S0DeviceSettingModel;
    maholesdepth.text = _s0DeviceSettingModel.manholedepth.toString();
    batterythresholdvalue.text = _s0DeviceSettingModel.batterythresholdvalue.toString();
  }

  onAddPressed(context) async { 
      try {
        S0DeviceSettingModel _model = S0DeviceSettingModel(
            batterythresholdvalue: int.parse(batterythresholdvalue.text.toString()),
            manholedepth: double.parse(maholesdepth.text.toString())
          );
        String res6 = await _databaseCallServices.setDeviceSetting(
          HomePageVM.instance.getClientCode, 
          "S0",
          _model.toJson() 
        );
        print(res6);
        if(res6 == "Done Successfully"){
        GlobalVar.seriesMap["S0"].model = _model; 
        AppConstant.showSuccessToast(context, res6);
        }
        else{
        AppConstant.showSuccessToast(context, "Error Occured");
          
        }
      
      } catch (e) {
        print(e);
      }
    }
  
}
