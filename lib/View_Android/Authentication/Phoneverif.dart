import 'package:Decon/Controller/ViewModels/Services/Auth.dart';
import 'package:animator/animator.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PhoneVerif extends StatefulWidget {
  @override
  _PhoneVerifState createState() => _PhoneVerifState();
}

class _PhoneVerifState extends State<PhoneVerif> {
  final _countryCode = TextEditingController(text: "+91");
  final _phoneNoController = TextEditingController();
  String phoneNo;
  String smsCode = "";
  bool _isphoneVerif = true;
  String verificationID;
  bool codeSent = false;
  List<FocusNode> _listisAutoFocused;
  String _errorPhoneNo = "";

  verifyPhone(context) async {
    final PhoneVerificationCompleted verfiySuccess =
        (AuthCredential cred) async {
      print("vvvvvvvvvvvvvvvv");
      print("Verify Success");
      print("vvvvvvvvvvvvvvvv");
      await Auth.instance.signInWithCred(
        cred,
      );
    };

    final PhoneVerificationFailed verifyFailure = (Exception error) {
      print("++++++++++");
      print(error);
      print("++++++++++");
    };

    final PhoneCodeSent smsCodeSent = (String verid, [int forceCodeResend]) {
      print("sssssssssssssss");
      print("sms code sent");
      print("sssssssssssssss");
      this.verificationID = verid;
      setState(() {
        this.codeSent = true;
        //smsCodeDialog(context);
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verid) {
      print("aaaaaaaaaaaaaaa");
      print("auto Retrieve");
      print("aaaaaaaaaaaaaaa");
      this.verificationID = verid;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _countryCode.text.trim() + _phoneNoController.text.trim(),
        timeout: Duration(seconds: 120),
        verificationCompleted: verfiySuccess,
        verificationFailed: verifyFailure,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  Widget _getOTPWidget(int pos, bool isAutoFocused, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffDEE0E0),
          borderRadius: BorderRadius.circular(SizeConfig.b * 1)),
      alignment: Alignment.center,
      width: SizeConfig.b * 10,
      child: TextField(
        onChanged: (value) {
          if (value.length == 1) {
            setState(() {
              smsCode = smsCode + value;
              if (pos != 5)
                FocusScope.of(context)
                    .requestFocus(_listisAutoFocused[pos + 1]);
            });
          }
        },
        focusNode: _listisAutoFocused[pos],
        autofocus: isAutoFocused,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: SizeConfig.b * 4),
        decoration: InputDecoration(
          counterText: "",
          hintStyle: TextStyle(fontSize: SizeConfig.b * 3.7),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void initState() {
    _listisAutoFocused = [];
    for (int i = 0; i < 6; i++) {
      _listisAutoFocused.add(FocusNode());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          Animator<Offset>(
            tween: Tween<Offset>(begin: Offset(1, 1.2), end: Offset(0.7, 1.2)),
            cycles: 1,
            builder: (context, animatorState, child) => FractionalTranslation(
              translation: animatorState.value,
              child: Container(
                height: 300.0,
                width: 400.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150.0),
                    color: Colors.blue.withOpacity(0.2)),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              padding: EdgeInsets.all(22.0),
              children: [
                Animator<Offset>(
                  tween: Tween<Offset>(
                      begin: Offset(-1, -0.4), end: Offset(-0.7, -0.3)),
                  cycles: 1,
                  builder: (context, animatorState, child) =>
                      FractionalTranslation(
                    translation: animatorState.value,
                    child: Container(
                      height: 200.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(180.0),
                          color: Color(0xFFE6E7E8)),
                    ),
                  ),
                ),
                _isphoneVerif
                    ? Animator(
                        cycles: 1,
                        tween: Tween<Offset>(
                            begin: Offset(0, -0.5), end: Offset(0, -0.6)),
                        duration: Duration(milliseconds: 500),
                        builder: (context, animatorState, child) =>
                            FractionalTranslation(
                                translation: animatorState.value,
                                child: Container(
                                  height: 150.0,
                                  width: 150.0,
                                  child: Image(
                                      key: UniqueKey(),
                                      width: 150.0,
                                      height: 150.0,
                                      image: AssetImage('assets/DECON_1.png')),
                                )),
                      )
                    : Center(
                        child: Text(
                          "VERIFICATION",
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 24 / 360,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff263238),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20.0,
                ),
                _isphoneVerif
                    ? Transform(
                        transform: Matrix4.translationValues(0, -60.0, 0),
                        child: Center(
                          child: Text(
                            "DECON",
                            style: TextStyle(
                              fontSize: SizeConfig.screenWidth * 45 / 360,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff005A87),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Please type the verification code sent\nto your entered mobile number",
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 16 / 360,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff5D6369),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                SizedBox(
                  height: SizeConfig.screenHeight * 30 / 640,
                ),
                _isphoneVerif
                    ? SizedBox(
                        height: 0.0,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _getOTPWidget(0, true, context),
                          _getOTPWidget(1, false, context),
                          _getOTPWidget(2, false, context),
                          _getOTPWidget(3, false, context),
                          _getOTPWidget(4, false, context),
                          _getOTPWidget(5, false, context),
                        ],
                      ),
                SizedBox(
                  height: SizeConfig.screenHeight * 40 / 640,
                ),
                _isphoneVerif
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffDEE0E0),
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.b * 1)),
                                alignment: Alignment.center,
                                width: SizeConfig.b * 10,
                                child: TextField(
                                  autofocus: false,
                                  controller: _countryCode,
                                  style: TextStyle(
                                    fontSize: SizeConfig.b * 4,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff848484),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: SizeConfig.screenWidth * 6 / 360),
                                    hintStyle: TextStyle(
                                      fontSize: SizeConfig.b * 3.7,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              if (_errorPhoneNo != "")
                                Text(
                                  "   ",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.red),
                                ),
                            ],
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 20 / 360,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(
                                    SizeConfig.b * 5.09, 0, 0, 0),
                                width: SizeConfig.b * 70,
                                decoration: BoxDecoration(
                                    color: Color(0xffDEE0E0),
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.b * 1)),
                                child: TextField(
                                  controller: _phoneNoController,
                                  style: TextStyle(fontSize: SizeConfig.b * 4),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Number',
                                    hintStyle: TextStyle(
                                      fontSize: SizeConfig.b * 3.7,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff848484),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              if (_errorPhoneNo != "")
                                Text(
                                  _errorPhoneNo,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.red),
                                ),
                            ],
                          )
                        ],
                      )
                    : SizedBox(
                        height: 3.0,
                      ),
                SizedBox(
                  height: 75.0,
                ),
                Center(
                  child: _isphoneVerif
                      ? ButtonTheme(
                          height: SizeConfig.screenHeight * 30 / 640,
                          minWidth: SizeConfig.screenWidth * 120 / 360,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenWidth * 6 / 360),
                              side: BorderSide(color: Colors.blue),
                            ),
                            onPressed: () async {
                              if (_phoneNoController.text.length != 10) {
                                setState(() {
                                  _errorPhoneNo =
                                      "Phone No should be of 10 digits";
                                });
                              } else {
                                setState(() {
                                  _isphoneVerif = false;
                                });
                              }
                              verifyPhone(context);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => EnterOTP(phoneNo: _countryCode.text.trim()+_phoneNoController.text.trim() , name: _nameController.text.trim(),)));
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.screenWidth * 14 / 360,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            textColor: Colors.white,
                            elevation: 1.0,
                            color: Colors.blue,
                          ),
                        )
                      : ButtonTheme(
                          height: 60.0,
                          minWidth: 60.0,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.blue)),
                            onPressed: () async {
                              await Auth.instance.signInWithOTP(
                                verificationID,
                                smsCode,
                              );
                            },
                            child: Icon(Icons.arrow_forward),
                            textColor: Colors.white,
                            elevation: 3.0,
                            color: Colors.blue,
                          ),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
