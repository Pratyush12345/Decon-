import 'package:Decon/Models/Consts/AppString.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/View_Android/Authentication/login_viewmodel.dart';
import 'package:Decon/View_Android/Authentication/otp_screen.dart';
import 'package:Decon/View_Android/DeconManager/AddCity.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final TextEditingController phone = TextEditingController();
  final _countryCode = TextEditingController(text: "+91");
  String _errorPhoneNo = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('images/login_image.png', width: SizeConfig.screenWidth),
          Column(
            children: [
              Spacer(),
              Container(
                width: SizeConfig.screenWidth,
               alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: b * 26),
                padding:
                    EdgeInsets.symmetric(horizontal: b * 17, vertical: h * 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(b * 5),
                  border: Border.all(color: blc, width: 1),
                ),
                child: TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: b * 16, color: blc),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Enter Your Phone',
                    hintStyle: TextStyle(
                      fontSize: b * 16,
                      color: Color(0xff848484),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              if (_errorPhoneNo != "")
                        Text(
                          "$_errorPhoneNo",
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.red),
                        ),
              sh(21),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: b * 26),
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: h * 13),
                  color: Color(0xff00A3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(b * 6),
                  ),
                  onPressed: () {
                    if (phone.text.length != 10) {
                                setState(() {
                                  _errorPhoneNo =
                                      "Phone No should be of 10 digits";
                      });
                     } 
                    else {
                      LoginVM.instance.verifyPhone(context, _countryCode.text.trim() + phone.text.trim() );
                      Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 300),
                        type: PageTransitionType.rightToLeftWithFade,
                        childCurrent: Login(),
                        child: Otp(countryCode: _countryCode.text.trim() ,phoneNo: phone.text.trim(),),
                      ),
                    );
                    }
                    
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth,
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: b * 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap:  () async{
                  String _url = "${AppString.privacy_policy_url}";
                 if(await canLaunch("$_url")){
                  launch(_url);
                 }else{
                   throw 'Could not launch $_url';
                 }

                },
                child: Text("Terms & Privacy Policy",
                 style: txtS(Colors.grey, 14.0, FontWeight.bold),
                 ),
              ),
              sh(20),
            ],
          ),
        ],
      ),
    );
  }
}
