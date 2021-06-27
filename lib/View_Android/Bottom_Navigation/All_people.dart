import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/add_client_viewmodel.dart';
import 'package:Decon/Controller/ViewModels/all_people_viewmodel.dart';
import 'package:Decon/Controller/ViewModels/people_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/View_Android/Dialogs/Add_Delegates.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/profile_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllPeople extends StatefulWidget {
  final String clientCode; 
  final ClientDetailModel clientDetailModel;
  AllPeople( 
      {Key key, @required this.clientCode, @required  this.clientDetailModel})
      : super(key: key);

  @override
  _AllPeople createState() => _AllPeople();
}


class _AllPeople extends State<AllPeople> {
  List<UserDetailModel> _listOfAdminTeam = [];
  List<UserDetailModel> _listOfManagerTeam = [];
                                                        
  _initialize() async{
    
    PeopleVM.instance.init();
    AllPeopleVM.instance.init();
    _listOfAdminTeam = [];
    _listOfManagerTeam = [];
    print("selected manager==========${widget.clientDetailModel?.selectedManager}");
    await AllPeopleVM.instance.getManagerDetail(widget.clientDetailModel?.selectedManager);
    await AllPeopleVM.instance.getAdminDetail(widget.clientDetailModel?.selectedAdmin);
    setState(() { });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future showDelegatesDialog(BuildContext context) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,  
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return Add_Delegates(list: GlobalVar.strAccessLevel=="2" ? _listOfManagerTeam : _listOfAdminTeam,
          adminDetail: AllPeopleVM.instance.adminDetailModel);
        });
  }

  Future showDeleteDialog(BuildContext context) {
    return showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return AlertDialog(title: Text('Delete user?'), actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop("Yes");
              },
              elevation: 5.0,
              child: Text('YES'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop("No");
              },
              elevation: 5.0,
              child: Text('NO'),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                widget.clientDetailModel == null? AppConstant.circulerProgressIndicator():
                widget.clientDetailModel.cityName == null? AppConstant.noDataFound(): 
                
                "${widget.clientDetailModel.clientName}",
                
          style: txtS(Colors.black, 16, FontWeight.w500),), 
        backgroundColor: Colors.white,
      ), 
      floatingActionButton: GlobalVar.strAccessLevel == "2" || GlobalVar.strAccessLevel == "3"
          ? FloatingActionButton(
              backgroundColor: Color(0xff0099FF),
              onPressed: () {
                showDelegatesDialog(context);
              },
              child: SvgPicture.asset(
                'images/AddUser.svg',
                allowDrawingOutsideViewBox: true,
              ),
            )
          : SizedBox(
              height: 0.0,
            ),
      body: SingleChildScrollView(
         
        padding: EdgeInsets.symmetric(horizontal: b * 22),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // sh(18),
            //   Container(
            //     alignment: Alignment.center,
            //     width: b * 340,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: dc, width: 0.5),
            //       color: Color(0xffffffff),
            //       borderRadius: BorderRadius.circular(b * 60),
            //     ),
            //     child: TextField(
            //       onChanged: (val){
            //         _listOfManagerTeam = PeopleVM.instance.onSearchManagerTeam(val);
            //         _listOfAdminTeam = PeopleVM.instance.onSearchAdminTeam(val);
            //         setState(() {});
            //       },
            //       style: TextStyle(fontSize: b * 14, color: dc),
            //       decoration: InputDecoration(
            //         prefixIcon: InkWell(
            //           child: Icon(Icons.search, color: Colors.black),
            //           onTap: null,
            //         ),
            //         isDense: true,
            //         isCollapsed: true,
            //         prefixIconConstraints:
            //             BoxConstraints(minWidth: 40, maxHeight: 24),
            //         hintText: 'Search by Name/Phone No',
            //         hintStyle: TextStyle(
            //           fontSize: b * 14,
            //           color: Color(0xff858585),
            //         ),
            //         contentPadding: EdgeInsets.symmetric(
            //             vertical: h * 12, horizontal: b * 13),
            //         border: InputBorder.none,
            //       ),
            //     ),
            //   ),
              
            sh(11),
              Text(
                "Manager",
                style: txtS(dc, 14, FontWeight.w400),
              ),
              sh(8),
              InkWell(
                 onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: AllPeopleVM.instance.managerDetailModel, )));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: h * 8),
                  padding: EdgeInsets.symmetric(
                      vertical: h * 14.45, horizontal: b * 17),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(b * 10),
                    border: Border.all(
                      color: Color(0xff065e87),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: h * 46,
                        width: b * 46,
                        decoration: BoxDecoration(
                          color: Color(0xff6d6d6d),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacer(),
                      AllPeopleVM.instance.managerDetailModel == null? AppConstant.circulerProgressIndicator():
                      AllPeopleVM.instance.managerDetailModel.key == null? AppConstant.noDataFound(): 
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${AllPeopleVM.instance.managerDetailModel.name??""}",
                            style:
                                txtS(Color(0xff065e87), 15.51, FontWeight.w500),
                          ),
                          Text(
                            "${AllPeopleVM.instance.managerDetailModel.phoneNo??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                txtS(Color(0xff858585), 11.63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
            sh(16),
              Text(
                "Admin",
                style: txtS(dc, 14, FontWeight.w400),
              ),
              sh(8),
              InkWell(
                onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: AllPeopleVM.instance.adminDetailModel, )));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: h * 8),
                  padding: EdgeInsets.symmetric(
                      vertical: h * 14.45, horizontal: b * 17),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(b * 10),
                    border: Border.all(
                      color: Color(0xff065e87),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: h * 46,
                        width: b * 46,
                        decoration: BoxDecoration(
                          color: Color(0xff6d6d6d),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacer(),
                      AllPeopleVM.instance.adminDetailModel == null? AppConstant.circulerProgressIndicator():
                     AllPeopleVM.instance.adminDetailModel.key == null? AppConstant.noDataFound(): 
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${AllPeopleVM.instance.adminDetailModel.name??""}",
                            style:
                                txtS(Color(0xff065e87), 15.51, FontWeight.w500),
                          ),
                          Text(
                            "${AllPeopleVM.instance.adminDetailModel.delegate??""}",
                            style:
                                txtS(Color(0xff065e87), 15.51, FontWeight.w500),
                          ),
                          Text(
                            "${AllPeopleVM.instance.adminDetailModel.phoneNo??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                txtS(Color(0xff858585), 11.63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
            SizedBox(width: SizeConfig.b * 5),
            Row(
                children: [
                  Text(
                    "Manager Team",
                    style: txtS(dc, 13.57, FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "Total:${_listOfAdminTeam?.length??0}",
                    style: txtS(Color(0xff858585), 12, FontWeight.w400),
                  ),
                ],
              ),
            SizedBox(height: SizeConfig.v * 1),
            Container(
              height: h *200,
              child: StreamBuilder<Event>(
                    stream: FirebaseDatabase.instance.reference().child("managerTeam").orderByChild("headUid").equalTo("${widget.clientDetailModel?.selectedManager}").onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                          if(!PeopleVM.instance.isManagerTeamSearched){
                            _listOfManagerTeam = [];
                          (snapshot.data.snapshot.value as Map)?.forEach((key, value) { 
                            UserDetailModel _usermodel = UserDetailModel.fromJson(key, value);
                            _usermodel?.clientsVisible = AllPeopleVM.instance.managerDetailModel?.clientsVisible;
                            _listOfManagerTeam.add(_usermodel);
                          });
                          PeopleVM.instance.setManagerTeamList = _listOfManagerTeam;  
                          }
                        if(snapshot.data.snapshot.value!=null)
                        return ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _listOfManagerTeam.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return InkWell(
                                onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: _listOfManagerTeam[index], )));
                                },
                                onLongPress: () {
                                  if(GlobalVar.strAccessLevel == "2" ||GlobalVar.strAccessLevel == "1")
                                  showDeleteDialog(context).then((value) async {
                                  
                                    if (value == "Yes") {
                                        FirebaseDatabase.instance.reference().child("managerTeam/${_listOfManagerTeam[index].key}").remove(); 
                                    }
                                  });
                                },
                    
                    child: Container(
                      margin: EdgeInsets.only(bottom: h * 8),
                      padding: EdgeInsets.symmetric(
                          vertical: h * 11, horizontal: b * 17),
                      decoration: BoxDecoration(
                        color: Color(0xfff1f1f1),
                        borderRadius: BorderRadius.circular(b * 10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: h * 36,
                            width: b * 36,
                            decoration: BoxDecoration(
                              color: Color(0xff6d6d6d),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: b * 10),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_listOfManagerTeam[index].name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(dc, 15.51, FontWeight.w400),
                                ),
                                Text(
                                   _listOfManagerTeam[index].post.split("@")[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                                Text(
                                  _listOfManagerTeam[index].phoneNo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ); 
                             
                            });  else
                          return AppConstant.noDataFound();
                      }
                      else{
                        if(snapshot.hasError)
                        return Center(
                              child: Text('${snapshot.error}'),
                            );
                        else
                        return AppConstant.circulerProgressIndicator();   
                      }
                    },
                  ),
            ),
            SizedBox(height: 10.0,),
            Row(
                children: [
                  Text(
                    "Admin Team",
                    style: txtS(dc, 13.57, FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "Total:${_listOfAdminTeam?.length??0}",
                    style: txtS(Color(0xff858585), 12, FontWeight.w400),
                  ),
                ],
              ),
            Container(
              height: h *200,
              child:StreamBuilder<Event>(
                stream: FirebaseDatabase.instance.reference().child("adminTeam").orderByChild("headUid").equalTo("${widget.clientDetailModel?.selectedAdmin}").onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                      if(!PeopleVM.instance.isAdminTeamSearched){
                        _listOfAdminTeam = [];
                      (snapshot.data.snapshot.value as Map)?.forEach((key, value) {
                        UserDetailModel _usermodel = UserDetailModel.fromJson(key, value);
                       _usermodel.clientsVisible = AllPeopleVM.instance.adminDetailModel.clientsVisible;
                             
                        _listOfAdminTeam.add(_usermodel);
                      });
                      PeopleVM.instance.setAdminTeamList = _listOfAdminTeam;
                      }
                    if(snapshot.data.snapshot.value!=null)
                    return ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _listOfAdminTeam.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return InkWell(
                            onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: _listOfAdminTeam[index], )));
                                },
                             onLongPress: () {
                              if(GlobalVar.strAccessLevel == "3" ||GlobalVar.strAccessLevel == "1" )
                              showDeleteDialog(context).then((value) async {
                              
                                if (value == "Yes") {
                                    FirebaseDatabase.instance.reference().child("adminTeam/${_listOfAdminTeam[index].key}").remove(); 
                                }
                              });
                            },
                    
                    child: Container(
                      margin: EdgeInsets.only(bottom: h * 8),
                      padding: EdgeInsets.symmetric(
                          vertical: h * 11, horizontal: b * 17),
                      decoration: BoxDecoration(
                        color: Color(0xfff1f1f1),
                        borderRadius: BorderRadius.circular(b * 10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: h * 36,
                            width: b * 36,
                            decoration: BoxDecoration(
                              color: Color(0xff6d6d6d),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: b * 10),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _listOfAdminTeam[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(dc, 15.51, FontWeight.w400),
                                ),
                                Text(
                                  _listOfAdminTeam[index].post.split("@")[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                                Text(
                                  _listOfAdminTeam[index].phoneNo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                        });  else
                      return AppConstant.noDataFound();
                  }
                  else{
                    if(snapshot.hasError)
                    return Center(
                          child: Text('${snapshot.error}'),
                        );
                    else
                    return AppConstant.circulerProgressIndicator();   
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
