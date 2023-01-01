import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Celebrity/Requests/DownloadImages.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Exploer/viewData.dart';
import 'package:celepraty/Users/chat/checkConversation.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart' as dt;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Celebrity/Requests/DownlodeImgeViduo.dart';
import '../../Celebrity/chat/ChatRoomModel.dart';
import '../../Celebrity/chat/chat_Screen.dart';
import '../../main.dart';

import 'package:audioplayers_platform_interface/api/player_state.dart' as ss;
import 'package:path/path.dart' as path;

class chatRoom extends StatefulWidget {
  int? conId, createUserId;
  String? createImage, createName;
  chatRoom(
      {Key? key,
      this.conId,
      this.createImage,
      this.createUserId,
      this.createName})
      : super(key: key);
  _chatRoomState createState() => _chatRoomState();
}

class _chatRoomState extends State<chatRoom> {
  bool boolHelp = false;
  var url;
  List<Widget>? listwidget = [];
  List<Widget>? temp = [];
  File? file;
  File? vid;
  String help = "";
  static bool isWritting = false;
  bool isPressed = false;
  bool wrote = false;
  var currentFocus;
  List<Widget> newCon = [];
  List<String> vices = [];
  TextEditingController m = new TextEditingController();
  bool isPlaying = false;
  File? imagee;
  Duration duration = Duration();
  Duration position = Duration();
  final _baseUrl = 'https://mobile.celebrityads.net/api/user/messages/';
  int _page = 1;
  bool ActiveConnection = false;
  String T = "";
  bool isReady = false;
  int helper = 0;
  int helper2 = 0;
  bool downloaded = false;
  // There is next page or not
  bool _hasNextPage = true;
  bool vicer = false;
  String? vicep;
  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;
  Map<int, AudioPlayer>  players = HashMap();
  double progress = 0.0;
  Dio dio = Dio();
  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  bool isFirstTime = true;
  final player = AudioPlayer();
  Data? _posts;
  ScrollController _controller = ScrollController();
  bool added = false;
  String? userToken;
  int? userId;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  DataConversation? checkCon;
  int? from;
  int? theId;
  int? numberOfnNotRead;
  String? name, senderImage;

