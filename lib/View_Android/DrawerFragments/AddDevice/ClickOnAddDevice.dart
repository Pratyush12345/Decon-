import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/AddressCaluclator.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';


class ClickOnAddDevice extends StatefulWidget {
  final bool isUpdating;
  final String deviceid;
  final List<DeviceData> list;
  ClickOnAddDevice({@required this.isUpdating, @required this.deviceid, @required this.list});
  @override
  _ClickOnAddDeviceState createState() => _ClickOnAddDeviceState();
}

class _ClickOnAddDeviceState extends State<ClickOnAddDevice> {
  final _deviceIdText = TextEditingController();
  final _latitudeText = TextEditingController();
  final _longitudeText = TextEditingController();
  final _addressController =  TextEditingController();
  double _latitude, _longitude;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Position position;
  String address;
  bool _isMannual = false, _isAddressChangedManually = false, _isChanged = false;
  
  getCurrentLocation(double latitude, double longitude) async {
    String address = await AddressCalculator(latitude, longitude).getLocation();
    setState(() {
      _longitudeText.text = longitude.toString();
      _latitudeText.text = latitude.toString();
      _addressController.text = address;
    });
  }


  void validate() async{
    if(_formKey.currentState.validate()){
      print(_latitudeText.text);
      if(_latitudeText.text!=null && _longitudeText.text!=null && _latitudeText.text!="" && _longitudeText.text!="")
     _updatedatabase(double.parse(_latitudeText.text), double.parse(_longitudeText.text));     
      else
      {
        AppConstant.showFailToast(context, "Latitude and Longitude can not be null");
      }
    }
    else{
      print("Not Validated");
    }
  }


