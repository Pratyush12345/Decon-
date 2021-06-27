import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/View_Android/Dialogs/LocationDialog.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

 
class Updatelocation extends StatefulWidget {
  final BuildContext menuScreenContext;
  Updatelocation({Key key, this.menuScreenContext,})
      : super(key: key);

  @override
  _Updatelocation createState() => _Updatelocation();
}


class _Updatelocation extends State<Updatelocation> {
  List<DeviceData> _listDeviceData = [];
  bool isDeviceSearched = false;
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future showLocationDialog(BuildContext context, DeviceData device) {
    return showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return LocationDialog(
            deviceId: device.id,
            initalAddress: device.address,
            initialLatitude: device.latitude,
            initialLongitude: device.longitude,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      appBar: AppBar(elevation: 10,
        titleSpacing: -3,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: blc, size: b * 16),
        ),
        iconTheme: IconThemeData(color: blc),
        title: Text(
          "Update Location",
          style: txtS(Colors.black, 16, FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: b * 22),
        child: Consumer<ChangeDeviceData>(
          builder: (context, changeList, child){
            if(!isDeviceSearched)
            _listDeviceData = List.from(changeList.allDeviceData);
            
            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh(27),
            Container(
                alignment: Alignment.center,
                width: b * 340,
                decoration: BoxDecoration(
                  border: Border.all(color: dc, width: 0.5),
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(b * 60),
                ),
                child: TextField(
                  onChanged: (val){
                    if(val.isNotEmpty){
                     _listDeviceData = changeList.allDeviceData.where((element) => element.id.toLowerCase().contains(val.toLowerCase()) || element.address.toLowerCase().contains(val.toLowerCase()) ).toList();
                     isDeviceSearched = true;
                    }else{
                      isDeviceSearched = false;
                     _listDeviceData = changeList.allDeviceData;
                    }
                    setState(() {});
                  },
                  style: TextStyle(fontSize: b * 14, color: dc),
                  decoration: InputDecoration(
                    prefixIcon: InkWell(
                      child: Icon(Icons.search, color: Colors.black),
                      onTap: null,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 40, maxHeight: 24),
                    hintText: 'Search by DeviceID/ location',
                    hintStyle: TextStyle(
                      fontSize: b * 14,
                      color: Color(0xff858585),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: h * 12, horizontal: b * 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
              sh(15),
            
              SizedBox(height: SizeConfig.v * 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _listDeviceData.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return InkWell(
                      onTap: () {
                        
                      showLocationDialog(context,_listDeviceData[index]);
                                        
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: h * 11),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 11.31,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(b * 12),
                        ),
                        padding:
                            EdgeInsets.fromLTRB(b * 12, h * 12, b * 9, h * 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${_listDeviceData[index].id.split("_")[2].replaceAll("D", "Device ")}",
                                      style: TextStyle(
                                        fontSize: b * 18,
                                        fontWeight: FontWeight.w500,
                                        color: dc,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: dc, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(b * 2),
                                        color: Color(0xFFffffff),
                                      ),
                                      child: Text(
                                        'ID : ${_listDeviceData[index].id}',
                                        style: txtS(dc, 12, FontWeight.w400),
                                      ),
                                    ),
                                  ]),
                              sh(18),
                              Container(
                                width: b * 240,
                                child: Text(
                                  _listDeviceData[index].address,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: b * 14,
                                    color: Color(0xff5C6266),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    );
                    
                  },
                ),
              ),
            ],
          );
          }
        ),
      ),
    );
  }
}
