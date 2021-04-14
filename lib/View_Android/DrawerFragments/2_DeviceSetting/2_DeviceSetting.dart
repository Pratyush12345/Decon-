import 'package:Decon/Controller/Providers/devie_setting_provider.dart';
import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Controller/ViewModels/device_setting_viewmodel.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/View_Android/DrawerFragments/2_DeviceSetting/Updatelocation.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Services/Auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const gc = Colors.black;
const tc = Color(0xff263238);

class DeviceSettings extends StatefulWidget {
  String cityCode;
  DeviceSettings({Key key, this.cityCode}) : super(key: key);

  @override
  _DeviceSettings createState() => _DeviceSettings();
}

class _DeviceSettings extends State<DeviceSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Consumer<ChangeDeviceSeting>(
        builder: (context, _model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.b * 5.09,
                    vertical: SizeConfig.v * 2.85),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.b * 5.09,
                    vertical: SizeConfig.v * 2.85),
                decoration: BoxDecoration(
                  color: Color(0xff263238),
                  borderRadius: BorderRadius.circular(SizeConfig.b * 2.6),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: SizeConfig.v * 3),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text("Manhole's Depth",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.b * 4.1)),
                        ),
                        SizedBox(width: SizeConfig.b * 5),
                        Expanded(
                          flex: 2,
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 1, 0, 0, 0),
                              width: SizeConfig.b * 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEE0E0),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.b * 1.1)),
                              child: TextField(
                                controller:
                                    DeviceSettingVM.instance.maholesdepth,
                                style: TextStyle(fontSize: SizeConfig.b * 3.2),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Maholes depth',
                                  hintStyle:
                                      TextStyle(fontSize: SizeConfig.b * 3.2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 5),
                            Text("meters",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 4.1)),
                          ]),
                        ),
                      ]),
                      SizedBox(height: SizeConfig.v * 3),
                      Divider(
                        color: Color(0xff9BA1A3),
                        thickness: 2,
                      ),
                      SizedBox(height: SizeConfig.v * 1.5),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text("Critical Level Above",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.b * 4.1)),
                        ),
                        SizedBox(width: SizeConfig.b * 5),
                        Expanded(
                          flex: 2,
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 1, 0, 0, 0),
                              width: SizeConfig.b * 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEE0E0),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.b * 1.1)),
                              child: TextField(
                                controller:
                                    DeviceSettingVM.instance.crticallevelabove,
                                style: TextStyle(fontSize: SizeConfig.b * 3.2),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Critical level',
                                  hintStyle:
                                      TextStyle(fontSize: SizeConfig.b * 3.2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 5),
                            Text("meters",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 4.1)),
                          ]),
                        ),
                      ]),
                      SizedBox(height: SizeConfig.v * 1),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text("Informative Level Above",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.b * 4.1)),
                        ),
                        SizedBox(width: SizeConfig.b * 5),
                        Expanded(
                          flex: 2,
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 1, 0, 0, 0),
                              width: SizeConfig.b * 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEE0E0),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.b * 1.1)),
                              child: TextField(
                                controller: DeviceSettingVM
                                    .instance.informativelevelabove,
                                style: TextStyle(fontSize: SizeConfig.b * 3.2),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Informative level',
                                  hintStyle:
                                      TextStyle(fontSize: SizeConfig.b * 3.2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 5),
                            Text("meters",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 4.1)),
                          ]),
                        ),
                      ]),
                      SizedBox(height: SizeConfig.v * 1),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text("Normal Level",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.b * 4.1)),
                        ),
                        SizedBox(width: SizeConfig.b * 5),
                        Expanded(
                          flex: 2,
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 1, 0, 0, 0),
                              width: SizeConfig.b * 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEE0E0),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.b * 1.1)),
                              child: TextField(
                                controller:
                                    DeviceSettingVM.instance.normallevelabove,
                                style: TextStyle(fontSize: SizeConfig.b * 3.2),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Normal Level',
                                  hintStyle:
                                      TextStyle(fontSize: SizeConfig.b * 3.2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 5),
                            Text("meters",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 4.1)),
                          ]),
                        ),
                      ]),
                      SizedBox(height: SizeConfig.v * 1),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text("Ground Level",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.b * 4.1)),
                        ),
                        SizedBox(width: SizeConfig.b * 5),
                        Expanded(
                          flex: 2,
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 1, 0, 0, 0),
                              width: SizeConfig.b * 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEE0E0),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.b * 1.1)),
                              child: TextField(
                                controller:
                                    DeviceSettingVM.instance.groundlevelbelow,
                                style: TextStyle(fontSize: SizeConfig.b * 3.2),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Ground Level',
                                  hintStyle:
                                      TextStyle(fontSize: SizeConfig.b * 3.2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 5),
                            Text("meters",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 4.1)),
                          ]),
                        ),
                      ]),
                      SizedBox(height: SizeConfig.v * 1.5),
                      Divider(
                        color: Color(0xff9BA1A3),
                        thickness: 2,
                      ),
                      SizedBox(height: SizeConfig.v * 1.5),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text("Temperature Threshold Value",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.b * 4.1)),
                        ),
                        SizedBox(width: SizeConfig.b * 5),
                        Expanded(
                          flex: 2,
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 1, 0, 0, 0),
                              width: SizeConfig.b * 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEE0E0),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.b * 1.1)),
                              child: TextField(
                                controller:
                                    DeviceSettingVM.instance.tempthresholdvalue,
                                style: TextStyle(fontSize: SizeConfig.b * 3.2),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Temperature Threshold Value',
                                  hintStyle:
                                      TextStyle(fontSize: SizeConfig.b * 3.2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 5),
                            Text("\u2103",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 4.1)),
                          ]),
                        ),
                      ]),
                      SizedBox(height: SizeConfig.v * 1.5),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text("Battery Threshold Value",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.b * 4.1)),
                        ),
                        SizedBox(width: SizeConfig.b * 5),
                        Expanded(
                          flex: 2,
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 1, 0, 0, 0),
                              width: SizeConfig.b * 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEE0E0),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.b * 1.1)),
                              child: TextField(
                                controller: DeviceSettingVM
                                    .instance.batterythresholdvalue,
                                style: TextStyle(fontSize: SizeConfig.b * 3.2),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Battery Threshold value',
                                  hintStyle:
                                      TextStyle(fontSize: SizeConfig.b * 3.2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 5),
                            Text(" %",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 4.1)),
                          ]),
                        ),
                      ]),
                      SizedBox(height: SizeConfig.v * 3),
                      SizedBox(
                        width: SizeConfig.screenWidth * 100 / 360,
                        child: MaterialButton(
                          onPressed: () {
                            DeviceSettingVM.instance.onAddPressed();
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: Color(0xff00A3FF),
                          child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.b * 3.56,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: SizeConfig.v * 3),
              SizedBox(
                width: SizeConfig.screenWidth * 180 / 360,
                height: SizeConfig.screenHeight * 35 / 640,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Updatelocation()));
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  color: Color(0xff00A3FF),
                  child: Text(
                    'Update Device Location',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.b * 3.56,
                        fontWeight: FontWeight.w400),
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