  _updatedatabase( double _latitude, double _longitude) async {
    String clientCode = HomePageVM.instance.getClientCode;
    String seriescode = HomePageVM.instance.getSeriesCode;
    String deviceCode = _deviceIdText.text;
    int _battery;

    if(!_isAddressChangedManually)
    address = await AddressCalculator(_latitude, _longitude).getLocation();
    if (widget.isUpdating) {
      DataSnapshot _snapshot = await FirebaseDatabase.instance.reference()
          .child("clients/$clientCode/series/$seriescode/devices/${deviceCode.split("_")[2]}/battery").once();
    _battery = _snapshot.value;
    
      await FirebaseDatabase.instance
          .reference()
          .child("clients/$clientCode/series/$seriescode/devices/${deviceCode.split("_")[2]}")
          .update({
        "latitude": _latitude,
        "longitude": _longitude,
        "battery" : _battery == null?100: _battery,
        "address": address,
      });
    } else {
      Map<String, dynamic> _deviceData;
      if(seriescode == "S0"){
        _deviceData = DeviceData(
                  id: "${clientCode}_${seriescode}_${_deviceIdText.text}",
                  battery: 100,
                  latitude: _latitude,
                  longitude: _longitude,
                  status: 1,
                  wlevel: 0,
                  openManhole: 0,
                  address: address,
                  lightIntensity: 0,
                  signalStrength: 0,
                  lastUpdated: "${DateTime.now()}"
        ).toS0Json();
      }
      else if(seriescode == "S1"){
        _deviceData =  DeviceData(
                  id: "${clientCode}_${seriescode}_${_deviceIdText.text}",
                  battery: 100,
                  latitude: _latitude,
                  longitude: _longitude,
                  status: 1,
                  distance: 3.9,
                  openManhole: 0,
                  address: address,
                  temperature: 50.2,
                  lightIntensity: 0,
                  signalStrength: 0,
                  lastUpdated: "${DateTime.now()}")
              .toS1Json();
      }
      await FirebaseDatabase.instance
          .reference()
          .child("clients/$clientCode/series/$seriescode/devices/$deviceCode")
          .update(_deviceData);
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    if (widget.isUpdating) {
      _deviceIdText.text = widget.deviceid;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    
    return Dialog(
      backgroundColor: Color(0xff263238),
      insetPadding: EdgeInsets.symmetric(
      horizontal:  b * 25,
      ),
     shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(b * 9),
     ),
    
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(b * 13, h * 16, b * 13, h * 16),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(b * 9)
        ),
         child: Form(
           key: _formKey,
           child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sh(6),
                Text(
                    "Device Id",
                    style: TextStyle(
                      fontSize: b * 16,
                      color: dc,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                sh(6),
                TextFormField(
                          validator: (val){
                          if(widget.isUpdating){
                            return null;
                          }  
                          int index = widget.list.indexWhere((element) =>element.id.contains(val) );
                          
                          if(val.isEmpty)
                          return "Device Id Cannot be empty";
                          else if(index!=-1)
                          return "Device Id already added";
                          else if(val.endsWith("D") || !val.startsWith("D") )
                          return "Invalid Id";
                          else
                          return null;
                        },
                          inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter(RegExp('[D0-9]'), allow: true ),
                      ],
                          enabled: !widget.isUpdating,
                          controller: _deviceIdText,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: b * 14, color: dc),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            hintText: 'Enter Device Id',
                            hintStyle: TextStyle(
                            fontSize: b * 14,
                              color: blc.withOpacity(0.25),
                            ),
                            enabledBorder: OutlineInputBorder(

                              borderSide: BorderSide(color: blc, width: 0.7),
                              borderRadius: BorderRadius.circular(b * 5),
                            ),
                            border: OutlineInputBorder(

                              borderSide: BorderSide(color: blc, width: 0.7),
                              borderRadius: BorderRadius.circular(b * 5),
                            ),
                          ),
                        ),
                sh(11),        
                InkWell(
                  onTap: () {
                    _isMannual = !_isMannual;
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: h * 10),
                    decoration: !_isMannual? BoxDecoration(
                      border: Border.all(color: blc),
                      borderRadius: BorderRadius.circular(b * 6)):
                      BoxDecoration(
                      color: blc,
                      borderRadius: BorderRadius.circular(b * 6)),
                    alignment: Alignment.center,
                    child: Text(
                      'Manual',
                      style: !_isMannual? TextStyle(
                          color: blc,
                          fontSize: b * 16,
                          fontWeight: FontWeight.w500):
                          TextStyle(
                          color: Colors.white,
                          fontSize: b * 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                sh(11),

                if(_isMannual)
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                 sh(16),
                Text(
                  "Latitude",
                  style: TextStyle(
                    fontSize: b * 16,
                    color: dc,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                sh(6),
                Container(
                  padding: EdgeInsets.fromLTRB(b * 11, 0, 0, 0),
                  width: b * 400,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(color: blc, width: 0.7),
                    borderRadius: BorderRadius.circular(b * 5),
                  ),
                  child: TextFormField(
                    validator: (val){
                      if(val.isEmpty)
                      return "Latitude cannot be empty";
                      else
                      return null;
                    },
                    onChanged: (value) {
                          _isChanged = true;
                        },
                        
                    controller: _latitudeText,
                    style: TextStyle(fontSize: b * 14, color: blc),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter Latitude',
                      hintStyle: TextStyle(
                        fontSize: b * 14,
                        color: blc.withOpacity(0.25),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                sh(18),
                Text(
                  "Longitude",
                  style: TextStyle(
                    fontSize: b * 16,
                    color: dc,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                sh(6),
                Container(
                  padding: EdgeInsets.fromLTRB(b * 11, 0, 0, 0),
                  width: b * 400,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(color: blc, width: 0.7),
                    borderRadius: BorderRadius.circular(b * 5),
                  ),
                  child: TextFormField(
                    validator: (val){
                      if(val.isEmpty)
                      return "Latitude cannot be empty";
                      else
                      return null;
                    },
                    onChanged: (value) {
                          _isChanged = true;
                        },
                        
                    controller: _longitudeText,
                    style: TextStyle(fontSize: b * 14, color: blc),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter Longitude',
                      hintStyle: TextStyle(
                        fontSize: b * 14,
                        color: blc.withOpacity(0.25),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ],),
                sh(16),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: b * 11, vertical: h * 8.5),
                  decoration: BoxDecoration(
                    color: Color(0xfff1f1f1),
                    borderRadius: BorderRadius.circular(b * 6),
                  ),
                  child: TextFormField(
                    onChanged: (val){
                        _isAddressChangedManually = true;
                        address = val;
                    },
                    validator: (val){
                      if(val.isEmpty)
                      return "Address cannot be empty";
                      else
                      return null;
                    },
                    maxLines: 3,
                    controller: _addressController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      fillColor: Color(0xfff1f1f1),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xfff1f1f1),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xfff1f1f1),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border: InputBorder.none,
                    ),
                    style: txtS(Colors.black, b * 16, FontWeight.w400),
                  ),
                  ),
                sh(5), 
                  MaterialButton(
                  color: Color(0xff00A3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(b * 6),
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                      _isAddressChangedManually = false;
                      if (!_isChanged) {
                        position = await Geolocator.getCurrentPosition();
                        _latitude = position.latitude;
                        _longitude = position.longitude;
                        await getCurrentLocation(
                            position.latitude, position.longitude);
                      } else {
                        _latitude = double.parse(_latitudeText.text.toString());
                        _longitude = double.parse(_longitudeText.text.toString());
                        
                        await getCurrentLocation(
                            double.parse(_latitudeText.text.toString()),
                            double.parse(_longitudeText.text.toString()));
                      }
                    },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      !_isChanged ? 'Get Current Location' : 'Fetch Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: b * 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                sh(22),         
                MaterialButton(
                color: Color(0xff00A3FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(b * 6),
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  validate();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: b * 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ),
              ]),
         )
        ),
      )
    );
  }
}