  Map<int, bool> exists = HashMap();
  Map<int, String> devicePathes = HashMap();
  bool downloading = false;
  String? pp;
  void _loadMore() async {
    // print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.maxScrollExtent == _controller.offset) {
      setState(() {
        foundMessage = false;
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;
      try {
        final res = await http
            .get(Uri.parse('$_baseUrl${widget.conId}?page=$_page'), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });

        if (ChatRoomModel.fromJson(jsonDecode(res.body)).data != null) {
          setState(() {
            _posts = ChatRoomModel.fromJson(jsonDecode(res.body)).data!;
            for (int i = 0;
                i <
                    ChatRoomModel.fromJson(jsonDecode(res.body))
                        .data!
                        .messages!
                        .length;
                i++) {
              if (ChatRoomModel.fromJson(jsonDecode(res.body))
                      .data!
                      .messages![i]
                      .messageType ==
                  'voice') {
                AudioPlayer ap = AudioPlayer();
                ap.setSourceUrl('https://mobile.celebrityads.net/storage/images/messages/o50X9TloxGpsLHUZSAwDFkEfkNTaiRmAAqpPD3l8.mp4');
                players.putIfAbsent(i, () => ap);
              }
            }
            refresh();
          });
        } else {
          print('no data');
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  bool finished = false;
  Directory? directory;
  Directory? audiodirectory;
  bool? b;
  int templist = 1;
  int templi = 0;
  @override
  initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
      DatabaseHelper.getUserData().then((value) {
        setState(() {
          userId = value;

          widget.createUserId != null
              ? {
                  check(userId!, widget.createUserId!),
                }
              : getConversations();
        });
      });
    });
    print(widget.conId.toString()+'ddddddddddddddddddddddddddddddddddddd');
    inChat = true;
    foundMessage = false;
    FirebaseMessaging.onMessage.listen(onMessageNotification2);
    _controller.addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    inChat = false;
    theName = '';
    _controller.removeListener(_loadMore);

    super.dispose();
  }

  void onMessageNotification2(RemoteMessage message) async {
    if (message != null && message.data['type'] == 'read_message') {
      print(message.data['type'].toString() +
          '***-------------*************-------------*****************-----------***');
      setState(() {
        helper2 = helper2 + 1;
      });
    }
    print(helper2);
    print(message.data['body']);
    print(
        '***-------------*****in chat room********-------------*****************-----------***');
    if (message != null) {
      temp=[];
      temp!.addAll(newCon.reversed);
      temp!.addAll(listwidget!);
      listwidget = [];
      newCon = [];
      _page = 1;
      getConversations();
      if (message.data['type'] == 'message') {
        print(listwidget!.length.toString() + newCon.length.toString());
      }
    }
    ;
    // print('foundMessage is:--------------------------$foundMessage');
    // var android = const AndroidNotificationDetails(
    //     'channel_id', 'channelName', 'channelDescription');
    // var ios = const IOSNotificationDetails();
    // var platform = NotificationDetails(iOS: ios, android: android);
    // await flutterLocalNotificationsPlugin.show(
    //     0, message.data['body'], message.data['body'], platform);
  }

  Future<bool>? getExist(ur,int i) async {
    if (Platform.isAndroid){
      directory = await getExternalStorageDirectory();
      String dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      String filename = ur.split('/').last;
      bool ext=path.basename(ur).contains('.bin');
      File fileaudio =ext?  File(dir + "/" + path.basename(ur).replaceAll('.bin', '.mp3')):
      File(dir + "/" + path.basename(ur).replaceAll('.3gp', '.mp3'));
      setState(() {
        pp = directory!.path + '/منصات المشاهير/';
      });
      File f =ext? File(directory!.path + "/" + path.basename(ur).replaceAll('.bin', '.mp3')): File(directory!.path + '/منصات المشاهير/' + path.basename(ur).replaceAll('25', ''));
      bool v = f.existsSync();
      bool va = fileaudio.existsSync();

      setState(() {
        !f.path.endsWith('.3gp')|| f.path.endsWith('.mp3') || f.path.endsWith('.bin')?print(v.toString() +  '///////////////////////////////////////////'): print(v.toString() +  '///////////////inside////////////////////////////');
        //vices
        f.path.endsWith('.3gp') || f.path.endsWith('.mp3')|| f.path.endsWith('.bin')?
        vices.add(i.toString()+va.toString()):exists.addEntries(<int, bool>{i : v}.entries);
        f.path.endsWith('.3gp')|| f.path.endsWith('.mp3')|| f.path.endsWith('.bin')?devicePathes.putIfAbsent(i, () => fileaudio.path):devicePathes.putIfAbsent(i, () => f.path);
        print(fileaudio.path +
            va.toString() +
            '///////////////////////////////////////////');
        b = v;
      });
    }else{
      directory = await getApplicationDocumentsDirectory();
      bool ext=path.basename(ur).contains('.bin');
      File saveFile =ext? File(directory!.path + "/" + path.basename(ur).replaceAll('.bin', '.mp3')):
      File(directory!.path + "/" + path.basename(ur).replaceAll('.3gp', '.mp3'));
      bool v = saveFile.existsSync();
      saveFile.path.endsWith('.3gp')|| saveFile.path.endsWith('.mp3')|| saveFile.path.endsWith('.bin')?vices.add(i.toString()+v.toString()):exists.addEntries(<int, bool>{i : v}.entries);
      devicePathes.putIfAbsent(i, () => saveFile.path);
      print(saveFile.path +
          v.toString() +
          '///////////////////////////////////////////');
      setState(() {
        b = v;
      });
    }


      return true;

    //await Future.delayed(Duration(seconds: 1));
    return b!;
  }

  Future testAsync() async {
    print('starting');
    await Future.delayed(Duration(milliseconds: 1000));
    print('done');
  }

  refresh() {
    widget.createUserId != null
        ? null
        : {
            _isFirstLoadRunning
                ? null
                : {

                    //listwidget!.add(voiceRecord('text2')),
                    for (int i = 0; i < _posts!.messages!.length; i++)
                      {
                        setState(() {
                          templist = listwidget!.length;
                        }),
                        if ((_posts!.messages![i].sender!.id != userId))
                          {
                            if (_posts!.messages![i].messageType == 'image')
                              {
                                getExist(_posts!.messages![i].body, i)!.then(
                                  (value) => listwidget!.add(image2(
                                      _posts!.messages![i].body,
                                      _posts!.messages![i].date!.substring(10),
                                      i)),
                                )
                              }
                            else
                              {
                                if (_posts!.messages![i].messageType == 'video')
                                  {
                                    //   directory = await getApplicationDocumentsDirectory(),
                                    //  b = await File(directory!.path+'/منصات المشاهير/'+path.basename(_posts!.messages![i].body!)).exists(),
                                    // print(b.toString()+'------------------------'),

                                    getExist(_posts!.messages![i].body, i)!
                                        .then(
                                      (v) {
                                        listwidget!.add(video(
                                            _posts!.messages![i].body,
                                            _posts!.messages![i].date!
                                                .substring(10),
                                            thumbnail:
                                                _posts!.messages![i].thumbnail,
                                            i: i));
                                      },
                                    ),
                                  }
                                else
                                  {
                                    if (_posts!.messages![i].messageType ==
                                        'document')
                                      {
                                        getExist(_posts!.messages![i].body, i)!
                                            .then(
                                          (value) => listwidget!.add(document(
                                              _posts!.messages![i].body,
                                              _posts!.messages![i].date!
                                                  .substring(10),i)),
                                        ),
                                        print(_posts!.messages![i].body)
                                      }
                                    else
                                      {
                                        if (_posts!.messages![i].messageType ==
                                            'voice')
                                          {
                                            getExist(_posts!.messages![i].body,
                                                    i)!
                                                .then((value) {
                                              listwidget!.add(voiceRecord(
                                                  players[i]!,
                                                  _posts!.messages![i].body!,
                                                  _posts!.messages![i].date!
                                                      .substring(10),i: i));
                                              url = _posts!.messages![i].body!;
                                              //player.setSourceUrl(url);
                                            })
                                          }
                                        else
                                          {
                                            getExist(_posts!.messages![i].body,
                                                    i)!
                                                .then(
                                              (value) => listwidget!.add(
                                                  containerUser(
                                                      _posts!.messages![i].body,
                                                      _posts!.messages![i].date!
                                                          .substring(10)
                                                          .toString())),
                                            )
                                          }
                                      }
                                  }
                              }
                          }
                        else
                          {
                            if (_posts!.messages![i].messageType == 'image')
                              {
                                if (_posts!.messages![i].messageType == 'image')
                                  {
                                    getExist(_posts!.messages![i].body, i)!
                                        .then(
                                      (value) => listwidget!.add(image2(
                                          _posts!.messages![i].body,
                                          _posts!.messages![i].date!
                                              .substring(10),
                                          i)),
                                    )
                                  }
                                else
                                  {
                                    if (_posts!.messages![i].messageType ==
                                        'video')
                                      {
                                        getExist(_posts!.messages![i].body, i)!
                                            .then((v) {
                                          listwidget!.add(video(
                                              _posts!.messages![i].body,
                                              _posts!.messages![i].date!
                                                  .substring(10),
                                              thumbnail: _posts!
                                                  .messages![i].thumbnail,
                                              i: i));
                                        }),
                                      }
                                    else
                                      {
                                        if (_posts!.messages![i].messageType ==
                                            'document')
                                          {
                                            getExist(_posts!.messages![i].body,
                                                    i)!
                                                .then(
                                              (value) => listwidget!.add(
                                                  document(
                                                      _posts!.messages![i].body,
                                                      _posts!.messages![i].date!
                                                          .substring(10),i )),
                                            ),
                                          }
                                      }
                                  }
                              }
                            else
                              {
                                if (_posts!.messages![i].messageType == 'voice')
                                  {
                                    getExist(_posts!.messages![i].body, i)!
                                        .then((value) {
                                      listwidget!.add(voiceRecord(
                                          players[i]!,
                                          _posts!.messages![i].body!,
                                          _posts!.messages![i].date!
                                              .substring(10),i: i));
                                      url = _posts!.messages![i].body!;
                                      //player.setSourceUrl(url);
                                    })
                                  }
                                else
                                  {
                                    if (numberOfnNotRead! >= (i + 1))
                                      {
                                        getExist(_posts!.messages![i].body, i)!
                                            .then(
                                          (value) => listwidget!.add(container(
                                              _posts!.messages![i].body,
                                              _posts!.messages![i].date!
                                                  .substring(10),
                                              sent)),
                                        )
                                      }
                                    else
                                      {
                                        getExist(_posts!.messages![i].body, i)!
                                            .then(
                                          (value) => listwidget!.add(container(
                                              _posts!.messages![i].body,
                                              _posts!.messages![i].date!
                                                  .substring(10),
                                              Icons.done_all_sharp)),
                                        )
                                      }
                                  }
                              }
                          },
                      },


             listwidget!.isNotEmpty?temp =[]:null,
              foundMessage = false,
            }

          };

  }

  Future gotMessage() async {}
  void addtolist(String tt, icon) {
    setState(() {
      // listwidget!.add(container(m.text));

      // refresh();
      added = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    foundMessage ? {listwidget!.clear(), refresh(), } : null;
    helper == 1 ? boolHelp = true : null;
    checkCon != null
        ? {
            if (checkCon!.check == true)
              {
                widget.conId = checkCon!.conversation!.id!,
                widget.createUserId = null,
                helper < 1
                    ? {
                        getConversations(),
                        refresh(),
                      }
                    : null,
              }
          }
        : null;
    widget.createUserId != null
        ? null
        : {
            helper < 2
                ? {
                    refresh(),
                    helper++,
                    print(listwidget!.length.toString() + ' at first')
                  }
                : null
          };
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          unfocus();
          setState(() {
            isWritting = false;
          });
        },
        child: (_isFirstLoadRunning && !foundMessage && b ==null ) || (checkCon == null && widget.conId == null)
            ? Scaffold(

                body: Center(
                child: mainLoad(context),
              ))
            : Scaffold(
                    appBar: drawAppBar(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            text(
                                context,
                                widget.createName != null
                                    ? widget.createName!
                                    : name!,
                                textSubHeadSize,
                                white),
                            SizedBox(
                              width: 10.w,
                            ),
                            CircleAvatar(
                                backgroundColor: white,
                                radius: 25.r,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(70.r),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.createImage != null
                                        ? widget.createImage!
                                        : senderImage!,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: double.infinity,
                                    // errorBuilder: (context, exception, stackTrace) {
                                    //   return Icon(Icons.error, size: 15.h, color: red,);},
                                  ),
                                ))
                          ],
                        ),
                        context,
                        color: purple,
                        iconColor: white, onPressedd: () {
                      inChat = false;
                      theName = '';
                      _controller.removeListener(_loadMore);

                      Navigator.pop(context);
                    }),
                    body: (_isFirstLoadRunning && !foundMessage)
                        ? Center(
                            child: mainLoad(context),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    // child: SingleChildScrollView(
                                    //   controller: _controller,
                                    //   reverse: true,
                                    child: ListView(
                                      shrinkWrap: true,
                                      controller: _controller,
                                      reverse: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: temp!.isNotEmpty && listwidget!.isEmpty
                                          ? temp!.toList()
                                          : widget.createUserId != null
                                              ? newCon.reversed.toList()
                                              : newCon.reversed.toList() +
                                                  listwidget!,
                                    ),
                                    //  ),
                                  ),
                                ),
                                _posts != null && _posts!.isBlocked!
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15.h, top: 10.h),
                                        width: 350.w,
                                        decoration: BoxDecoration(
                                            color: deepBlack.withOpacity(0.20),
                                            borderRadius:
                                                BorderRadius.circular(80.r)),
                                        height: 30.h,
                                        child: text(
                                            context,
                                            ' لا يمكنك التواصل مع هذا المستخدم راجع الدعم الفني  ',
                                            15,
                                            deepBlack,
                                            align: TextAlign.center),
                                      )
                                    : Padding(
                                        padding: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom !=
                                                0
                                            ? EdgeInsets.only(bottom: 0.h)
                                            : EdgeInsets.only(bottom: 0.h),
                                        child: Container(
                                          height: 60.h,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: purple,
                                                      width: 1))),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Container(
                                                        margin: isWritting
                                                            ? EdgeInsets.only(
                                                                right: 20.w)
                                                            : EdgeInsets.only(
                                                                right: 15.w),
                                                        child: InkWell(
                                                          onTap: () {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            widget.createUserId !=
                                                                    null
                                                                ? setState(() {
                                                                    newCon.add(container(
                                                                        m.text,
                                                                        dt.DateFormat('hh:mm a')
                                                                            .format(DateTime.now()),
                                                                        sending));
                                                                    var text =
                                                                        m.text;
                                                                    var date = dt.DateFormat(
                                                                            'hh:mm a')
                                                                        .format(
                                                                            DateTime.now());
                                                                    isFirstTime
                                                                        ? {
                                                                            createConversation(widget.createUserId!, userToken!, m.text).then((value) =>
                                                                                {
                                                                                  setState(() {
                                                                                    newCon.removeLast();
                                                                                    value == 'SocketException' ? newCon.add(container(text, dt.DateFormat('hh:mm a').format(DateTime.now()), failure)) : newCon.add(container(text, dt.DateFormat('hh:mm a').format(DateTime.now()), sent));
                                                                                  })
                                                                                })
                                                                          }
                                                                        : {
                                                                            createConversation(widget.createUserId!, userToken!, m.text).then((value) =>
                                                                                {
                                                                                  setState(() {
                                                                                    newCon.removeLast();
                                                                                    value == 'SocketException' ? newCon.add(container(text, dt.DateFormat('hh:mm a').format(DateTime.now()), failure)) : newCon.add(container(text, dt.DateFormat('hh:mm a').format(DateTime.now()), sent));
                                                                                  })
                                                                                })
                                                                          };
                                                                    isWritting =
                                                                        false;
                                                                    m.clear();
                                                                  })
                                                                : setState(() {
                                                                    newCon.add(container(
                                                                        m.text,
                                                                        dt.DateFormat('hh:mm a')
                                                                            .format(DateTime.now()),
                                                                        sending));
                                                                    var text =
                                                                        m.text;
                                                                    var date = dt.DateFormat(
                                                                            'hh:mm a')
                                                                        .format(
                                                                            DateTime.now());
                                                                    addMessage(
                                                                            userToken!,
                                                                            m.text)
                                                                        .then((value) => {
                                                                              setState(() {
                                                                                newCon.removeLast();
                                                                                print(value.toString() + '----------------------------------------');
                                                                                value == 'SocketException' ? newCon.add(container(text, dt.DateFormat('hh:mm a').format(DateTime.now()), failure)) : newCon.add(container(text, dt.DateFormat('hh:mm a').format(DateTime.now()), sent));
                                                                              })
                                                                            });
                                                                    isWritting =
                                                                        false;
                                                                    m.clear();
                                                                  });
                                                          },
                                                          child: GradientIcon(
                                                            send,
                                                            35,
                                                            const LinearGradient(
                                                              begin: Alignment(
                                                                  0.7, 2.0),
                                                              end: Alignment(
                                                                  -0.69, -1.0),
                                                              colors: [
                                                                Color(
                                                                    0xff0ab3d0),
                                                                Color(
                                                                    0xffe468ca)
                                                              ],
                                                              stops: [0.0, 1.0],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: isWritting
                                                        ? 45.h
                                                        : 40.h,
                                                    margin: EdgeInsets.only(
                                                        top: 10.h,
                                                        bottom: isWritting
                                                            ? 0.h
                                                            : 10.h,
                                                        left: 20.w),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        border: const Border(
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .grey),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .grey),
                                                            left: BorderSide(
                                                                color: Colors
                                                                    .grey),
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .grey))),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value!.isNotEmpty)
                                                          isWritting = true;
                                                      },
                                                      controller: m,
                                                      onTap: () {
                                                        setState(() {
                                                          m.addListener(() {
                                                            MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom !=
                                                                        0 &&
                                                                    m.text
                                                                        .isNotEmpty
                                                                ? isWritting =
                                                                    true
                                                                : isWritting =
                                                                    false;
                                                          });
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          value = m.text;
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5.h,
                                                                    horizontal:
                                                                        20.w),
                                                        hintStyle: TextStyle(
                                                            fontSize:
                                                                textTitleSize),
                                                        hintText:
                                                            'اكتب هنا .....',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                              ]),
                  ),
      ),
    );
  }

  Widget container(textt, time, icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width:textt.length < 5 ? 90.w:textt.length < 10?100.w:textt.length < 13?  120.w : textt.length * 8.0,
          margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 5),
          decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10))),
          child: Padding(
            padding: EdgeInsets.all(6.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.topRight,
                    child: text(context, textt, textSubHeadSize, white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          icon,
                          color: white,
                          size: 15,
                        )),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          time,
                          style: TextStyle(color: white, fontSize: 13.sp),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget containerUser(textt, time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width:textt.length < 5 ? 80.w:textt.length < 10?100.w:textt.length < 13?  120.w : textt.length * 8.0,
          margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
          decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10))),
          child: Padding(
            padding: EdgeInsets.all(2.0.h),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: text(context, textt, textSubHeadSize, white)),
                Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time,
                      style: TextStyle(color: white, fontSize: 13.sp),
                      textAlign: TextAlign.start,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget image2(text, time, i) {
    //  print(exists[i].toString()+'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DownloadImages(
                      image: exists[i] == false ? text : devicePathes[i],
                      fromDevice: exists[i] == false ? null : true,
                    )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 350.h,
            width: 300.w,
            margin:
                EdgeInsets.only(top: 10.h, bottom: 10.h, left: 3.w, right: 5.w),
            decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: 325.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10)),
                      child: !isConnectSection
                          ? Icon(
                              Icons.error,
                              size: 30.h,
                              color: red,
                            )
                          : CachedNetworkImage(
                              imageUrl: text,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, loadingProgress) {
                                return Center(
                                    child: Container(
                                        color: white,
                                        height: double.infinity.h,
                                        width: 350.w,
                                        child: Container(
                                          color: lightGrey.withOpacity(0.10),
                                        )));
                              },
                              errorWidget: (context, exception, stackTrace) {
                                return Icon(
                                  Icons.error,
                                  size: 30.h,
                                  color: red,
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Container(
                  height: 22.5.h,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.0.w, bottom: 5.h),
                        child: Text(
                          time,
                          style: TextStyle(color: black, fontSize: 13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget   video(text, time, {thumbnail, int? i}) {
    print(devicePathes[i].toString() +
        '------------------------------------------------');
    var snackBar = SnackBar(
      content: Text(
        'تم التحميل بنجاح',
        style: TextStyle(color: white, fontSize: 15.sp),
      ),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: getSize(context).height / 3, right: 130.w, left: 130.w),
      backgroundColor: Colors.black38,
      elevation: 20,
      duration: Duration(seconds: 1),
    );
    print(text.toString() + '------------------------------------------------');
    return StatefulBuilder(
      builder: (cc, setState2) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        print(exists[i].toString() +
                            ']]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');
                        goTopagepush(
                            cc,
                            viewData(
                              video:
                                  exists[i] == false ? text : devicePathes[i],
                              private: true,
                              token: userToken!,
                              videoLikes: 0,
                              device: exists[i] == false ? null : exists[i],
                              thumbnail: thumbnail,
                            ));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => viewData(
                        //               video: exists[i] == false?text:devicePathes[i],
                        //               private: true,
                        //               token: userToken!,
                        //               videoLikes: 0,
                        //           device: true,
                        //               thumbnail: thumbnail,
                        //             )));
                      },
                      //
                      child: Container(
                        height: 350.h,
                        width: 300.w,
                        margin: EdgeInsets.only(
                            top: 10, bottom: 0, left: 3, right: 5),
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: SizedBox(
                                  child: thumbnail != null
                                      ? CachedNetworkImage(
                                          imageUrl: thumbnail,
                                          fit: BoxFit.cover)
                                      : SizedBox(),
                                  height: double.infinity,
                                  width: double.infinity,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    print(exists[i].toString() +
                        ']]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => viewData(
                                  video: exists[i] == false
                                      ? text
                                      : devicePathes[i],
                                  private: true,
                                  token: userToken!,
                                  videoLikes: 0,
                                  device: exists[i] == false ? null : exists[i],
                                  thumbnail: thumbnail,
                                )));
                  },
                  child: CircleAvatar(
                      backgroundColor: black.withOpacity(0.40),
                      radius: 40.r,
                      child: Icon(
                        playVideo,
                        color: white,
                        size: 60.h,
                      )),
                ),
                exists[i] == null
                    ? CircularProgressIndicator()
                    : exists[i] == true
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () async {
                             await Permission.storage.request();
                             var status = await Permission.storage.status;

                             if(status.isGranted){
                               setState2(() {
                                 downloading = true;
                               });
                               Dio dio = Dio();
                               await dio.download(
                                 text,
                                 devicePathes[i],
                                 onReceiveProgress: (recivedBytes, totalBytes) {
                                   setState2(() {
                                     progress = recivedBytes / totalBytes;
                                   }); // print(progress);
                                   print(progress);
                                 },
                                 deleteOnError: true,
                               ).then((_) async {
                                 print(progress);
                                 if (progress >= 1.0) {
                                   setState2(() {
                                     downloading = false;
                                     downloaded = true;
                                   });
                                   print('downloaded');
                                   await ImageGallerySaver.saveFile(devicePathes[i]!,
                                       isReturnPathOfIOS: true);
                                 }
                                 // Navigator.pop(context);
                                 //lode(context, "", "تم التنزيل بنجاح");
                               });
                             }else{}

                            },
                            child: downloaded
                                ? SizedBox()
                                : Container(
                                    margin: EdgeInsets.only(
                                        top: 300.h, left: 220.w),
                                    height: 32.h,
                                    width: 32.h,
                                    decoration: BoxDecoration(
                                        color: white.withOpacity(0.70),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // SizedBox(child:
                                        // Text('10MB', style: TextStyle(color: white, fontSize: 15.sp),),),
                                        Padding(
                                          padding: EdgeInsets.only(left: 6.w),
                                          child: downloading
                                              ? Container(
                                                  height: 20.h,
                                                  width: 20.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 4.w,
                                                    value: progress,
                                                  ))
                                              : Center(
                                                  child: Icon(
                                                  Icons.download,
                                                  color: deepBlack,
                                                  size: 27.r,
                                                )),
                                        ),
                                      ],
                                    ),
                                  ),
                          )
              ],
            ),
            Container(
              width: 300.w,
              height: 20.h,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5.0.w, bottom: 5.h),
                    child: Text(
                      time,
                      style: TextStyle(color: black, fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget voiceRecord(AudioPlayer ap, ur, time, {hint, i}) {
    bool ex = false ;
    String s ='';
    vices.forEach((element) {
      print(element.toString()+'eeeeeeeeeeeelllllllllllllleeeeeeeeee');
      print(i.toString()+'iiiiiiiiiiiiiiiiiiiiiiiiiiiii');
      element.contains(i.toString())?{
        print(element.toString()+'eeeeeeeeeeeeeeeeeeeeee'),
        s= element.replaceAll(i.toString(), ''),
      print(s.toString()+'sssssssssssssssssssssssss'),
        s== 'true'? ex = true: ex=false}:null;
    });

    print(ex.toString()+'xxxxxxxxxxxxxxxxxxxxxxxxx');
    var snackBar = SnackBar(
      content: text(context, 'تم التحميل بنجاح', 15, white,
          align: TextAlign.center, fontWeight: FontWeight.bold),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: getSize(context).height / 3, right: 130.w, left: 130.w),
      backgroundColor: Colors.black38,
      elevation: 20,
      duration: Duration(seconds: 1),
    );
    return StatefulBuilder(
      builder: (context, setState2) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<ss.PlayerState>(
                  stream: ap.onPlayerStateChanged,
                  builder: (context, an) {
                    return Container(
                      height: 50.h,
                      width: 300.w,
                      margin: EdgeInsets.only(
                          top: 10, bottom: 0, left: 3, right: 5),
                      decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: Container(
                            height: 55.h,
                            width: 255.w,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Row(
                              children: [
                                StreamBuilder<Duration>(
                                  stream: ap.onPositionChanged,
                                  builder: (context, snapshot) {
                                    String two(int n) =>
                                        '0' + n.toString().padLeft(1);
                                    return Row(
                                      children: [
                                        StreamBuilder<Duration>(
                                            stream: ap.onDurationChanged,
                                            builder: (context, snap) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: InkWell(
                                                        onTap: () async {
                                                            snapshot.hasData &&
                                                                    snap.hasData
                                                                ? snap.data!.inSeconds ==
                                                                        snapshot
                                                                            .data!
                                                                            .inSeconds
                                                                    ? {
                                                              ex ? {
                                                                                print('read from device'),
                                                                                ap.play(DeviceFileSource(devicePathes[i]!)),
                                                                                ap.setVolume(0.5),
                                                                              }
                                                                            : {
                                                                                print('read from network'),
                                                                                ap.play(UrlSource(ur)),
                                                                                ap.setVolume(0.5),
                                                                                }
                                                                      }
                                                                    : null
                                                                : null;

                                                           !isPlaying || ap.state.name
                                                                .toString() != 'playing'
                                                                ? {
                                                              //file://
                                                                    //print(devicePathes[i]!.toString()+'the path in device'),
                                                              print(devicePathes[i]!),
                                                                  await  ap.setSource(DeviceFileSource(devicePathes[i]!)),
                                                              await ap.play(DeviceFileSource(devicePathes[i]!)),
                                                                    ap.setVolume(
                                                                        0.5),
                                                             isPlaying = true,
                                                                    print(ap.state
                                                                            .name
                                                                            .toString() +
                                                                        '========================================================================================'),
                                                                  }
                                                                : {
                                                              print(devicePathes[i]!),
                                                                    ap.pause(),
                                                             isPlaying = false,
                                                                       };
                                                        },
                                                        child:  !ex && !downloaded
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                              print(devicePathes[i]);
                                              await Permission.storage.request();
                                              var status =await Permission.storage.status;
                                              if(status.isGranted){
                                                setState2(
                                                        () {
                                                      downloading =
                                                      true;
                                                    });
                                                setState2(() {
                                                  downloading= true;
                                                });
                                                downloadFiletoDevice(ur, setState2).then((value) {
                                                  setState2(() {
                                                    downloading= false;
                                                    downloaded = true;
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);}
                                                );
                                              }


                                                                      // Dio dio = Dio();
                                                                      // await dio.download(ur, devicePathes[i]!,
                                                                      //   onReceiveProgress: (recivedBytes, totalBytes) {
                                                                      //     setState2(() {
                                                                      //       progress = recivedBytes / totalBytes;
                                                                      //     });// print(progress);
                                                                      //     print(progress);  },
                                                                      //   deleteOnError: true,
                                                                      // ).then((_) async {
                                                                      //   print(progress);
                                                                      //   if (progress >= 1.0) {
                                                                      //     setState2(() {
                                                                      //       downloading= false;
                                                                      //       downloaded = true;
                                                                      //     });
                                                                      //     print('downloaded');
                                                                      //
                                                                      //   }
                                                                        // Navigator.pop(context);
                                                                        //lode(context, "", "تم التنزيل بنجاح");
                                                                      },

                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right: 5.0
                                                                              .w,
                                                                          bottom:
                                                                              0.h),
                                                                      child: Container(
                                                                          color: Colors.white54,
                                                                          height: 37.h,
                                                                          width: 40.h,
                                                                          child: Card(
                                                                              //     shape: RoundedRectangleBorder(
                                                                              //   borderRadius: BorderRadius.circular(50)
                                                                              // ),
                                                                              elevation: 2,
                                                                              child: downloading
                                                                                  ? Center(
                                                                                      child: Container(
                                                                                          height: 20.h,
                                                                                          width: 20.h,
                                                                                          child: CircularProgressIndicator(
                                                                                            strokeWidth: 3.w,
                                                                                          )))
                                                                                  : Icon(
                                                                                      Icons.download,
                                                                                      color: deepBlack,
                                                                                      size: 27.r,
                                                                                    ))),
                                                                    ),
                                                                  ),
                                                                  // SizedBox(
                                                                  // height: 15.h,
                                                                  // ),
                                                                ],
                                                              )
                                                            : an.hasData &&
                                                                    (an.data!.name ==
                                                                            'playing' &&
                                                                        ap.state.name ==
                                                                            'playing')
                                                                ? snap.data ==
                                                                        null ||  snapshot.data ==null
                                                                    ? CircularProgressIndicator()
                                                                    : snap.data!.inSeconds !=
                                                                            snapshot.data!.inSeconds
                                                                        ? Icon(
                                                                            Icons.pause,
                                                                            color:
                                                                                deepBlack,
                                                                            size:
                                                                                35.h,
                                                                          )
                                                                        : Icon(
                                                                            playVideo,
                                                                            color:
                                                                                deepBlack,
                                                                            size:
                                                                                35.h,
                                                                          )
                                                                : Icon(
                                                                    playVideo,
                                                                    color:
                                                                        deepBlack,
                                                                    size: 35.h,
                                                                  )),
                                                  ),
                                                  Container(
                                                    width:
                                                        !vicer ? 160.w : 180.w,
                                                    child: Slider(
                                                      value: snapshot.hasData
                                                          ? snapshot
                                                              .data!.inSeconds
                                                              .toDouble()
                                                          : 0.00,
                                                      min: 0.00,
                                                      max: snap.hasData ||
                                                              snap.data != null
                                                          ? snap.data!.inSeconds
                                                              .toDouble()
                                                          : 0.00,
                                                      onChanged: (double val) {
                                                        setState(() {
                                                          final pp = Duration(
                                                              seconds:
                                                                  val.toInt());
                                                          ap.seek(pp);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  text(
                                                      context,
                                                      snapshot.hasData && (two(
                                                          snapshot.data!.inSeconds
                                                              .remainder(60)) != '00' || two(
                                                          snapshot.data!.inMinutes
                                                              .remainder(60)) != '00')
                                                          ? '${two(snapshot.data!.inSeconds.remainder(60))} : ${two(snapshot.data!.inMinutes.remainder(60))}'
                                                          : snap.hasData
                                                              ? '${two(snap.data!.inSeconds.remainder(60))} : ${two(snap.data!.inMinutes.remainder(60))}'
                                                              : '0:00',
                                                      15,
                                                      black),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                ],
                                              );
                                            }),
                                      ],
                                    );
                                  },
                                ),
                                // SizedBox(
                                //   width: 200.w,
                                //   child: StatefulBuilder(
                                //     builder: (context, state) => Center(
                                //       child: Slider(
                                //         value: position.inSeconds.toDouble(),
                                //         min: 0.0,
                                //         max: duration.inSeconds.toDouble(),
                                //         onChanged: (double val) {
                                //           state(() {
                                //             final pp = Duration(seconds: val.toInt());
                                //             player.seek(pp);
                                //           });
                                //         },
                                //       ),
                                //     ),
                                //   )
                                // ),

                                // ProgressBar(
                                //   baseBarColor: purple,
                                //   progress:Duration(seconds: 1),
                                //   onDragUpdate: (details) {
                                //     debugPrint('${details.timeStamp}, ${details.localPosition}');
                                //   }, total: Duration(seconds: 2),
                                //
                                //
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(bottom: 0.h),
                child: Container(
                  width: 300.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w, bottom: 0.h),
                        child: Text(
                          time,
                          style: TextStyle(color: black, fontSize: 13.sp),
                        ),
                      ),
                      SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget document(String? text2, time,int i) {
    print(exists[i]!.toString()+' ==========================');
    var snackBar = SnackBar(
      content: Text(
        'تم التحميل بنجاح',
        style: TextStyle(color: white, fontSize: 15.sp),
      ),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: getSize(context).height / 3, right: 130.w, left: 130.w),
      backgroundColor: Colors.black38,
      elevation: 20,
      duration: Duration(seconds: 1),
    );
    String ttt = text2!.replaceAll(
        'https://mobile.celebrityads.net/storage/images/messages/', '');
    return InkWell(
      onTap: () async {
        final appStorage = await getApplicationDocumentsDirectory();
        final file = File('${appStorage.path}/downloads/${path.basename(text2)}');
        print('text2 is:' + file.existsSync().toString());
        openFile(url: exists[i]!? devicePathes[i]!:text2);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 50.h,
            width: 300.w,
            margin: EdgeInsets.only(top: 10, bottom: 5, left: 3, right: 5),
            decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(1.0.w),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  height: 55.h,
                  width: 240.w,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Row(
                    children: [
                      //SizedBox(width: 5.w,),
                      ttt.length >= 20
                          ? text(
                              context,
                              '   ....' + ttt.substring(0, 20),
                              18,
                              black,
                            )
                          : text(
                              context,
                              ttt,
                              18,
                              black,
                            ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: Icon(
                          Icons.description,
                          color: deepBlack,
                          size: 35.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 300.w,
            height: 25.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.0.w, bottom: 5.h),
                  child: Text(
                    time,
                    style: TextStyle(color: black, fontSize: 13.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //
  }

  ///Open file
  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;
    loadingDialogue(context);
    final file = await downloadFile(url, name);
    Navigator.pop(context);

    if (file == null) return;

    print('Path IS: ${file.path}');

    OpenFile.open(file.path);
  }

  ///Download file into private folder not visible to user
  Future<File>? downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return file;
    }
  }

  Future<dynamic> downloadFiletoDevice(String url, setState2) async {
    String dir;
    Directory dd;
    String dirpath;
    File file;
    String filename = url.split('/').last;
    var snackBar = SnackBar(
      content: text(context, 'لم يتم التحميل حاول لاحقا', 15, white,
          align: TextAlign.center, fontWeight: FontWeight.bold),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: getSize(context).height / 3, right: 100.w, left: 100.w),
      backgroundColor: Colors.black38,
      elevation: 20,
      duration: Duration(seconds: 1),
    );
    Platform.isAndroid?{ dir = await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DOWNLOADS),
     dirpath = dir,
      file =filename.contains('.bin')? File('$dirpath/${filename.replaceAll('.bin', '.mp3')}'):
      File('$dirpath/${filename.replaceAll('.3gp', '.mp3')}')
    }:{
      dd = await getApplicationDocumentsDirectory(),
      dirpath = dd.path,
      file =filename.contains('.bin')? File('$dirpath/${filename.replaceAll('.bin', '.mp3')}'):
      File('$dirpath/${filename.replaceAll('.3gp', '.mp3')}')
    };

    var request = await http.get(
      Uri.parse(url),
    );
    print(request.statusCode);
    var bytes = await request.bodyBytes; //close();
    await file.writeAsBytes(bytes).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return setState2(() {
        downloading = false;
      });
    });
    print(file.path);
  }

  unfocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void getConversations() async {
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }

    final response = await http
        .get(Uri.parse('$_baseUrl${widget.conId}?page=$_page'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken'
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        _posts = ChatRoomModel.fromJson(jsonDecode(response.body)).data!;
        numberOfnNotRead = ChatRoomModel.fromJson(jsonDecode(response.body))
            .data!
            .conversation!
            .countNotReadAnotherUser;
        theId = ChatRoomModel.fromJson(jsonDecode(response.body))
            .data!
            .conversation!
            .secoundUser!
            .id;
        userId !=
                ChatRoomModel.fromJson(jsonDecode(response.body))
                    .data!
                    .conversation!
                    .secoundUser!
                    .id
            ? name = ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .conversation!
                .secoundUser!
                .name
            : name = ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .conversation!
                .user!
                .name;
        userId !=
                ChatRoomModel.fromJson(jsonDecode(response.body))
                    .data!
                    .conversation!
                    .secoundUser!
                    .id
            ? senderImage = ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .conversation!
                .secoundUser!
                .image
            : senderImage = ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .conversation!
                .user!
                .image;

        for (int i = 0;
            i <
                ChatRoomModel.fromJson(jsonDecode(response.body))
                    .data!
                    .messages!
                    .length;
            i++) {
          if (ChatRoomModel.fromJson(jsonDecode(response.body))
                  .data!
                  .messages![i]
                  .messageType ==
              'voice') {
            AudioPlayer ap = AudioPlayer();
            ap.setSource(UrlSource(ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .messages![i].body!));
            setState(() {
              players.putIfAbsent(i, () => ap);
            });
          }
        }
        theName = name!;
      });
      print((theId).toString() +
          '=======================================================================');
      setState(() {
        isReady = true;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<String> addMessage(String token, body) async {
    final response = await http.post(
      Uri.parse(
        'https://mobile.celebrityads.net/api/user/message',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "body": body,
        "conversation_id": widget.conId,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      print(response.body +
          '=========================================================================================================================================================');
      return jsonDecode(response.body)['success'].toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.body);
      print(response.statusCode.toString() +
          '============================================================');
      throw Exception('Failed to load activity');
    }
  }

  Future<String> createConversation(
      int userId, String token, String body) async {
    Map<String, dynamic> data = {
      "user_id": '$userId',
      "body": body,
    };
    String url = "https://mobile.celebrityads.net/api/user/conversation/create";
    // try {
    final respons = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: data);

    if (respons.statusCode == 200) {
      print(respons.body);
      var success = jsonDecode(respons.body)["success"];
      print('------------------------------------');
      print(success);
      print('------------------------------------');

      return jsonDecode(respons.body)['success'].toString();
    } else {
      throw Exception('Failed to load activity');
    }
    // } catch (e) {
    //   if (e is SocketException) {
    //     return 'SocketException';
    //   } else if (e is TimeoutException) {
    //     return 'TimeoutException';
    //   } else {
    //     return 'serverException';
    //   }
    // }
  }

  Future<dynamic> _saveNetworkVideo(String url, set) async {
    var snackBar = SnackBar(
      content: text(context, 'لم يتم التحميل حاول لاحقا', 15, white,
          align: TextAlign.center, fontWeight: FontWeight.bold),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: getSize(context).height / 3, right: 100.w, left: 100.w),
      backgroundColor: Colors.black38,
      elevation: 20,
      duration: Duration(seconds: 1),
    );
    String path = url;
    await GallerySaver.saveVideo(path, albumName: 'منصات المشاهير')
        .onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return set(() {
        downloading = false;
      });
    });
  }

  Future<DataConversation> check(int userId, int secondId) async {
    Map<String, dynamic> data = {
      "user_id": '$userId',
      "secound_user_id": '$secondId',
    };
    String url =
        "https://mobile.celebrityads.net/api/celebrity/conversation/check";

    final respons = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
        body: data);

    if (respons.statusCode == 200) {
      print(respons.body);

      setState(() {
        checkCon = CheckConversation.fromJson(jsonDecode(respons.body)).data!;
      });
      var success = CheckConversation.fromJson(jsonDecode(respons.body));
      print('------------------------------------');
      print(success);
      print('------------------------------------');
      return success.data!;
    } else {
      return DataConversation();
    }
  }
}
