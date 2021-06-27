import 'package:Decon/Controller/Providers/devie_setting_provider.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Consts/database_calls.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceSettingS1VM {
  static DeviceSettingS1VM instance = DeviceSettingS1VM._();
  DeviceSettingS1VM._();
  DatabaseCallServices _databaseCallServices = DatabaseCallServices();
  TextEditingController maholesdepth = TextEditingController();
  TextEditingController crticallevelabove = TextEditingController();
  TextEditingController informativelevelabove = TextEditingController();
  TextEditingController normallevelabove = TextEditingController();
  TextEditingController groundlevelbelow = TextEditingController();
  TextEditingController tempthresholdvalue = TextEditingController();
  TextEditingController batterythresholdvalue = TextEditingController();
 init(context){
   crticallevelabove = TextEditingController();
   maholesdepth = TextEditingController();
   batterythresholdvalue = TextEditingController(); 
   informativelevelabove = TextEditingController();
   normallevelabove = TextEditingController();
   groundlevelbelow = TextEditingController();
   tempthresholdvalue = TextEditingController();
   
   Provider.of<ChangeDeviceSeting>(context, listen:  false).changeDeviceSetting("S1");
  }
  loadFromModel() {
    S1DeviceSettingModel _s1DeviceSettingModel = (GlobalVar.seriesMap["S1"].model) as S1DeviceSettingModel;
    maholesdepth.text = _s1DeviceSettingModel.manholedepth.toString();
    crticallevelabove.text = _s1DeviceSettingModel.criticallevelabove.toString();
    informativelevelabove.text = _s1DeviceSettingModel.informativelevelabove.toString();
    normallevelabove.text = _s1DeviceSettingModel.nomrallevelabove.toString();
    groundlevelbelow.text = _s1DeviceSettingModel.groundlevelbelow.toString();
    tempthresholdvalue.text = _s1DeviceSettingModel.tempthresholdvalue.toString();
    batterythresholdvalue.text = _s1DeviceSettingModel.batterythresholdvalue.toString();
  }

  onAddPressed(context) async {
    
          print("updating111");
    if (double.parse(groundlevelbelow.text) <=
            double.parse(maholesdepth.text) &&
        (double.parse(normallevelabove.text) <=
            double.parse(groundlevelbelow.text)) &&
        (double.parse(informativelevelabove.text) <=
            double.parse(normallevelabove.text)) &&
        (double.parse(crticallevelabove.text) <=
            double.parse(informativelevelabove.text))) {

      try {
        
          print("updating222");
        S1DeviceSettingModel _model = S1DeviceSettingModel(
            criticallevelabove: double.parse(crticallevelabove.text.toString()),
            informativelevelabove: double.parse(informativelevelabove.text.toString()),
            nomrallevelabove: double.parse(normallevelabove.text.toString()),
            groundlevelbelow: double.parse(groundlevelbelow.text.toString()),
            tempthresholdvalue: double.parse(tempthresholdvalue.text.toString()),
            batterythresholdvalue: int.parse(batterythresholdvalue.text.toString()),
            manholedepth: double.parse(maholesdepth.text.toString())
          ); 
        String res = await _databaseCallServices.setDeviceSetting(
          HomePageVM.instance.getClientCode, 
          "S1",
          _model.toJson() 
        );
        print(res);
        if(res == "Done Successfully"){
        GlobalVar.seriesMap["S1"].model = _model; 
        AppConstant.showSuccessToast(context, res);
        }
        else{
        AppConstant.showSuccessToast(context, "Error Occured");
          
        }
      
      } catch (e) {
        print(e);
      }
    }
    else{
      AppConstant.showSuccessToast(context, "Invalid distances, Please check it");
        
    }
  }
}
