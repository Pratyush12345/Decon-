import 'dart:async';
import 'package:Decon/Controller/Services/GlobalVariable.dart';
import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/View_Android/MainPage/Layout/BottomLayout.dart';
import 'package:Decon/Models/AddressCaluclator.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home();
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  TextEditingController deviceNameController = TextEditingController();
  String futureAddress = "";
  // Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> _controller = Completer();

  LatLng _latLng;
  double _value;

  @override
  void initState() {
    _latLng = new LatLng(26.123456, 72.234567);
    _value = 8.0;
    super.initState();
  }

  _animateMap(double lat, double lon) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lon), zoom: 8.0)));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Consumer<ChangeCity>(
        builder: (context, changeList, child) {
          if (VariableGlobal.iscitychanged &&
              changeList.allDeviceData.length != 0) {
            _animateMap(changeList.allDeviceData[0].latitude,
                changeList.allDeviceData[0].longitude);
          }
          return Stack(
            children: <Widget>[
              googlemap(context, changeList.allDeviceData),
              searchBar(changeList.allDeviceData),
              showBottomLayout(changeList.allDeviceData)
            ],
          );
        },
      ),
    );
  }

  Widget searchBar(List<DeviceData> allDeviceData) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.v * 3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              alignment: Alignment.center,
              height: SizeConfig.v * 5.5,
              width: SizeConfig.b * 89.1,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 1),
                        blurRadius: 5.0),
                  ],
                  borderRadius: BorderRadius.circular(SizeConfig.b * 7.64)),
              child: TextField(
                controller: deviceNameController,
                onSubmitted: (val) async {
                  VariableGlobal.iscitychanged = false;
                  _searching(val, allDeviceData);
                },
                style: TextStyle(fontSize: SizeConfig.b * 4.3),
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: SizeConfig.screenHeight * 20 / 640,
                  ),
                  contentPadding:
                      EdgeInsets.only(top: SizeConfig.screenHeight * 9 / 640),
                  hintText: 'Search by Device ID / location',
                  hintStyle: TextStyle(
                      fontSize: SizeConfig.b * 4, color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ]),
          SizedBox(height: SizeConfig.v * 1.5),
          Spacer()
        ]);
  }

  Widget googlemap(BuildContext context, List<DeviceData> allDeviceData) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: _latLng, zoom: _value),
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController googleMapControler) {
          _controller.complete(googleMapControler);
        },
        markers: addMarker(allDeviceData),
      ),
    );
  }

  Set<Marker> addMarker(List<DeviceData> _allDeviceData) {
    print("Length is ######: ${_allDeviceData.length}");
    Set<Marker> _setOfMarker = new Set();
    if (_allDeviceData.length != 0) {
      for (var i = 0; i < _allDeviceData.length; i++) {
        _setOfMarker.add(addIndividualMarker(_allDeviceData[i]));
      }
      return _setOfMarker;
    }
    return null;
  }

  Marker addIndividualMarker(DeviceData _allDeviceData) {
    //print("Device key is ${_allDeviceData.key}");
    //print("Longitude::::${_allDeviceData.longitude}");
    int level = _allDeviceData.wlevel;

    if (level == 0) {
      return Marker(
        markerId: MarkerId(_allDeviceData.id.split("_")[2]),
        onTap: () {
          _showBottomSheet(
              level, _allDeviceData.latitude, _allDeviceData.longitude);
        },
        position: LatLng(_allDeviceData.latitude, _allDeviceData.longitude),
        infoWindow: InfoWindow(
            title: "${_allDeviceData.id.split("_")[2]}",
            snippet: "Ground Level"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      );
    } else if (level == 1) {
      return Marker(
        markerId: MarkerId(_allDeviceData.id.split("_")[2]),
        onTap: () {
          _showBottomSheet(
              level, _allDeviceData.latitude, _allDeviceData.longitude);
        },
        position: LatLng(_allDeviceData.latitude, _allDeviceData.longitude),
        infoWindow: InfoWindow(
            title: "${_allDeviceData.id.split("_")[2]}",
            snippet: "Normal Level"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    } else if (level == 2) {
      return Marker(
        markerId: MarkerId(_allDeviceData.id.split("_")[2]),
        onTap: () {
          _showBottomSheet(
              level, _allDeviceData.latitude, _allDeviceData.longitude);
        },
        position: LatLng(_allDeviceData.latitude, _allDeviceData.longitude),
        infoWindow: InfoWindow(
            title: "${_allDeviceData.id.split("_")[2]}",
            snippet: "Informative Level"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      );
    } else {
      return Marker(
        markerId: MarkerId(_allDeviceData.id.split("_")[2]),
        onTap: () {
          _showBottomSheet(
              level, _allDeviceData.latitude, _allDeviceData.longitude);
        },
        position: LatLng(_allDeviceData.latitude, _allDeviceData.longitude),
        infoWindow: InfoWindow(
            title: "${_allDeviceData.id.split("_")[2]}",
            snippet: "Critical Level"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    }
  }

  _searching(String val, List<DeviceData> allDeviceData) async {
    print(val);
    DeviceData specificDevice;
    if (val != "") {
      var Key = allDeviceData.firstWhere((entry) {
        if (entry.id.split("_")[2].contains(val.trim()) ||
            entry.address.contains(val.trim()))
          return true;
        else
          return false;
      });
      specificDevice = allDeviceData[allDeviceData.indexOf(Key)];
      _value = 20.0;
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(specificDevice.latitude, specificDevice.longitude),
          zoom: _value)));
    }
  }

  _showBottomSheet(int level, double latitude, double longitude) {
    Color _color;
    if (level == 0)
      _color = Colors.purple;
    else if (level == 1)
      _color = Colors.green;
    else if (level == 2)
      _color = Colors.yellow;
    else
      _color = Colors.red;

    Future<String> address =
        AddressCalculator(latitude, longitude).getLocation();

    address.then(
      (value) {
        setState(() {
          futureAddress = value;
          print(futureAddress);
        });

        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * (0.3),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: _color,
                  ),
                  title: Text(
                    "Address",
                    style: TextStyle(fontSize: 20.0, color: _color),
                  ),
                ),
                ListTile(
                  title: Text(
                    futureAddress,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showBottomLayout(List<DeviceData> allDeviceData) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 8.0),
          height: MediaQuery.of(context).size.height * (0.29),
          child: BottomLayout(
            allDeviceData: allDeviceData,
          )),
    );
  }
}
