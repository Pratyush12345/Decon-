import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Models/AddressCaluclator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationDialog extends StatefulWidget {
  final String deviceId;
  final String initalAddress;
  final double initialLatitude, initialLongitude;
  LocationDialog(
      {@required this.deviceId,
      @required this.initalAddress,
      @required this.initialLatitude,
      @required this.initialLongitude});
  @override
  _LocationDialog createState() => _LocationDialog();
}


class _LocationDialog extends State<LocationDialog> {
  bool _isMannual = false;
  Position position;
  bool _isChanged = false;
  TextEditingController _addressController,
      _latitudeController,
      _longitudeController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      
  getCurrentLocation(double latitude, double longitude) async {
    String address = await AddressCalculator(latitude, longitude).getLocation();
    setState(() {
      _longitudeController.text = longitude.toString();
      _latitudeController.text = latitude.toString();
      _addressController.text = address;
    });
  }
 validate() async{
   print("11111111111111");
   if(_formKey.currentState.validate()){
     print("222222222222");
         if(_latitudeController.text!="" && _longitudeController.text!=""){
          double _lat = double.parse((_latitudeController.text));
          double _lon = double.parse(_longitudeController.text);
          print("${_addressController.text}");
          await FirebaseDatabase.instance.reference().child("clients/${widget.deviceId.split("_")[0]}/series/${widget.deviceId.split("_")[1]}/devices/${widget.deviceId.split("_")[2]}")
          .update({
                  "latitude": _lat,
                  "longitude": _lon,
                  "address": _addressController.text
                  });
          Navigator.of(context).pop();
          }
          else{
               AppConstant.showFailToast(context, "Latitude and Longitude cannot be null");
          }
    }
    else{
      print("Not Validated");
    }
   

 }
  @override
  void initState() {
    _addressController = TextEditingController(
      text: widget.initalAddress,
    );
    _latitudeController = TextEditingController(
      text: widget.initialLatitude.toString(),
    );
    _longitudeController = TextEditingController(
      text: widget.initialLongitude.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: b * 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 12),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: EdgeInsets.fromLTRB(b * 13, h * 16, b * 13, h * 16),
            child: Form(
              key: _formKey,
              child: Column(children: [
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
                      'Manual Update',
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
                        
                    controller: _latitudeController,
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
                        return "Longitude cannot be empty";
                        else
                        return null;
                      }, 
                    onChanged: (value) {
                          _isChanged = true;
                        },
                        
                    controller: _longitudeController,
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
                if(!_isMannual)
                Text("OR",
                    textAlign: TextAlign.center,
                    style: txtS(Colors.black, b * 16, FontWeight.w400)),
                Text("Are You sure?\nLocation of ${widget.deviceId.split("_")[2].replaceAll("D", "Device ")} is :",
                    textAlign: TextAlign.center,
                    style: txtS(Colors.black, b * 16, FontWeight.w500)),
                sh(9),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: b * 11, vertical: h * 8.5),
                  decoration: BoxDecoration(
                    color: Color(0xfff1f1f1),
                    borderRadius: BorderRadius.circular(b * 6),
                  ),
                  child: TextFormField(
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
                      if (!_isChanged) {
                        position = await Geolocator.getCurrentPosition();
                        await getCurrentLocation(
                            position.latitude, position.longitude);
                      } else {
                        if(_latitudeController.text!="" && _longitudeController.text!=""){
                        await getCurrentLocation(
                            double.parse(_latitudeController.text.toString()),
                            double.parse(_longitudeController.text.toString()));
                        }
                        else{
                          AppConstant.showFailToast(context, "Latitude and Longitude cannot be null");
                        }
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
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      color: Color(0xff00A3FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(b * 6),
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                             if(GlobalVar.strAccessLevel != null)
                              validate();
                            },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Yes, Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: b * 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: blc,
                            fontSize: b * 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
              ]),
            ),
          ),
        ]),
      ),
    );
      }
}
