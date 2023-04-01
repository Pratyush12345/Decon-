import 'dart:async';
import 'dart:io'; 
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/View_Android/Dialogs/UploadDialog.dart';
import 'package:Decon/View_Android/Dialogs/areYouSure.dart';
import 'package:Decon/Models/AddressCaluclator.dart';
import 'package:Decon/View_Android/OverflowChat/ShowMedia.dart';
import 'package:Decon/Controller/ViewModels/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Decon/Controller/MessagingService/random_string.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/OverflowChat/BeforeImageLoading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeBoard extends StatefulWidget {
  final Map cityMap;
  NoticeBoard({@required this.cityMap});
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();
  List<Messages> _allMessages = [];
  bool _scrolleffect = true;
  String _selfId, type = "Text";
  final dbRef = FirebaseDatabase.instance;
  Query _query;
  Map<String, bool> _isDeleting = {};
  File imageFile;
  var _storageReference;
  int items = 2;
  String resolveid = "-1";
  String cityName, cityCode, location;
  Map<String, String> _months = {
    "01": "Jan",
    "02": "Feb",
    "03": "Mar",
    "04": "Apr",
    "05": "May",
    "06": "Jun",
    "07": "Jul",
    "08": "Aug",
    "09": "Sep",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec"
  };

  _buildMessage(Messages message, bool isMe, BuildContext context) {
    String _dateTime = DateFormat('jms').format(DateTime.parse(message.time));
    final GestureDetector msg = GestureDetector(
      onLongPress: () {
        if (isMe) {
          setState(() {
            _scrolleffect = false;
            if (!_isDeleting[message.key])
              _isDeleting[message.key] = true;
            else
              _isDeleting[message.key] = false;
          });
        }
      },
      child: Container(
        margin: isMe
            ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0, right: 10.0)
            : EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).accentColor : Colors.blue,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))
              : BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 5.0),
            Column(
              children: [
                if (_isDeleting[message.key])
                  Align(
                    alignment: isMe ? Alignment.topLeft : Alignment.topRight,
                    child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          String res = await showDialog(
                            context: context,
                            builder: (context) => AreYouSure(
                              msg: 'Are you sure, You want to delete ?',
                            ),
                          );
                          if (res == 'Yes') {
                            _deleteNotice(message.key);

                            return;
                          }
                          setState(() {
                            _isDeleting[message.key] = false;
                          });
                        }),
                  ),
                if (message.type == "image")
                  Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(new MaterialPageRoute(builder: (context) {
                          return ShowMedia(
                            url: message.url,
                            type: message.type,
                            allMessages: _allMessages,
                          );
                        })).then((value) {
                          _scrolleffect = false;
                        });
                      },
                      child: Column(
                        children: [
                          FadeInImage(
                            height: 180.0,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            image: NetworkImage(message.url),
                            placeholder: AssetImage('assets/blankimage.png'),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(message.caption ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(message.location ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "${_dateTime.split(":")[0]}:${_dateTime.split(":")[1]} ${_dateTime.split(":")[2].split(" ")[1]}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    DateTime.parse(message.time)
                                            .day
                                            .toString() +
                                        "/" +
                                        DateTime.parse(message.time)
                                            .month
                                            .toString() +
                                        "/" +
                                        DateTime.parse(message.time)
                                            .year
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          //if (Auth.instance.post != null)
                            MaterialButton(
                              child: Text("Resolve"),
                              onPressed: () {
                                type = "image";
                                resolveid = message.selfid;
                                _showSelectionSheet(context);
                              },
                            )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    location = first.addressLine;
    cityName = first.adminArea;
    cityCode = "";
    widget.cityMap.forEach((key, value) {
      if (value == "Jodhpur") cityCode = key;
    });
  }

  _createNotice(String url, String caption, String randomKey,
      BuildContext context) async {
    await _getUserLocation();

    String time = DateTime.now().toString();

    await dbRef.reference().child('/OverflowQueries/$randomKey').update({
      'url': url,
      'time': time,
      'selfId': _selfId,
      'type': type,
      "caption": caption,
      "cityCode": cityCode,
      "location": location,
      "resolveid": resolveid
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  _deleteNotice(String key) async {
    await dbRef.reference().child('/OverflowQueries/$key').remove();
    if (key.length == 7)
      await FirebaseStorage.instance
          .ref()
          .child('OverflowQueries/$key')
          .delete();
  }

  _showSelectionSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListTile(
                  onTap: () {
                    pickImage(context, "FromGallery");
                  },
                  leading: Icon(Icons.image),
                  title: Text("Select image from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    pickImage(context, "FromCamera");
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Capture Image"),
                )
              ],
            ),
          );
        });
  }

  Future<String> pickImage(BuildContext context, String pickedArea) async {
    File selectedImage;
    if (pickedArea == "FromGallery") {
      selectedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
    } else {
      selectedImage = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
    }

    final filePath = selectedImage.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var compressedFile = await FlutterImageCompress.compressAndGetFile(
      selectedImage?.path,
      outPath,
      quality: 50,
      minWidth: 720,
      minHeight: 1280,
    );

    imageFile = compressedFile;
    if (selectedImage != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (contex) => BeforeImageLoading(
                    imageurl: imageFile,
                  ))).then((value) async {
        if (value != null) {
          String randomkey = randomNumeric(7);
          if (randomkey != null) {
            _storageReference = FirebaseStorage.instance
                .ref()
                .child('OverflowQueries/$randomkey');
            var storageUploadTask = _storageReference.putFile(imageFile);
            double percent = 0;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  StatefulBuilder(builder: (context, setState) {
                storageUploadTask.events.listen((event) {
                  setState(() {
                    percent = event.snapshot.bytesTransferred *
                        100 /
                        event.snapshot.totalByteCount;
                  });
                });
                return UploadDialog(warning: '${percent.toInt()}% Uploaded');
              }),
            );
            var url =
                await (await storageUploadTask.onComplete).ref.getDownloadURL();
            _createNotice(url, value, randomkey, context);

            return;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildMessageComposer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: () async {
              type = "image";
              _showSelectionSheet(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.blue,
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Select Photo",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  onEventRemoved(DatabaseEvent event) {
    _scrolleffect = true;
    var index;
    _allMessages.forEach((element) {
      if (element.key == event.snapshot.key) {
        index = _allMessages.indexOf(element);
      }
    });
    setState(() {
      _allMessages.removeAt(index);
    });
  }

  bool _isshowableMsg(Messages _messages) {
    if (GlobalVar.userDetail.post != null) {
      if ("" == _messages.cityCode)
        return true;
      else if (GlobalVar.userDetail.post == "Manager")
        return true;
      else
        return false;
    } else {
      if (_messages.resolveid == FirebaseAuth.instance.currentUser.uid ||
          _messages.selfid == FirebaseAuth.instance.currentUser.uid)
        return true;
      else
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    //Auth.instance.post = "Manager";
    _selfId = FirebaseAuth.instance.currentUser.uid;
    _query = dbRef.reference().child('OverflowQueries');

    _query.onChildAdded.listen((DatabaseEvent event) {
      Messages _messages = Messages.fromSnapshot(event.snapshot);
      bool _isMsgshow = false;
      if (_messages.type != null && _messages.key != "null") {
        _isMsgshow = _isshowableMsg(_messages);

        if (_isMsgshow) {
          _allMessages.add(_messages);
          _isDeleting[_messages.key] = false;
        }
      }
      setState(() {
        _scrolleffect = true;
        _allMessages.sort((a, b) => a.time.compareTo(b.time));
      });
    });
    _query.onChildRemoved.listen(onEventRemoved);
  }

  @override
  Widget build(BuildContext context) {
    if (_scrolleffect)
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complain",
        ),
      ),
      body: GestureDetector(
        onTap: () => {FocusScope.of(context).unfocus()},
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      30.0,
                    ),
                    topRight: Radius.circular(
                      30.0,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      30.0,
                    ),
                    topRight: Radius.circular(
                      30.0,
                    ),
                  ),
                  child: ListView.builder(
                    reverse: false,
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      top: 15.0,
                    ),
                    itemCount: _allMessages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = _allMessages[index];
                      bool isMe = false;

                      if (message.selfid ==
                          FirebaseAuth.instance.currentUser.uid) isMe = true;

                      return _buildMessage(message, isMe, context);
                    },
                  ),
                ),
              ),
            ),
            if (GlobalVar.userDetail.post == null) _buildMessageComposer(context),
          ],
        ),
      ),
    );
  }
}
