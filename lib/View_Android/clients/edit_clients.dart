import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Controller/ViewModels/add_client_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/Dialogs/areYouSure.dart';
import 'package:Decon/View_Android/clients/add_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shape_of_view/shape_of_view.dart';

class ClientDetails extends StatefulWidget {
  final String clientCode;
 
  ClientDetails({@required this.clientCode});
  @override
  _ClientDetailsState createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserDetailModel _userDetailModel;
  bool _isActive = true;
  
  _initializeData() async{
    AddClientVM.instance.init(); 
    await AddClientVM.instance.getClientDetail(widget.clientCode);
    _userDetailModel = await AddClientVM.instance.getManagerDetail();
    await AddClientVM.instance.getSeriesList(true, widget.clientCode);
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("clients/${widget.clientCode}/isActive").once();
    if(snapshot.value == 1)
    _isActive = true;
    else 
    _isActive = false;
    
    setState(() {});
   }
   
  @override
    void initState() {
      _initializeData();  
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: blc, size: b * 16),
        ),
        elevation: 10,
        titleSpacing: -3,
        iconTheme: IconThemeData(color: blc),
        title: Text(
          "${AddClientVM.instance.clientDetailModel.clientName??""}",
          style: txtS(Colors.black, 16, FontWeight.w500),
        ),
        actions: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: b * 20),
              height: h * 32,
              width: b * 32,
              decoration: BoxDecoration(
                color: blc,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: AddClientVM.instance.seriesList == null? AppConstant.circulerProgressIndicator():
          AddClientVM.instance.seriesList.isEmpty ? AppConstant.noDataFound():
          Container(
        child: Column(
          children: [
            SizedBox(
              height: h * 211,
              child: Stack(
                children: [
                  ShapeOfView(
                    elevation: 2,
                    height: h * 190,
                    shape: DiagonalShape(
                      position: DiagonalPosition.Bottom,
                      direction: DiagonalDirection.Left,
                      angle: DiagonalAngle.deg(angle: 18),
                    ),
                    child: Container(
                      color: Color(0xffc1ebff),
                    ),
                  ),
                  Positioned(
                    top: h * 69,
                    left: b * 20,
                    child: Row(
                      children: [
                        Container(
                          height: h * 141,
                          width: b * 141,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 16,
                                spreadRadius: 0,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                                
                                radius: SizeConfig.b * 11,
                                backgroundImage: AssetImage("assets/DECON_1.png"),
                              ),
                      
                          
                        ),
                        SizedBox(width: b * 10),
                        Container(
                          height: 50.0,
                          width: b * 200,
                          child: Text(
                            "${AddClientVM.instance.clientDetailModel.clientName??""}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: txtS(blc, 20, FontWeight.w500),
                            
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            sh(63),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: b * 26),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'images/work.svg',
                        allowDrawingOutsideViewBox: true,
                      ),
                      SizedBox(width: b * 5),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Department name",
                          style: txtS(Color(0xff626262), 16, FontWeight.w400),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${AddClientVM.instance.clientDetailModel.departmentName??""}",
                          style: txtS(dc, 16, FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines:2,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  sh(28),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'images/location2.svg',
                        allowDrawingOutsideViewBox: true,
                      ),
                      SizedBox(width: b * 5),
                      Text(
                        "Location",
                        style: txtS(Color(0xff626262), 16, FontWeight.w400),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: b * 24, top: h * 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "City",
                              style:
                                  txtS(Color(0xff626262), 16, FontWeight.w400),
                            ),
                            Spacer(),
                            Text(
                              "${AddClientVM.instance.clientDetailModel.cityName??""}",
                              style: txtS(dc, 16, FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 5),
                        Row(
                          children: [
                            Text(
                              "District",
                              style:
                                  txtS(Color(0xff626262), 16, FontWeight.w400),
                            ),
                            Spacer(),
                            Text(
                              "${AddClientVM.instance.clientDetailModel.districtName??""}",
                              style: txtS(dc, 16, FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 5),
                        Row(
                          children: [
                            Text(
                              "State",
                              style:
                                  txtS(Color(0xff626262), 16, FontWeight.w400),
                            ),
                            Spacer(),
                            Text(
                              "${AddClientVM.instance.clientDetailModel.stateName??""}",
                              style: txtS(dc, 16, FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  sh(28),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'images/profile.svg',
                        allowDrawingOutsideViewBox: true,
                      ),
                      SizedBox(width: b * 5),
                      Text(
                        "Manager name",
                        style: txtS(Color(0xff626262), 16, FontWeight.w400),
                      ),
                      Spacer(),
                      Text(
                        _userDetailModel?.name??"",
                        style: txtS(dc, 16, FontWeight.w400),
                      ),
                    ],
                  ),
                  sh(28),
                  Row(
                    children: [
                      Icon(
                        Icons.memory,
                        color: Color(0xff8f8f8f),
                      ),
                      SizedBox(width: b * 5),
                      Text(
                        "Decon Series",
                        style: txtS(Color(0xff626262), 16, FontWeight.w400),
                      ),
                      Spacer(),
                      Text(
                        "${AddClientVM.instance.clientDetailModel.selectedSeries?.replaceFirst(",", "")??""}",
                        style: txtS(dc, 16, FontWeight.w400),
                      ),
                    ],
                  ),
                  sh(80),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddClient(clientCode: widget.clientCode ,isedit: true, userDetailModel: _userDetailModel,)))
                           .then((value){
                             if(value == "Updated"){
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ClientDetails(clientCode: widget.clientCode,)));
                             }
                           });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: h * 35,
                          width: b * 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: blc, width: b * 1),
                          ),
                          child: SvgPicture.asset(
                            'images/edit.svg',
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                      SizedBox(width: b * 12),
                      InkWell(
                        onTap: () {
                        
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AreYouSure(msg: "This will ${_isActive? "deactivate": "activate"} client",)  ;
                                },
                                animationType: DialogTransitionType.scaleRotate,
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 400),
                              ).then((value){
                                if(value == "YES"){
                                  _isActive = !_isActive;
                                 if(!_isActive)
                                 AddClientVM.instance.onDeactivatePressed(widget.clientCode);
                                 else{
                                  print(widget.clientCode);
                                AddClientVM.instance.onActivatePressed(widget.clientCode);
                                  
                                }
                                }
                                
                                setState(() {});
                              }
                              );
                            

                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: h * 35,
                          padding: EdgeInsets.symmetric(horizontal: b * 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(b * 20),
                            border: Border.all(
                                color: Color(0xffff000f), width: b * 1),
                          ),
                          child: Text(
                            _isActive ?"Deactivate Client" : "Activate Client",
                            style: txtS(Color(0xffff000f), 12, FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
