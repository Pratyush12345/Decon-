import 'package:Decon/Controller/Providers/devie_setting_provider.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/View_Android/series_S0/device_setting_viewmodel_S0.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/View_Android/DrawerFragments/Updatelocation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class DeviceSettingsS0 extends StatefulWidget {

  @override
  _DeviceSettings createState() => _DeviceSettings();
}

class _DeviceSettings extends State<DeviceSettingsS0> {
  
  @override
  void initState() {
    DeviceSettingS0VM.instance.init(context);
    super.initState();
  }
   Text textRepeat() {
    return Text(
      "Meters",
      style: TextStyle(
        color: Color(0xff9ba1a3),
        fontSize: SizeConfig.screenWidth * 14 / 375,
      ),
    );
  }

  Container containerText(TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
      width: SizeConfig.screenWidth * 44 / 375,
      height: SizeConfig.screenHeight * 44 / 812,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(SizeConfig.screenWidth * 4 / 375),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: SizeConfig.screenWidth * 16 / 375),
        decoration: InputDecoration(
          isDense: true,
          isCollapsed: true,
          hintText: '0',
          hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 16 / 375),
          border: InputBorder.none,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return SingleChildScrollView(
      child : Consumer<ChangeDeviceSeting>(
          builder: (context, _model, child){
          return Column(
          children: [
            sh(32),
          Container(
            padding: EdgeInsets.symmetric(horizontal: b * 13, vertical: h * 13),
            margin: EdgeInsets.symmetric(horizontal: b * 26),
            decoration: BoxDecoration(
              color: Color(0xfff3f3f3),
              borderRadius: BorderRadius.circular(b * 6),
            ),
            child: Row(children: [
              Text(
                "Manhole's Depth",
                style: TextStyle(
                  color: dc,
                  fontSize: b * 14,
                ),
              ),
              Spacer(),
              Row(children: [
                containerText(DeviceSettingS0VM.instance.maholesdepth),
                SizedBox(width: b * 5),
                textRepeat(),
              ]),
            ]),
          ),
          sh(23),
          Container(
            padding: EdgeInsets.symmetric(horizontal: b * 13, vertical: h * 13),
            margin: EdgeInsets.symmetric(horizontal: b * 26),
            decoration: BoxDecoration(
              color: Color(0xfff3f3f3),
              borderRadius: BorderRadius.circular(b * 6),
            ),
            child: Column(children: [
              
              sh(10),
              Row(children: [
                Text(
                  "Battery Threshold Value",
                  style: TextStyle(
                    color: dc,
                    fontSize: b * 14,
                  ),
                ),
                Spacer(),
                Row(children: [
                  containerText(DeviceSettingS0VM.instance.batterythresholdvalue),
                  SizedBox(width: b * 5),
                  Text(
                    " %",
                    style: TextStyle(
                      color: Color(0xff9ba1a3),
                      fontSize: b * 14,
                    ),
                  ),
                ]),
              ]),
            ]),
          ),
          sh(58),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: b * 25),
            child: MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: blc,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(b * 6),
              ),
              onPressed: () {
                 DeviceSettingS0VM.instance.onAddPressed(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: h * 10),
                alignment: Alignment.center,
                child: Text(
                  'Add Parameters',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: b * 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          sh(14),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: b * 25),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Updatelocation()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: h * 10),
                decoration: BoxDecoration(
                  border: Border.all(color: blc),
                  borderRadius: BorderRadius.circular(b * 6),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Update Location',
                  style: TextStyle(
                      color: blc,
                      fontSize: b * 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          ],
        );
          },
      ),
    );
  }
}
