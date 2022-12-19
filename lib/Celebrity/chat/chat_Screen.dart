import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/Celebrity/Requests/DownloadImages.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:audioplayers_platform_interface/api/player_state.dart' as ss;
import 'package:celepraty/Users/Exploer/showChatVideo.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Users/Exploer/viewData.dart';
import '../../Users/Exploer/viewDataImage.dart';
import '../../Users/chat/checkConversation.dart';
import '../../main.dart';
import '../TechincalSupport/contact_with_us.dart';
import 'ChatRoomModel.dart';
import 'package:path/path.dart' as Path;
import 'package:async/async.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as dt;
bool inChat= false;
String theName ='';
class chatScreen extends StatefulWidget {
  int? idd;
  int? conId, createUserId;
  String? createImage, createName;

  chatScreen({Key? key,this.idd, this.conId, this.createImage, this.createUserId, this.createName,  }) : super(key: key);
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen>with AutomaticKeepAliveClientMixin {
  final record = FlutterSoundRecorder();
  Map<int?, VideoPlayerController>? vl= HashMap();
  bool _isRecording = false;
  bool flashOn = false;
  int? coid;
  var url;
  bool isRecorderReady = false;
  bool isPlaying = false;
  bool isRec = false;
  String recorderText = '00:00';
  String? filePath;
  List<Widget>? listwidget = [];
  File? imagee;
  File? file;
  File? vid;
  File? audioPath;
  String help = "";
  String? cameraPath;
  static bool isWritting = false;
  bool isPressed = false;
  bool wrote = false;
  var currentFocus;
  File? image;
  Future<XFile>? imageFile;
  bool hellp = false;
  int? userIdBan;
  TextEditingController m = new TextEditingController();
  List<Widget>? newCon;
  final _baseUrl = 'https://mobile.celebrityads.net/api/celebrity/messages/';
  int _page = 1;
  bool ActiveConnection = false;
  bool isFirstTime = true;
  String T = "";
  bool isReady = false;
  int helper = 0;
  bool? hasPermission;
  // There is next page or not
  bool _hasNextPage = true;
  bool added = false;
  int? numberOfnNotRead;
  late List<CameraDescription> _cameras;
  late CameraController controller;
  Map<int, AudioPlayer> players = HashMap();
  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;
  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  late Stream<DurationState> _durationState;
  // This holds the posts fetched from the server
  //final player = AudioPlayer();
  Data? _posts;
  ScrollController _controller = ScrollController();
  String? newPath;
  String? userToken;
  bool change= false;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool boolHelp = false;
  Duration duration = Duration();
  Duration position = Duration();
  int? theId;
  int? userId;
  String? name, senderImage;
  List<Widget>? temp = [];
  double _currentSliderValue = 20;
  Directory? tempDir;
  String? pathToRecord;
  Uint8List? uint8list;
  DataConversation? checkCon;
  int count = 0 ;
  int cameraId =0;
  @override
  void dispose() {
    inChat = false;
    theName = '';
    controller.dispose();
    // vl!.forEach((key, value) {
    //   value.dispose();
    // });
    super.dispose();
  }
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        widget.createUserId != null? null: getConversations();
        newCon = [];
        openRecord();
      });
    });

    DatabaseHelper.getUserData().then((value) {
      setState(() {
        userId = value;

        widget.createUserId != null ? {
          check(userId!, widget.createUserId!),

        } : getConversations();

        if(widget.conId != null){
          coid = widget.conId;
          print(coid!);
          if(coid == widget.conId){
            hellp = true;
          }
        }
      });
    });
    inChat = true;
    foundMessage = false;
    FirebaseMessaging.onMessage.listen(onMessageNotification3);
    _controller.addListener(_loadMore);

    print(widget.idd.toString()+ 'ggggggggggggggggggggggggggggggggggggggggggggggggg');
    super.initState();
  }

  void _loadMore() async {

    print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false && _controller.position.maxScrollExtent ==
        _controller.offset ) {

      setState(() {
        foundMessage = false;
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;
      try {
        final res =
        await http.get(Uri.parse('$_baseUrl${widget.conId}?page=$_page'), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });

        if (ChatRoomModel
            .fromJson(jsonDecode(res.body))
            .data != null) {
          setState(() {
            _posts = ChatRoomModel
                .fromJson(jsonDecode(res.body))
                .data!;
            for (int i = 0;
            i <
                ChatRoomModel
                    .fromJson(jsonDecode(res.body))
                    .data!
                    .messages!
                    .length;
            i++) {
              if (ChatRoomModel
                  .fromJson(jsonDecode(res.body))
                  .data!
                  .messages![i]
                  .messageType ==
                  'voice') {
                AudioPlayer ap = AudioPlayer();
                ap.setSourceUrl(ChatRoomModel
                    .fromJson(jsonDecode(res.body))
                    .data!
                    .messages![i]
                    .body!);
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

  void onMessageNotification3(RemoteMessage message)  async{
    widget.idd != null? {
      print('***-------------********in chat celebraty *****-------------*****************-----------***'),
      print(message.data['type']),
      print( message.data['body'].contains(name!)),
      if (message != null ) {
        // listwidget!.addAll(newCon!);
        temp!.addAll(newCon!.reversed),
        temp!.addAll(listwidget!),

        listwidget = [],
        newCon = [],
        _page = 1,
        getConversations(),

        // helper == 1 ? boolHelp = true: null;
        // checkCon != null? {
        //   if (checkCon!.check == true) {
        //     widget.conId = checkCon!.conversation!.id!,
        //     widget.createUserId = null,
        //     helper < 1 ? {
        //       getConversations(),
        //       refresh(),} : null,
        //   }
        // }: null;
        // widget.createUserId != null ? null : {
        //   helper < 2 ? {
        //     refresh(),
        //     helper++,
        //     print(listwidget!.length.toString() + ' at first')
        //   } : null};
      },
    }:null;
    // print('foundMessage is:--------------------------'+ message.data['body'].contains(name!));
    // var android = const AndroidNotificationDetails(
    //     'channel_id', 'channelName', 'channelDescription');
    // var ios = const IOSNotificationDetails();
    // var platform = NotificationDetails(iOS: ios, android: android);
    String nid = message.data['body'];
    // widget.idd != null ? {
    //   !nid.contains(name!) ?{
    //     await flutterLocalNotificationsPlugin.show(
    //         0, message.data['body'], message.data['body'], platform)}:null
    // } : null;


  }

  void refresh() {
    widget.createUserId != null? null:{
      _isFirstLoadRunning
          ? null
          : {
        for (int i = 0; i < _posts!.messages!.length; i++)
          {
            if ((_posts!.messages![i].sender!.id == userId))
              {
                if (_posts!.messages![i].messageType == 'image')
                  {
                    if( numberOfnNotRead! >= (i + 1)){
                      listwidget!.add(image2(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10),sent)),
                    }else{
                      listwidget!.add(image2(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10),Icons.done_all_sharp)),
                    }
                  }
                else
                  {
                    if (_posts!.messages![i].messageType == 'video')
                      {
                        vl!.putIfAbsent(i, () => VideoPlayerController.network(_posts!.messages![i].body!)),
                        if( numberOfnNotRead! >= (i + 1)){
                          listwidget!.add(video(_posts!.messages![i].body,_posts!.messages![i].date!.substring(10), sent,thumbnail: _posts!.messages![i].thumbnail)),
                        }else{
                          listwidget!.add(video(_posts!.messages![i].body,_posts!.messages![i].date!.substring(10), Icons.done_all_sharp,thumbnail: _posts!.messages![i].thumbnail)),


                        }
                      }
                    else
                      {
                        if (_posts!.messages![i].messageType == 'document')
                          {

                            if( numberOfnNotRead! >= (i + 1)){
                              listwidget!
                                  .add(document(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10) ,sent)),
                            }else{
                              listwidget!
                                  .add(document(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10) ,Icons.done_all_sharp)),


                            }

                          }
                        else
                          {
                            if (_posts!.messages![i].messageType == 'voice')
                              {
                                //players[i]!.pause(),
                                // player.setSourceUrl(url),

                                if( numberOfnNotRead! >= (i + 1)){
                                  listwidget!.add(voiceRecord(players[i]!,
                                      _posts!.messages![i].body!, _posts!.messages![i].date!.substring(10),sent)),
                                }else{
                                  listwidget!.add(voiceRecord(players[i]!,
                                      _posts!.messages![i].body!, _posts!.messages![i].date!.substring(10),Icons.done_all_sharp)),


                                }

                              }
                            else
                              {
                                if( numberOfnNotRead! >= (i + 1)){
                                  listwidget!.add(container(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10), sent)),
                                }else{
                                  listwidget!.add(container(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10), Icons.done_all_sharp)),


                                }
                              }
                          }
                      }
                  }
              }
            else
              {
                if (_posts!.messages![i].messageType == 'image')
                  {
                    listwidget!.add(image2(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10),sent)),
                  }
                else
                  {
                    if (_posts!.messages![i].messageType == 'video')
                      {

                        listwidget!.add(video(_posts!.messages![i].body,_posts!.messages![i].date!.substring(10), sent,thumbnail: _posts!.messages![i].thumbnail)),
                      }
                    else
                      {
                        if (_posts!.messages![i].messageType == 'document')
                          {
                            listwidget!
                                .add(document(_posts!.messages![i].body, _posts!.messages![i].date!.substring(10),sent)),
                          }
                        else
                          {
                            if (_posts!.messages![i].messageType == 'voice')
                              {
                                //players[i]!.pause(),
                                // player.setSourceUrl(url),
                                listwidget!.add(voiceRecord(players[i]!,
                                    _posts!.messages![i].body!, _posts!.messages![i].date!.substring(10),sent)),
                              }
                            else
                              {
                                listwidget!.add(containerUser(
                                    _posts!.messages![i].body, _posts!.messages![i].date!.substring(10))),
                              }
                          }
                      }
                  }
              }
          },
        temp =[]
      }};
  }

  Future openRecord() async {
    await Permission.microphone.status;
    await Permission.microphone.request();
  }

  Future startplay() async {
    await record.openRecorder();
    await record.setSubscriptionDuration(Duration(milliseconds: 500));
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final folderName = "$path/assets/audio/audio";
    final path2 = Directory(folderName);
    if ((await path2.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      path2.create(recursive: true);
    } // .wav .aac .m4
    tempDir = await getExternalStorageDirectory();
    setState(() {
      pathToRecord = "${tempDir!.path}/${DateTime.now().millisecondsSinceEpoch.toString()}";
    });
    await record.startRecorder(toFile: pathToRecord);
  }

  Future stop() async {
    newPath = await record.stopRecorder();
    final path2 = await record.stopRecorder();
    setState(() {
      image = File(newPath!);
    });
    print('the path = ' + newPath! +
        '================================================================================================');

    // String p = tempDir!.path;
    // final String fileName = Path.basename(path2!);
    // File newImage = await audioPath!.copy('$p/$fileName');
    setState(() {
      //image = newImage;
      final au = AudioPlayer();
      au.setSourceDeviceFile(newPath!);
      widget.createUserId != null? {

        isFirstTime ? {
          setState(() {
            newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),sending, hint: true));
            createConversation(widget.createUserId!, userToken!, 'voice', newPath!).then((value) => {
              value == 'SocketException'?
              {
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: true));
                })
              }:
              {
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: true));
                })
              }
            });
            isFirstTime = false;
          })
          //newCon!.add(voiceRecord2()),
        } : {
          setState(() {
            newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),sending, hint: true));
            createConversation(widget.createUserId!, userToken!, 'voice', newPath!).then((value) => {
              value == 'SocketException'?
              {
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: true));
                })
              }:
              {
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: true));
                })
              }
            });
            isFirstTime = false;
          })
          //newCon!.add(voiceRecord2()),
        }
        //saveInStorage(Path.basename(newPath!), image!, '.wav');
      }:{
        newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),sending, hint: true)),
        setState((){uploadRecord().then((value) => {
          print(value+ '----------------------------'),
          value == 'SocketException'?
          {
            setState(() {
              newCon!.removeLast();
              newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: true));
            })
          }:
          {
            setState(() {
              newCon!.removeLast();
              newCon!.add(voiceRecord(au, newPath!,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: true));
            })
          }
        });}),

      };
    });
    await record.closeRecorder();
  }

  void addtolist(String tt) {
    setState(() {
      //listwidget!.add(container(m.text));
      //newCon!.add(container(m.text, dt.DateFormat('hh:mm a').format(DateTime.now())));
      added = true;
    });
  }

  void addtolist2(String tt) {
    setState(() {
      listwidget!.add(image2(tt,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
      added = true;
    });
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    foundMessage? {
      listwidget!.clear(),
      refresh(),}:null;

    print(inChat.toString()+ '============================');
    helper == 1 ? boolHelp = true: null;
    checkCon != null? {
      if (checkCon!.check == true) {
        widget.conId = checkCon!.conversation!.id!,
        widget.createUserId = null,
        helper < 1 ? {
          getConversations(),
          refresh(),} : null,
      }
    }: null;
    widget.createUserId != null?
    null: {
      helper < 2
          ? {
        refresh(),
        helper++,
        print(listwidget!.length.toString() + ' at first')
      }
          : null,
    };

    return GestureDetector(
      onTap: () {
        unfocus();
        setState(() {
          isWritting = false;
          image != null ? print(image!.path) : null;
        });
      },
      child: (_isFirstLoadRunning && !foundMessage) || (checkCon == null && widget.conId == null)
          ? Scaffold(
          body: Center(
            child: mainLoad(context),
          ))
          : Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
              itemBuilder: (contextt) => [
                PopupMenuItem(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ContactWithUsHome(),));

                      },
                      child: Center(
                          child: text(context, 'الابلاغ عن المستخدم', textSubHeadSize.sp, black)),
                    )),
                PopupMenuItem(
                  child:
                  InkWell(
                      onTap: (){
                        setState(() {
                          _posts!.isBlocked!? deleteBlock(_posts!.ban!.id): addToBlock();
                          Navigator.pop(contextt);
                          getConversations();
                          getConversations();
                        });

                        print('hi');
                        // flushBar(context, 'تم', "تم حظر المستخدم", done);
                      },
                      child: Container(height : 50.h,width: 150.w,child:Center(child: text(context, _posts!.isBlocked!?'رفع الحظر ':'حظر', textSubHeadSize.sp, black)))),
                ),

              ],
            ),
          ],
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                text(context, widget.createName != null? widget.createName!: name!, textSubHeadSize, white),
                SizedBox(
                  width: 10.w,
                ),
                CircleAvatar(
                    backgroundColor: white,
                    radius: 25.r,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70.r),
                      child: CachedNetworkImage(
                        imageUrl: widget.createImage != null? widget.createImage!: senderImage!,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                        // errorBuilder: (context, exception, stackTrace) {
                        //   return Icon(Icons.error, size: 15.h, color: red,);},
                      ),
                    ))
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: purple,
          elevation: 0,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: (_isFirstLoadRunning && !foundMessage)
              ? Center(
            child: mainLoad(context),
          )
              : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView(
                      shrinkWrap: true,
                      controller: _controller,
                      reverse: true,
                      physics: ScrollPhysics(),
                      children:
                      temp!.isNotEmpty? temp!.toList(): widget.createUserId != null?newCon!.reversed.toList(): newCon!.reversed.toList() + listwidget!,
                    ),
                  ),
                ),
                _posts != null && _posts!.isBlocked!? Container(
                  margin: EdgeInsets.only(bottom: 15.h, top: 10.h),
                  width: 300.w,decoration: BoxDecoration(color: deepBlack.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(80.r)),height: 30.h,child: text(context, '   لقد قمت بحظرالمستخدم', 15, deepBlack, align: TextAlign.center),) : Padding(
                  padding:
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? EdgeInsets.only(bottom: 0.h)
                      : EdgeInsets.only(bottom: 0.h),
                  child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: grey!, width: 1))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                GestureDetector(
                                  child: isWritting
                                      ? SizedBox(
                                    width: 1.w,
                                  )
                                      : CircleAvatar(
                                      backgroundColor: isPressed
                                          ? fillWhite
                                          : null,
                                      child: Container(
                                        height: 50.h,
                                        width: 50.w,
                                        decoration:
                                        BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                30),
                                            gradient: !isPressed
                                                ? const LinearGradient(
                                              begin: Alignment(
                                                  0.7,
                                                  2.0),
                                              end: Alignment(
                                                  -0.69,
                                                  -1.0),
                                              colors: [
                                                Color(
                                                    0xff0ab3d0),
                                                Color(
                                                    0xffe468ca)
                                              ],
                                              stops: [
                                                0.0,
                                                1.0
                                              ],
                                            )
                                                : const LinearGradient(
                                              colors: [
                                                white,
                                                white
                                              ],
                                            )),
                                        child: !isPressed
                                            ? Icon(
                                          voiceIcon,
                                          color: white,
                                          size: isPressed
                                              ? 30
                                              : 25,
                                        )
                                            : GradientIcon(
                                          voiceIcon,
                                          30,
                                          const LinearGradient(
                                            begin:
                                            Alignment(
                                                0.2,
                                                3.0),
                                            end:
                                            Alignment(
                                                -0.69,
                                                -1.0),
                                            colors: [
                                              Color(
                                                  0xff0ab3d0),
                                              Color(
                                                  0xffe468ca)
                                            ],
                                            stops: [
                                              0.0,
                                              1.0
                                            ],
                                          ),
                                        ),
                                      )),
                                  onLongPress: () async {
                                    setState(() {
                                      isPressed = true;
                                    });
                                    startplay();
                                  },
                                  onLongPressUp: () async {
                                    setState(() {
                                      isPressed = false;
                                    });
                                    stop();
                                  },
                                ),
                                isWritting
                                    ? SizedBox(
                                  width: 1.w,
                                )
                                    : SizedBox(
                                  width: 15.w,
                                ),
                                isWritting
                                    ? Container(
                                  margin: isWritting
                                      ? EdgeInsets.only(
                                      right: 20.w)
                                      : EdgeInsets.only(
                                      right: 15.w),
                                  child: InkWell(
                                    onTap: () {
                                      FocusManager.instance
                                          .primaryFocus
                                          ?.unfocus();
                                      widget.createUserId != null?
                                      setState((){
                                        newCon!.add(container(m.text,dt.DateFormat('hh:mm a').format(DateTime.now()), sending));
                                        var text = m.text;
                                        var date = dt.DateFormat('hh:mm a').format(DateTime.now());
                                        isFirstTime? {
                                          createConversation(widget.createUserId!, userToken!, 'text', m.text).then((value) => {
                                            setState(() {
                                              newCon!.removeLast();
                                              value == 'SocketException'?
                                              newCon!.add(container(text,dt.DateFormat('hh:mm a').format(DateTime.now()), failure)):
                                              newCon!.add(container(text,dt.DateFormat('hh:mm a').format(DateTime.now()), sent));
                                            })
                                          }),
                                          isFirstTime = false
                                        }:{
                                          createConversation(
                                              widget
                                                  .createUserId!,
                                              userToken!,
                                              'text',
                                              m.text).then((value) => {
                                            setState(() {
                                              newCon!.removeLast();
                                              value == 'SocketException'?
                                              newCon!.add(container(text,dt.DateFormat('hh:mm a').format(DateTime.now()), failure)):
                                              newCon!.add(container(text,dt.DateFormat('hh:mm a').format(DateTime.now()), sent));
                                            })
                                          })
                                        };
                                        isWritting = false;
                                        m.clear();
                                      })
                                          :{
                                        setState(() {
                                          newCon!.add(container(m.text,dt.DateFormat('hh:mm a').format(DateTime.now()), sending));
                                          var text = m.text;
                                          var date = dt.DateFormat('hh:mm a').format(DateTime.now());
                                          addMessage2(
                                              userToken!,
                                              'text',
                                              m.text).then((value) => {
                                            setState(() {
                                              newCon!.removeLast();
                                              print(value.toString() + '----------------------------------------');
                                              value == 'SocketException'?
                                              newCon!.add(container(text,dt.DateFormat('hh:mm a').format(DateTime.now()), failure)):
                                              newCon!.add(container(text,dt.DateFormat('hh:mm a').format(DateTime.now()), sent));
                                            })
                                          });
                                          addtolist(m.text);
                                          isWritting = false;
                                          m.clear();
                                        }),
                                        print(listwidget!.length
                                            .toString() +
                                            ' after add')
                                      };
                                    },
                                    child: GradientIcon(
                                      send,
                                      30,
                                      const LinearGradient(
                                        begin: Alignment(
                                            0.7, 2.0),
                                        end: Alignment(
                                            -0.69, -1.0),
                                        colors: [
                                          Color(0xff0ab3d0),
                                          Color(0xffe468ca)
                                        ],
                                        stops: [0.0, 1.0],
                                      ),
                                    ),
                                  ),
                                )
                                    : SizedBox(
                                  width: 0.w,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                isPressed
                                    ? Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment:
                                    Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        left: 20.w),
                                    child: StreamBuilder<
                                        RecordingDisposition>(
                                      stream:
                                      record.onProgress,
                                      builder: (context,
                                          snapshot) {
                                        return text(
                                            context,
                                            snapshot.hasData
                                                ? '${snapshot.data!.duration.inSeconds} : ${snapshot.data!.duration.inMinutes}'
                                                : 0.toString(),
                                            17,
                                            black);
                                      },
                                    ),
                                  ),
                                )
                                    : Expanded(
                                  flex: 7,
                                  child: Container(
                                    height: 45.h,
                                    margin: EdgeInsets.only(
                                        top: 10.h,
                                        bottom: 10.h,
                                        left: 5.w),
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
                                            10.w),
                                       hintStyle: TextStyle(fontSize: textTitleSize),
                                        hintText:
                                        'اكتب هنا .....',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isWritting || isPressed
                              ? SizedBox(
                            width: 1.w,
                          )
                              : InkWell(
                            child: Icon(
                              add,
                              color: grey,
                            ),
                            onTap: () {
                              showBottomSheett2(context,
                                  BottomSheetMenue(context));
                            },
                          )
                        ]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget container(textt,time, icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: textt.length < 13? 120.w:textt.length * 8.0,
          margin: EdgeInsets.only(top: 10, bottom: 5, left: 3, right: 5),
          decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.topRight,
                    child:  text( context,textt , textSubHeadSize,  white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Icon(icon, color: white,size: 15,)),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(time, style: TextStyle(color: white, fontSize: 13.sp),)),
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
          width: textt.length < 13? 100.w:textt.length * 8.0,
          margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 2),
          decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child:  text( context,textt , textSubHeadSize,  white)),
                Container(
                    alignment: Alignment.bottomRight,
                    child: Text(time, style: TextStyle(color: white, fontSize: 13.sp),textAlign: TextAlign.start,)),
              ],
            ),
          ),
        ),
      ],
    );
  }
  ///Open file
  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;
    loadingDialogue(context);
    final file = await downloadFile(url, name);
    Navigator.pop(context);

    if(file == null) return;

    print('Path IS: ${file.path}');

    OpenFile.open(file.path);

  }
  ///Download file into private folder not visible to user
  Future<File>? downloadFile(String url, String name) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try{
      final response = await Dio().get(
          url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0
          )
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    }catch(e){
      return file;

    }
  }

  Widget document(String? text2, time,icon,{hint}) {
    String ttt = text2!.replaceAll(
        'https://mobile.celebrityads.net/storage/images/messages/', '');
    return InkWell(
      onTap:
          () {
        print('text2 is: $text2');
        openFile(url: text2);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50.h,
            width: 300.w,
            margin: EdgeInsets.only(top: 10, bottom: 2, left: 3, right: 5),
            decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                child: Container(
                  height: 55.h,
                  width: 255.w,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.description,
                          color: deepBlack,
                          size: 35.h,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      ttt.length >= 20
                          ? text(
                        context,
                        '....' + ttt.substring(0, 20),
                        18,
                        black,
                      )
                          : text(
                        context,
                        ttt,
                        18,
                        black,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 300.w,
            height: 20.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding:  EdgeInsets.only(right: 8.0.w, bottom: 5.h),
                    child:  Icon(icon, color: purple,size: 20,)
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 5.0.w, bottom: 5.h),
                  child: Text(time, style: TextStyle(color: black, fontSize: 13.sp),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }




  static Future saveInStorage(String fileName, File file, String extension) async {
    String _localPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    String filePath =
        _localPath + "/" + fileName.trim();

    File fileDef = File(filePath);
    await fileDef.create(recursive: true);
    Uint8List bytes = await file.readAsBytes();
    await fileDef.writeAsBytes(bytes);
  }
  Widget voiceRecord2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50.h,
          width: 300.w,
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 5),
          decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10)),
              child: Container(
                height: 55.h,
                width: 255.w,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                  onTap: () async {



                                  },
                                  child:Icon(
                                    playViduo,
                                    color: deepBlack,
                                    size: 35.h,
                                  )
                              ),
                            ),
                            Container(
                              width: 200.w,
                              child: Slider(
                                value:  0.00,
                                min: 0.00,
                                max:  0.00,
                                onChanged: (double val) {

                                },
                              ),
                            ),
                            text(
                                context,
                                '0:00',
                                15,
                                black),
                          ],
                        )


                      ],
                    )
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
        )

      ],
    );
  }

  Widget voiceRecord(AudioPlayer ap, ur,time,icon,{hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<ss.PlayerState>(
            stream: ap.onPlayerStateChanged,
            builder: (context, an) {
              return Container(
                height: 50.h,
                width: 300.w,
                margin: EdgeInsets.only(top: 10, bottom: 2, left: 3, right: 5),
                decoration: BoxDecoration(
                    color: purple,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    child: Container(
                      height: 55.h,
                      width: 255.w,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            StreamBuilder<Duration>(
                              stream: ap.onPositionChanged,
                              builder: (context, snapshot) {


                                String two(int n) => '0'+n.toString().padLeft(1);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    StreamBuilder<Duration>(
                                        stream: ap.onDurationChanged,
                                        builder: (context, snap) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 16.w,),
                                              Padding(
                                                padding: EdgeInsets.only(right: 0.0.w),
                                                child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      snapshot.hasData && snap.hasData?
                                                      snap.data!.inSeconds == snapshot.data!.inSeconds? {
                                                        hint != null?{
                                                          ap.play(DeviceFileSource(ur)),
                                                          ap.setVolume(0.5),}
                                                            :{
                                                          ap.play(UrlSource(ur)),
                                                          ap.setVolume(0.5),
                                                          print(ap.state.name
                                                              .toString() +
                                                              '========================================****================================================'),}
                                                      }: null:null;
                                                      isPlaying = !isPlaying;
                                                      isPlaying
                                                          ? {
                                                        hint != null?{
                                                          ap.play(DeviceFileSource(ur)),
                                                          ap.setVolume(0.5),}
                                                            :{
                                                          ap.play(UrlSource(ur)),
                                                          ap.setVolume(0.5),
                                                          print(ap.state.name
                                                              .toString() +
                                                              '==========================================******=============================================='),}
                                                      }
                                                          : {
                                                        ap.pause(),
                                                        ap.setSourceUrl(url),
                                                        print(ap.state.toString() +
                                                            '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
                                                      };
                                                    });
                                                  },
                                                  child: an.hasData && (an.data!.name == 'playing' && ap.state.name == 'playing') && snap.data!.inSeconds != snapshot.data!.inSeconds
                                                      ? Icon(
                                                    Icons.pause,
                                                    color: deepBlack,
                                                    size: 35.h,
                                                  )
                                                      : Icon(
                                                    playVideo,
                                                    color: deepBlack,
                                                    size: 35.h,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 190.w,
                                                child: Slider(
                                                  value: snapshot.hasData
                                                      ? snapshot.data!.inSeconds
                                                      .toDouble()
                                                      : 0.00,
                                                  min: 0.00,
                                                  max: snap.hasData ? snap.data!
                                                      .inSeconds.toDouble() : 0.00,
                                                  onChanged: (double val) {
                                                    setState(() {
                                                      final pp = Duration(seconds: val.toInt());
                                                      ap.seek(pp);
                                                    });
                                                  },
                                                ),
                                              ),
                                              text(
                                                  context,
                                                  snapshot.hasData
                                                      ? '${two(
                                                      snapshot.data!.inSeconds
                                                          .remainder(60))} : ${two(
                                                      snapshot.data!.inMinutes
                                                          .remainder(60))}'
                                                      : snap.hasData ? '${two(
                                                      snap.data!.inSeconds.remainder(
                                                          60))} : ${two(
                                                      snap.data!.inMinutes.remainder(
                                                          60))}' : '0:00',
                                                  15,
                                                  black),
                                              SizedBox(width: 5.w,),
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
                ),
              );
            }
        ),
        Container(
          width: 300.w,
          height: 25.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding:  EdgeInsets.only(right:8.0.w, bottom: 5.h),
                  child:  Icon(icon, color: purple,size: 20,)
              ),
              Padding(
                padding:  EdgeInsets.only(left: 5.0.w, bottom: 5.h),
                child: Text(time, style: TextStyle(color: black, fontSize: 13.sp),),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget image2(text,time,icon,{hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            hint != null?
            showDialog(
                context: context,
                builder: (contextt) {
                  return Expanded(
                    child: Container(
                      color: black,
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: CachedNetworkImage(imageUrl:text!,
                                placeholder: (context, ee){
                                  return Container(color: lightGrey.withOpacity(0.10),);
                                },)),
                        ],
                      ),
                    ),
                  );
                })
                :
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder:
                        (context) =>
                        DownloadImages(
                          image:
                          text,
                        )));
          },
          child: Column(

            children: [
              Container(
                height: 350.h,
                width: 300.w,
                margin: EdgeInsets.only(top: 10, bottom: 2, left: 3, right: 5),
                decoration: BoxDecoration(
                    color: purple,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      child: hint != null? Image.file(
                        image!,
                        fit: BoxFit.fill,

                      ) : !isConnectSection?  Icon(Icons.error, size: 30.h, color: red,):CachedNetworkImage(
                        imageUrl:text,
                        fit: BoxFit.cover,
                        placeholder: (context, loadingProgress) {
                          return Center(
                              child: Container(
                                  color: white,
                                  height: double.infinity.h,
                                  width: 350.w,
                                  child: Container(color: lightGrey.withOpacity(0.10),)));
                        },
                        errorWidget: (context, exception, stackTrace) {
                          return Icon(Icons.error, size: 30.h, color: red,);},
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 300.w,
                height: 22,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding:  EdgeInsets.only(right: 8.0.w, bottom: 5.h),
                        child:  Icon(icon, color: purple,size: 20,)
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 5.0.w, bottom: 5.h),
                      child: Text(time, style: TextStyle(color: black, fontSize: 13.sp),),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  video(text, time, icon,{thumbnail})  {
    // int? k;
    // VideoPlayerController? vv;
    // vl!.forEach((key, value) {
    //   if(value.dataSource == text){
    //     k= key!;
    //   }
    // });
    // vl![k] ==null?
    //     {  vv = VideoPlayerController.network(text),
    // vv..initialize()}:null;
    return InkWell(
      onTap: (){

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    viewData(
                      video: text ,
                      private: true, token: userToken!, videoLikes: 0,
                      thumbnail: thumbnail,
                    )));},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 350.h,
                width: 300.w,
                margin: EdgeInsets.only(top: 10, bottom: 2, left: 3, right: 5),
                decoration: BoxDecoration(
                    color: purple,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      child: SizedBox(child:thumbnail != null? CachedNetworkImage(imageUrl: thumbnail, fit: BoxFit.cover): VideoPlayer(VideoPlayerController.file(image!)..initialize()),height: double.infinity, width: double.infinity,),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                  backgroundColor: black.withOpacity(0.40),
                  radius: 40.r,
                  child: Icon(
                    playVideo,
                    color: white,
                    size: 60.h,
                  ))
            ],
          ),
          Container(
            width: 300.w,
            height: 20.h,
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding:  EdgeInsets.only(right: 5.0.w, bottom: 5.h),
                    child:  Icon(icon, color: purple,size: 20,)
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 5.0.w, bottom: 5.h),
                  child: Text(time, style: TextStyle(color: black, fontSize: 12.sp),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  unfocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Widget BottomSheetMenue(context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 20.h,
        ),
        InkWell(
          child: SizedBox(
            height: 25.h,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(
                width: 20.h,
              ),
              text(context, 'الكاميرا', 18, black),
              SizedBox(
                width: 10.h,
              ),
              Container(
                  margin: EdgeInsets.only(right: 10.w),
                  child: Icon(cam, color: purple,size: 30.r,)),
            ]),
          ),
          onTap: () {
            Navigator.pop(context);
            getImageCamra(context);

          },
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(
          color: darkWhite,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 25.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 20.h,
              ),
              InkWell(
                onTap: () {
                  getImage(context);
                  Navigator.pop(context);
                },
                child: Container(
                    width: 200.w,
                    child: text(context, 'مكتبة الصور والفيديوهات', 18, black)),
              ),
              SizedBox(
                width: 10.h,
              ),
              Container(
                  margin: EdgeInsets.only(right: 10.w),
                  child: Icon(imageIcon, color: purple,size: 30.r,)),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(color: darkWhite),
        SizedBox(
          height: 10.h,
        ),
        Container(
          alignment: Alignment.centerRight,
          height: 25.h,
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 30.h,
                ),
                text(context, 'مستند', 18, black),
                SizedBox(
                  width: 20.h,
                ),
                Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: Icon(
                        discountDes,
                        color: purple,
                        size: 30.r
                    )),
              ],
            ),
            onTap: () {
              getDocument(context);
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );
  }

  void getConversations() async {
    if(mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    try {
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
          numberOfnNotRead = ChatRoomModel.fromJson(jsonDecode(response.body)).data!.conversation!.countNotReadAnotherUser;
          theId = ChatRoomModel.fromJson(jsonDecode(response.body))
              .data!
              .conversation!
              .secoundUser!
              .id;
          userId != ChatRoomModel.fromJson(jsonDecode(response.body))
              .data!
              .conversation!
              .secoundUser!.id?
          name = ChatRoomModel.fromJson(jsonDecode(response.body))
              .data!
              .conversation!
              .secoundUser!
              .name: name = ChatRoomModel.fromJson(jsonDecode(response.body))
              .data!
              .conversation!
              .user!
              .name;

          userId != ChatRoomModel.fromJson(jsonDecode(response.body))
              .data!
              .conversation!
              .secoundUser!.id?{
            senderImage = ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .conversation!
                .secoundUser!
                .image,
            userIdBan =ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .conversation!
                .secoundUser!.id
          }:{  senderImage = ChatRoomModel.fromJson(jsonDecode(response.body))
              .data!
              .conversation!
              .user!
              .image,
            userIdBan =ChatRoomModel.fromJson(jsonDecode(response.body))
                .data!
                .conversation!
                .user!.id};

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
              ap.setSourceUrl(ChatRoomModel.fromJson(jsonDecode(response.body))
                  .data!
                  .messages![i]
                  .body!);
              players.putIfAbsent(i, () => ap);
            }
          }
          theName= name!;
        });
        print(jsonDecode(response.body).toString() +
            '=======================================================================');
        setState(() {
          isReady = true;
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
        setState(() {
          timeoutException = false;
        });
        return Future.error('TimeoutException');
      } else {
        setState(() {
          serverExceptions = false;
        });
        return Future.error('serverExceptions');
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<String> addMessage(String token, String type, body) async {
    var multipartFile;
    try {
      var stream =
      new http.ByteStream(DelegatingStream.typed(image!.openRead()));
      // get file length
      var length = await image!.length();
      var uri = Uri.parse("https://mobile.celebrityads.net/api/celebrity/message");

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      };

      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      type == 'image' ||
          type == 'video' ||
          type == 'document' || type == 'voice'
          ? multipartFile = http.MultipartFile('body', stream, length,
          filename: Path.basename(image!.path))
          : null;
      // listen for response
      type == 'image' ||
          type == 'video' ||
          type == 'document' ||
          type == 'voice'
          ? request.files.add(multipartFile)
          : request.fields["body"] = body;
      request.headers.addAll(headers);
      request.fields["conversation_id"] = widget.conId.toString();
      request.fields["message_type"] = type;

      var response = await request.send();
      http.Response respo = await http.Response.fromStream(response);

      print(respo.body.toString());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        // print(response.body+ '=========================================================================================================================================================');
        return jsonDecode(respo.body)['success'].toString();
      }else{ throw Exception('Failed to load activity');}
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

  Future<String> uploadRecord() async {
    try {
      Uri url = Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/message');

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };

      final request = http.MultipartRequest('POST', url);
      var multipartFile = await http.MultipartFile.fromPath('body', newPath!,
        filename: Path.basename(newPath! + '.wav'),);

      request.files.add(multipartFile);
      request.fields["conversation_id"] = widget.conId.toString();
      request.fields["message_type"] = 'voice';
      request.headers.addAll(headers);


      final response = await request.send();
      final responseStr = await response.stream.bytesToString();

      print(responseStr);
      return responseStr;
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

  Future<String> addMessage2(String token, type, body) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/message',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          "body": body,
          "conversation_id": widget.conId,
          "message_type": type,
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
        throw Exception('Failed to load activity');
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }


  void addToBlock() async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/black-list/ban',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userIdBan != null? userIdBan! : widget.createUserId,
          "ban_reson_id": 2,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        print(response.body +
            '=========================================================================================================================================================');
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (e) {
      print(e);
    }
  }
  Future<http.Response> deleteBlock(id) async {
    final http.Response response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/celebrity/black-list/unban/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken'
      },
    );

    print(response.body);
    return response;
  }
  Future<String> createConversation(int userId, String token, String type, String body) async {

    if(type == 'text') {
      Map<String, dynamic> data = {
        "user_id": '$userId',
        "message_type": type,
        "body": body,};
      String url =
          "https://mobile.celebrityads.net/api/celebrity/conversation/create";
      try {
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

        }else{ throw Exception('Failed to load activity');}
      } catch (e) {
        if (e is SocketException) {
          return 'SocketException';
        } else if (e is TimeoutException) {
          return 'TimeoutException';
        } else {
          return 'serverException';
        }
      }
    }
    if(type == 'image' || type == 'video' || type == 'document'){
      var multipartFile;
      try {
        var stream =
        new http.ByteStream(DelegatingStream.typed(image!.openRead()));
        // get file length
        var length = await image!.length();
        var uri = Uri.parse("https://mobile.celebrityads.net/api/celebrity/conversation/create");

        Map<String, String> headers = {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        };

        var request = http.MultipartRequest("POST", uri);

        multipartFile = http.MultipartFile('body', stream, length,
            filename: Path.basename(image!.path));

        request.files.add(multipartFile);
        request.headers.addAll(headers);
        request.fields["user_id"] = widget.createUserId.toString();
        request.fields["message_type"] = type;

        var response = await request.send();
        http.Response respo = await http.Response.fromStream(response);

        print(respo.body.toString());
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.

          // print(response.body+ '=========================================================================================================================================================');
          return jsonDecode(respo.body)['success'].toString();
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load activity');
        }
      } catch (e) {
        if (e is SocketException) {
          return 'SocketException';
        } else if (e is TimeoutException) {
          return 'TimeoutException';
        } else {
          return 'serverException';
        }
      }
    }
    if(type == 'voice'){
      try {
        Uri url = Uri.parse(
            'https://mobile.celebrityads.net/api/celebrity/conversation/create');

        Map<String, String> headers = {
          "Accept": "application/json",
          "Authorization": "Bearer $userToken"
        };

        final request = http.MultipartRequest('POST', url);
        var multipartFile = await http.MultipartFile.fromPath('body', newPath!,
          filename: Path.basename(newPath! + '.wav'),);

        request.files.add(multipartFile);
        request.fields["user_id"] = widget.createUserId.toString();
        request.fields["message_type"] = 'voice';
        request.headers.addAll(headers);


        final response = await request.send();
        final responseStr = await response.stream.bytesToString();
        print(responseStr);
        return responseStr;
      }catch(e) {
        if (e is SocketException) {
          return 'SocketException';
        } else if (e is TimeoutException) {
          return 'TimeoutException';
        } else {
          return 'serverException';
        }
      }
    }

    return '';
  }

  Future<File?> getImage(context) async {
    FilePickerResult? pickedFile =
    await FilePicker.platform.pickFiles(type: FileType.any);
    // PickedFile? pickedFile =
    // await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.paths[0]!);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.paths[0]!);
    final String fileExtension = Path.extension(fileName);
    File newImage = await file.copy('$path/$fileName');
    if (fileExtension == ".png" ||
        fileExtension == ".jpg" ||
        fileExtension == ".mp4") {
      setState(() {
        image = newImage;
        // Navigator.of(context).pop();
        fileExtension == ".mp4"
            ? {
          widget.createUserId != null ? isFirstTime ? {
            setState((){
              newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending));
              createConversation(
                  widget.createUserId!, userToken!, 'video', image!.path).then((value) => {
                setState((){
                  value == 'SocketException'? {
                    setState(() {
                      newCon!.removeLast();
                      newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure));
                    })

                  }:{
                    setState(() {
                      newCon!.removeLast();
                      newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
                    })

                  };
                })
              });
              isFirstTime = false;
            })
          } : {  setState((){
            newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending));
            createConversation(
                widget.createUserId!, userToken!, 'video', image!.path).then((value) => {
              setState((){
                value == 'SocketException'? {
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure));
                  })

                }:{
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
                  })

                };
              })
            });
            isFirstTime = false;
          })}:
          {
            setState(() {
              newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending));
              addMessage(userToken!, 'video', image).then((value) => {
                print(value+ '--------------------------------------------'),
                value == 'SocketException'? {
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure));
                  })

                }:{
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
                  })

                }
              });
            })
          },

        } :
        {

          widget.createUserId != null? isFirstTime ? {
            setState((){
              newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending, hint: 'hint'));
              createConversation(widget.createUserId!, userToken!, 'image', image!.path).then((value) => {
                setState((){
                  value == 'SocketException'? {
                    setState(() {
                      newCon!.removeLast();
                      newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: 'hint'));
                    })
                  }:{
                    setState(() {
                      newCon!.removeLast();
                      newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                    })
                  };
                })
              });
              isFirstTime = false;
            })

          } :{setState((){
            newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending, hint: 'hint'));
            createConversation(widget.createUserId!, userToken!, 'image', image!.path).then((value) => {
              setState((){
                value == 'SocketException'? {
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: 'hint'));
                  })

                }:{
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                  })

                };
              })
            });
            isFirstTime = false;
          })} :{
            setState(() {
              newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending, hint: 'hint'));
              addMessage(userToken!, 'image', image).then((value) => {
                value == 'SocketException'? {
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: 'hint'));
                  })
                }:{
                  setState(() {
                    newCon!.removeLast();
                    newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                  })

                }
              });
            })
          }




        };
        //addtolist2(image!.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("امتداد الصورة المسموح به jpg, png",
            style: TextStyle(color: Colors.red)),
      ));
    }
  }

  updateRecording(){
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  showCameraImage(File image){
    showDialog(
        context: context,
        builder: (contextt) {
          return Container(
            color: black,
            height:  MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(height: 50.h,),
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Image.file(image,fit: BoxFit.fill,)),
                Container(
                  height: 80.h,
                  width: double.infinity,
                  color: white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(onPressed: (){
                        Navigator.pop(contextt);
                      }, child: text(context, 'الغاء', 17, black)),
                      SizedBox(width: 50.w,),
                      Center(child: Container(height: 60.h,width: 1.w, color: grey,)),
                      SizedBox(width: 50.w,),
                      MaterialButton(onPressed: (){
                        setState(() {
                          foundMessage = true;
                          newCon!.add(image2(cameraPath,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                          getConversations();
                          addMessage(userToken!, 'image', image).then((value) => {
                            value == 'SocketException'? {
                              setState(() {
                                newCon!.removeLast();
                                newCon!.add(image2(image.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: 'hint'));
                                getConversations();
                              })
                            }:{
                              setState(() {
                                newCon!.removeLast();
                                newCon!.add(image2(image.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                                getConversations();
                              })

                            }
                          });
                        });
                        Navigator.pop(contextt);
                      }, child: text(context, 'ارسال', 17, black)),

                    ],),
                ),
              ],
            ),
          );
        });
  }
  showCameraVideo(VideoPlayerController con){
    con.play();
    showDialog(
        context: context,
        builder: (contextt) {
          return Container(
            color: black,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h,),
                // Image.file(image),
                Container(height:630.h,child: VideoPlayer(con)),
                Container(
                  height: 80.h,
                  width: double.infinity,
                  color: white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(onPressed: (){
                        setState(() {
                          controller.dispose();
                          con.pause();
                        });
                        Navigator.pop(contextt);
                      }, child: text(context, 'الغاء', 17, black)),
                      SizedBox(width: 50.w,),
                      Center(child: Container(height: 60.h,width: 1.w, color: grey,)),
                      SizedBox(width: 50.w,),
                      MaterialButton(onPressed: (){
                        setState(() {
                          controller.dispose();
                          con.pause();
                        });
                        newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
                        Navigator.pop(contextt);
                        addMessage(userToken!, 'video', image).then((value) => {
                          print(value+ '--------------------------------------------'),
                          value == 'SocketException'? {
                            setState(() {
                              newCon!.removeLast();
                              newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure));
                            })

                          }:{
                            setState(() {
                              newCon!.removeLast();
                              newCon!.add(video(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
                            })

                          }
                        });
                        getConversations();
                      }, child: text(context, 'ارسال', 17, black)),

                    ],),
                )
              ],
            ),
          );
        }).then((value) => con.pause());
  }
  getImageCamra(context, {CameraController? con,bool hint =false}) async {
    // FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(type: FileType.any);
    _cameras = await availableCameras();
    print(_cameras.length.toString()+ '================================');
    setState(() {
      con != null?
      controller = con:
      controller = CameraController(_cameras[cameraId], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          showDialog(
            context: context,
            builder: (contextt) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          !controller.value.isInitialized ?
                          Container(color: black,height: 600.h,
                            width: double.infinity,) : Container(height: 600.h,
                              width: double.infinity,
                              child: Scaffold(
                                backgroundColor: black,
                                body: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(color: black, height: 75.h,width: double.infinity),
                                        CameraPreview(controller),
                                      ],
                                    ),
                                    InkWell(
                                      onTap:(){
                                        setState((){controller.setFlashMode(FlashMode.always);});},
                                      child: Container(margin: EdgeInsets.only(top: 20.h, left: 10.w),alignment: Alignment.topLeft ,child: IconButton(onPressed: (){
                                        setState((){
                                          flashOn?{ controller.setFlashMode(FlashMode.off)}:{ controller.setFlashMode(FlashMode.torch)};
                                          flashOn = !flashOn;
                                        });},icon:!flashOn?Icon(Icons.flash_off, color: white, size: 30.h,):
                                      Icon(Icons.flash_on, color: Colors.amber, size: 30.h,))),
                                    ),
                                  ],
                                ),
                              )),
                          Container(alignment: Alignment.bottomCenter,
                              color: black,
                              height: 130.h,
                              width: double.infinity,
                              child:StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 20.0),
                                          child: GestureDetector(
                                              onTap: ()  {
                                                CameraController cc = CameraController(_cameras[cameraId == 1
                                                    ? 0
                                                    : 1], ResolutionPreset.medium);
                                                setState((){
                                                  cameraId == 1 ? cameraId = 0 : cameraId = 1;
                                                  hint?  Navigator.pop(contextt): null;
                                                  getImageCamra(context, con: cc, hint: true);
                                                });

                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 15.0.w),
                                                child: Icon(
                                                  Icons.flip_camera_android, color: white,
                                                  size: 35.r,),
                                              )),
                                        ),
                                        Center(child: SizedBox(
                                          height: 100.h,
                                          width:100.w,
                                          child: Card(
                                            color: Colors.transparent,
                                            child: GestureDetector(
                                              onLongPress: () async {
                                                if (_isRecording == false) {
                                                  ///Start
                                                  await controller.startVideoRecording();
                                                  setState((){
                                                    _isRecording = true;

                                                  });
                                                }else{};
                                              },
                                              onLongPressUp: () async {
                                                VideoPlayerController vv;
                                                change == true? {
                                                  if (_isRecording == true)
                                                    {
                                                      setState(() {
                                                        controller.setFlashMode(FlashMode.off);
                                                        flashOn =false;
                                                      }),
                                                      ///Stop video recording
                                                      file = await controller.stopVideoRecording().then((value) {
                                                        Navigator.pop(context);
                                                        _isRecording = false;
                                                        image = File(value.path);
                                                        vv =VideoPlayerController.file(image!);
                                                        vv.initialize();
                                                        return showCameraVideo(vv);
                                                      }),

                                                    }
                                                }:null;
                                              },
                                              child: IconButton( onPressed: () async {
                                                //Start and stop video
                                                XFile imageTaken;
                                                XFile file ;

                                                {
                                                  setState(() {
                                                    controller.setFlashMode(FlashMode.off);
                                                    flashOn =false;
                                                  });
                                                  imageTaken =  await controller.takePicture();
                                                  controller.pausePreview();
                                                  Navigator.pop(contextt);
                                                  setState((){
                                                    image = File(imageTaken.path);
                                                    cameraPath = imageTaken.path;

                                                    // setState(() {
                                                    // foundMessage = true;
                                                    // newCon!.add(image2(cameraPath,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                                                    // getConversations();
                                                    // addMessage(userToken!, 'image', image).then((value) => {
                                                    // value == 'SocketException'? {
                                                    // setState(() {
                                                    // newCon!.removeLast();
                                                    // newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: 'hint'));
                                                    // })
                                                    // }:{
                                                    // setState(() {
                                                    // newCon!.removeLast();
                                                    // newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                                                    // })
                                                    //
                                                    // }
                                                    // });
                                                    // });
                                                    showCameraImage(image!);
                                                  });
                                                };
                                              },
                                                icon: Icon(Icons.circle, color :_isRecording?red: white, size: 60.r,),),
                                            ),
                                          ),
                                        ),),
                                        // Center(child: GestureDetector(
                                        //
                                        //     onTap: () async {
                                        //       XFile imageTaken;
                                        //       XFile file ;
                                        //       change == true?{
                                        //         _isRecording?{
                                        //           file = await controller.stopVideoRecording(),
                                        //           setState(() {
                                        //             _isRecording = false;
                                        //             image = File(file.path);
                                        //           }),
                                        //           Navigator.pop(contextt),
                                        //           setState(() {
                                        //             _isRecording = false;
                                        //             foundMessage = true;
                                        //             VideoPlayerController vv =VideoPlayerController.file(image!);
                                        //             vv.initialize();
                                        //             showCameraVideo(vv);
                                        //
                                        //           }),
                                        //         }:{
                                        //           await controller.prepareForVideoRecording(),
                                        //           await controller.startVideoRecording(),
                                        //           setState(() {
                                        //             _isRecording = true;
                                        //           })
                                        //         }
                                        //
                                        //       }:{
                                        //
                                        //         imageTaken = await controller.takePicture(),
                                        //         controller.pausePreview(),
                                        //       setState((){
                                        //       image = File(imageTaken.path);
                                        //       cameraPath = imageTaken.path;
                                        //       Navigator.pop(contextt);
                                        //       // setState(() {
                                        //       // foundMessage = true;
                                        //       // newCon!.add(image2(cameraPath,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                                        //       // getConversations();
                                        //       // addMessage(userToken!, 'image', image).then((value) => {
                                        //       // value == 'SocketException'? {
                                        //       // setState(() {
                                        //       // newCon!.removeLast();
                                        //       // newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure, hint: 'hint'));
                                        //       // })
                                        //       // }:{
                                        //       // setState(() {
                                        //       // newCon!.removeLast();
                                        //       // newCon!.add(image2(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: 'hint'));
                                        //       // })
                                        //       //
                                        //       // }
                                        //       // });
                                        //       // });
                                        //       showCameraImage(image!);
                                        //       }),
                                        //       };
                                        //
                                        //
                                        //     },
                                        //     child: Padding(
                                        //       padding: EdgeInsets.only(left: 15.0.w),
                                        //       child: CircleAvatar(radius: change == true ? 40.r: 45.r,
                                        //         backgroundColor: white,
                                        //       child:  CircleAvatar(radius: 40.r,
                                        //         backgroundColor:  white,
                                        //       child:  change == true? _isRecording ?
                                        //       Icon(Icons.stop, size: 30.r,color: black,): Icon(Icons.fiber_manual_record, size: 30.r,color: red,): SizedBox(),)),
                                        //     ))),
                                        Padding(
                                          padding:  EdgeInsets.only(left: 50.0.w),
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState((){
                                                change == false? change = true: change = false;
                                              });
                                            },
                                            child: Icon(
                                              change? Icons.camera_alt:Icons.videocam, color: white,
                                              size: 45.r,),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              ))
                        ],),
                    );
                  }
              );

            },
          );

        });
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      });
    });


    //}
    // PickedFile? pickedFile =
    //     await ImagePicker.platform.pickImage(source: ImageSource.camera);
    // if (pickedFile == null) {
    //   return null;
    // }
    // final File file = File(pickedFile.path);
    // final Directory directory = await getApplicationDocumentsDirectory();
    // final path = directory.path;
    // final String fileName = Path.basename(pickedFile.path);
    // final String fileExtension = Path.extension(fileName);
    // File newImage = await file.copy('$path/$fileName');
    // if (fileExtension == ".png" ||
    //     fileExtension == ".jpg" ||
    //     fileExtension == ".mp4")
    //   {
    //     setState(() {
    //       image = newImage;
    //     });
    //     widget.createUserId != null ? isFirstTime ? {
    //       setState(() {
    //         newCon!.add(image2(
    //             image!.path, dt.DateFormat('hh:mm a').format(DateTime.now()),
    //             sending));
    //         createConversation(
    //             widget.createUserId!, userToken!, 'image', image!.path).then((
    //             value) =>
    //         {
    //           setState(() {
    //             value == 'SocketException' ? {
    //               setState(() {
    //                 newCon!.removeLast();
    //                 newCon!.add(image2(image!.path,
    //                     dt.DateFormat('hh:mm a').format(DateTime.now()),
    //                     failure, hint: 'hint'));
    //               })
    //             } : {
    //               setState(() {
    //                 newCon!.removeLast();
    //                 newCon!.add(image2(image!.path,
    //                     dt.DateFormat('hh:mm a').format(DateTime.now()), sent));
    //               })
    //             };
    //           })
    //         });
    //         isFirstTime = false;
    //       })
    //     } : {setState(() {
    //       newCon!.add(image2(
    //           image!.path, dt.DateFormat('hh:mm a').format(DateTime.now()),
    //           sending));
    //       createConversation(
    //           widget.createUserId!, userToken!, 'image', image!.path).then((
    //           value) =>
    //       {
    //         setState(() {
    //           value == 'SocketException' ? {
    //             setState(() {
    //               newCon!.removeLast();
    //               newCon!.add(image2(image!.path,
    //                   dt.DateFormat('hh:mm a').format(DateTime.now()), failure,
    //                   hint: 'hint'));
    //             })
    //           } : {
    //             setState(() {
    //               newCon!.removeLast();
    //               newCon!.add(image2(image!.path,
    //                   dt.DateFormat('hh:mm a').format(DateTime.now()), sent,
    //                   hint: 'hint'));
    //             })
    //           };
    //         })
    //       });
    //       isFirstTime = false;
    //     })} : {
    //       setState(() {
    //         newCon!.add(image2(
    //             image!.path, dt.DateFormat('hh:mm a').format(DateTime.now()),
    //             sending, hint: 'hint'));
    //         setState(() {
    //           addMessage(userToken!, 'image', image).then((value) =>
    //           {
    //             value == 'SocketException' ? {
    //               setState(() {
    //                 newCon!.removeLast();
    //                 newCon!.add(image2(image!.path,
    //                     dt.DateFormat('hh:mm a').format(DateTime.now()), failure,
    //                     hint: 'hint'));
    //               })
    //             } : {
    //               setState(() {
    //                 newCon!.removeLast();
    //                 newCon!.add(image2(image!.path,
    //                     dt.DateFormat('hh:mm a').format(DateTime.now()), sent,
    //                     hint: 'hint'));
    //               })
    //             }
    //           });
    //         });
    //
    //       })
    //     };
    //   }else{
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text("امتداد الصورة المسموح به jpg, png",
    //         style: TextStyle(color: Colors.red)),
    //   ));
    // }
  }

  Future<File?> getDocument(context) async {
    FilePickerResult? pickedFile =
    await FilePicker.platform.pickFiles(type: FileType.any);
    // PickedFile? pickedFile =
    // await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.paths[0]!);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.paths[0]!);
    final String fileExtension = Path.extension(fileName);
    File newImage = await file.copy('$path/$fileName');
    if (fileExtension == ".pdf" ||
        fileExtension == ".doc" ||
        fileExtension == ".docx") {
      setState(() {
        image = newImage;
        // Navigator.of(context).pop();
        widget.createUserId != null?
        {
          isFirstTime?{
            newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending)),
            createConversation(widget.createUserId!, userToken!, 'document', image!.path).then((value) => {
              value == 'SocketException'?
              {
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure));
                })
              }:{
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
                })
              }
            }),
            isFirstTime = false,}: {
            newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending)),
            createConversation(widget.createUserId!, userToken!, 'document', image!.path).then((value) => {
              value == 'SocketException'?
              {
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure));
                })
              }:{
                setState(() {
                  newCon!.removeLast();
                  newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
                })
              }
            }),
            isFirstTime = false,}
        }
            :{
          newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sending)),
          addMessage(userToken!, 'document', image).then((value) => {
            value == 'SocketException'?
            {
              setState(() {
                newCon!.removeLast();
                newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),failure));
              })
            }:{
              setState(() {
                newCon!.removeLast();
                newCon!.add(document(image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent));
              })
            }
          }),
        };
      });
    } else {
      if(fileExtension == ".mp3" ){
        final au = AudioPlayer();
        setState(() {
          image = newImage;
          widget.createUserId != null?{ isFirstTime ? {
            createConversation(widget.createUserId!, userToken!, 'voice', image!.path),
            isFirstTime = false,
            au.setSourceDeviceFile(image!.path),
            newCon!.add(voiceRecord(au, image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()), sent,hint: true))} :null} : {
            addMessage(userToken!, 'voice', image),
            au.setSourceDeviceFile(image!.path),
            newCon!.add(voiceRecord(au, image!.path,dt.DateFormat('hh:mm a').format(DateTime.now()),sent, hint: true)),
          };
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("امتداد الملف غير مسموح",
              style: TextStyle(color: Colors.red)),
        ));}
    }
  }

  Future<DataConversation> check(int userId, int secondId) async {
    Map<String, dynamic> data = {
      "user_id": '$userId',
      "secound_user_id": '$secondId',};
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
        checkCon = CheckConversation
            .fromJson(jsonDecode(respons.body))
            .data!;
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


class DurationState {
  DurationState({this.progress, this.buffered, this.total});
  Duration? progress;
  Duration? buffered;
  Duration? total;
}