import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/View_Android/Dialogs/LocationDialog.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Updatelocation extends StatefulWidget {
  final BuildContext menuScreenContext;
  //final List<DeviceData> allDeviceList;
  Updatelocation({
    Key key,
    this.menuScreenContext,
  }) : super(key: key);

  @override
  _Updatelocation createState() => _Updatelocation();
}

const gc = Colors.black;
const tc = Color(0xff263238);

class _Updatelocation extends State<Updatelocation> {
  List<DeviceData> _filteredDeviceData = [];
  @override
  void initState() {
    super.initState();
  }

  Future showLocationDialog(BuildContext context, DeviceData device) {
    return showDialog(
        context: context,
        builder: (context) {
          return LocationDialog(
            cityid: device.id,
            initalAddress: device.address,
            initialLatitude: device.latitude,
            initialLongitude: device.longitude,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Location"),
      ),
      body: Container(
        child: Consumer<ChangeCity>(builder: (context, changeList, child) {
          _filteredDeviceData = [];
          changeList.allDeviceData.forEach((element) {
            _filteredDeviceData.add(element);
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.v * 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: SizeConfig.b * 89.06,
                    child: TextField(
                      onChanged: (value) {
                        _filteredDeviceData.clear();
                        changeList.allDeviceData.forEach((element) {
                          _filteredDeviceData.add(element);
                        });
                        setState(() {
                          _filteredDeviceData.removeWhere((element) {
                            if (!element.address
                                .toLowerCase()
                                .contains(value.trim().toLowerCase())) {
                              if (!element.id
                                  .toLowerCase()
                                  .contains(value.trim().toLowerCase()))
                                return true;
                              else
                                return false;
                            }
                            return false;
                          });
                        });
                      },
                      style: TextStyle(fontSize: SizeConfig.b * 4.3),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24.0,
                        ),
                        isDense: true,
                        hintText: 'Search by Device ID / location',
                        hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                        filled: true,
                        fillColor: Color(0xffDEE0E0),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.v * 1),
              Divider(color: Color(0xffCACACA), thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredDeviceData.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                SizeConfig.b * 5.1,
                                SizeConfig.v * 0.6,
                                SizeConfig.b * 5.1,
                                SizeConfig.v * 0.6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${_filteredDeviceData[index].id.split("_")[2].replaceAll("D", "Device ")}",
                                          style: TextStyle(
                                              fontSize: SizeConfig.b * 5.09,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        child: Container(
                                            padding: EdgeInsets.all(
                                                SizeConfig.v * 0.8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        SizeConfig.b * 2),
                                                color: Color(0xff0099FF)),
                                            child: Text(
                                                _filteredDeviceData[index].id,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        SizeConfig.b * 3.57))),
                                      ),
                                    ]),
                                SizedBox(height: SizeConfig.v * 1),
                                Container(
                                    width: SizeConfig.b * 68.71,
                                    child: Text(
                                        _filteredDeviceData[index].address,
                                        style: TextStyle(
                                            fontSize: SizeConfig.b * 3.563,
                                            color: Color(0xff5C6266)))),
                                SizedBox(height: SizeConfig.v * 1.8),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.b * 1.3),
                                      color: Color(0xff263238),
                                    ),
                                    child: SizedBox(
                                        height: SizeConfig.v * 3.9,
                                        child: RaisedButton(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: SizeConfig.b * 2),
                                            color: Color(0xff263238),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig.b * 1.3),
                                            ),
                                            //onPressed: null,
                                            onPressed: () {
                                              showLocationDialog(context,
                                                  _filteredDeviceData[index]);
                                            },
                                            child: Text('Update Location',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        SizeConfig.b * 4.072,
                                                    fontWeight:
                                                        FontWeight.w400)))))
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.v * 1),
                          Divider(color: Color(0xffCACACA), thickness: 1),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
