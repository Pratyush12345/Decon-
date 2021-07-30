import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final bool myProfile;
  final UserDetailModel userDetailModel;
  Profile({@required this.myProfile,@required this.userDetailModel});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          !this.widget.myProfile ? "User Profile" : "My Profile",
          style: txtS(Colors.black, 16, FontWeight.w500),
        ),
        actions: [
          InkWell(
            onTap: () {},
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: h * (235 + 86),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: h * 235,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      color: dc,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'images/back.png',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: h * 149,
                    child: Container(
                      height: h * 172,
                      width: b * 172,
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
                                backgroundImage: AssetImage("assets/f.png"),
                              ),
                      // child: CachedNetworkImage(
                      //   imageUrl:
                      //       'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8',
                      //   fit: BoxFit.cover,
                      //   imageBuilder: (context, imageProvider) => Container(
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //         image: imageProvider,
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            sh(16),
            Text(
              "${widget.userDetailModel.name??""}",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: txtS(Colors.black, 20, FontWeight.w500),
            ),
            sh(6),
            Text(
              "${widget.userDetailModel.post??""}",
              overflow: TextOverflow.ellipsis,
              style: txtS(Color(0xff858585), 14, FontWeight.w500),
            ),
            sh(26),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: b * 10, vertical: h * 13),
              margin: EdgeInsets.symmetric(horizontal: b * 26),
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
                borderRadius: BorderRadius.circular(b * 6),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Post",
                        style: txtS(Color(0xff0000000), 16, FontWeight.w400),
                      ),
                      Spacer(),
                      Text(
                        widget.userDetailModel.post == "Admin" ? "${widget.userDetailModel.delegate??""}" :"${widget.userDetailModel.post??""}",
                        style: txtS(Color(0xff858585), 14, FontWeight.w400),
                      ),
                    ],
                  ),
                  //sh(19),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: Text(
                  //         "Email",
                  //         style: txtS(Color(0xff0000000), 16, FontWeight.w400),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 6,
                  //       child: Text(
                  //         "vysiontechnology@gmail.com",
                  //         overflow: TextOverflow.ellipsis,
                  //         textAlign: TextAlign.right,
                  //         maxLines: 1,
                  //         style: txtS(Color(0xff858585), 14, FontWeight.w400),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  sh(19),
                  Row(
                    children: [
                      Text(
                        "Clients",
                        style: txtS(Color(0xff0000000), 16, FontWeight.w400),
                      ),
                      Spacer(),
                      Text(
                        widget.userDetailModel.post == "SuperAdmin" ? "All Clients" :"${widget.userDetailModel.clientsVisible.replaceFirst(",", "")??""}",
                        style: txtS(Color(0xff858585), 14, FontWeight.w400),
                    
                      ),
                    ],
                  ),
                ],
              ),
            ),
            sh(16),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: b * 10, vertical: h * 15),
              margin: EdgeInsets.symmetric(horizontal: b * 26),
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
                borderRadius: BorderRadius.circular(b * 6),
              ),
              child: Row(
                children: [
                  Text(
                    "Phone Number",
                    style: txtS(Color(0xff0000000), 16, FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "${widget.userDetailModel.phoneNo??""}",
                    style: txtS(Color(0xff858585), 14, FontWeight.w400),
                  ),
                ],
              ),
            ),
            sh(11),
            !this.widget.myProfile
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: b * 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async{
                            
                              String url = 'tel:${widget.userDetailModel.phoneNo.replaceAll("+91","" )??""}';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                              

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: b * 18, vertical: h * 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(b * 20),
                              border: Border.all(color: blc, width: 1),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'images/Call.svg',
                                  allowDrawingOutsideViewBox: true,
                                ),
                                Text(
                                  "  Call",
                                  style: txtS(blc, 14, FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
