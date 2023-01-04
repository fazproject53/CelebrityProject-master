import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Celebrity/chat/chat_Screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Celebrity/chat/ChatModel.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as dt;
import '../../Account/LoggingSingUpAPI.dart';
import '../../main.dart';
List _postsstudio = [];
int _pagestudio = 1;
Map<int,String> thumbImage = HashMap();
class chatsList extends StatefulWidget {
  _chatsListState createState() => _chatsListState();
}

class _chatsListState extends State<chatsList> with AutomaticKeepAliveClientMixin{
  final _baseUrl =
      'https://mobile.celebrityads.net/api/celebrity/conversations';
  int _page = 1;
  bool ActiveConnection = false;
  String T = "";
  bool isReady = false;
  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List<Data> _posts = [];
  ScrollController _controller = ScrollController();

  String? userToken;

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  int? userId;
  Future<ChatModel>? cm;

  dt.DateFormat theformat = dt.DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        cm = getConversations();
      });
    });
    DatabaseHelper.getUserData().then((value) {
      setState(() {
        userId = value;
      });
    });
    FirebaseMessaging.onMessage.listen(getRefresh);
    // _controller.addListener(_loadMore);
    super.initState();
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  void getRefresh(RemoteMessage message)  async {
    print('message in list============================================================');
    if (message != null) {
     setState(() {
       cm = getConversations();
     });
    };
    // var android = const AndroidNotificationDetails(
    //     'channel_id', 'channelName', 'channelDescription');
    // var ios = const IOSNotificationDetails();
    // var platform = NotificationDetails(iOS: ios, android: android);
    // await flutterLocalNotificationsPlugin.show(
    //     0, message.data['body'], message.data['body'], platform);
  }
  Future onRefresh() async {
    setState(() {
      cm = getConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    created?{ onRefresh(), created = false}:null;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarNoIcon('المحادثات'),
        body:!isConnectSection
            ? Center(
            child: Padding(
              padding: EdgeInsets.only(top: 0.h),
              child: SizedBox(
                  height: 300.h,
                  width: 250.w,
                  child: internetConnection(context, reload: () {
                    setState(() {
                      cm = getConversations();
                      isConnectSection = true;
                    });
                  })),
            ))
            : !serverExceptions
            ? Container(
          height: getSize(context).height / 1.40,
          child: Center(child: checkServerException(context, reload: (){setState(() {
            cm = getConversations();
          });})),
        )
            : !timeoutException
            ? Center(
          child: checkTimeOutException(context, reload: () {
            setState(() {
              cm = getConversations();
            });
          }),
        )
            : _isFirstLoadRunning
            ? Center(
          child: mainLoad(context),
        )
            : SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 10.h, right: 15.w),
            child: FutureBuilder<ChatModel>(
              future: cm,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot
                      .data!.data!.conversations!.isEmpty
                      ? SizedBox(
                      height: MediaQuery.of(context)
                          .size
                          .height,
                      child: Center(
                          child: Padding(
                            padding:  EdgeInsets.only(bottom: 30.h),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                    'assets/lottie/chat.json',
                                    height: 120.h
                                ),
                                text(context, 'لا يوجد محادثات حاليا',
                                    20, black),
                              ],
                            ),
                          )))
                      : SingleChildScrollView(
                    child: RefreshIndicator(
                      color: white,
                      backgroundColor: purple,
                      onRefresh:  () =>onRefresh(),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (int i = 0;
                          i <
                              snapshot
                                  .data!
                                  .data!
                                  .conversations!
                                  .length;
                          i++)
                            Column(
                              children: [
                                InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .start,
                                        children: [
                                          SizedBox(
                                              height: 70.h,
                                              width: 80.w,
                                              child:
                                              CircleAvatar(
                                                backgroundColor:
                                                lightGrey.withOpacity(0.10),
                                                child:
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      70.r),
                                                  child: Image.network(
                                                     userId !=
                                                        snapshot.data!.data!.conversations![i].secoundUser!.id!
                                                        ? snapshot.data!.data!.conversations![i].secoundUser!.image!
                                                        : snapshot.data!.data!.conversations![i].user!.image!,
                                                    fit: BoxFit
                                                        .fill,
                                                    height:
                                                    double.infinity,
                                                    width: double
                                                        .infinity,
                                                    // loadingBuilder: (context,
                                                    //     child,
                                                    //     loadingProgress) {
                                                    //   if (loadingProgress ==
                                                    //       null)
                                                    //     return child;
                                                    //   return Container(
                                                    //       color: lightGrey.withOpacity(0.10),);
                                                    // },
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              text(
                                                  context,
                                                  userId != snapshot.data!.data!.conversations![i].secoundUser!.id!
                                                      ? snapshot
                                                      .data!
                                                      .data!
                                                      .conversations![
                                                  i]
                                                      .secoundUser!
                                                      .name!
                                                      : snapshot
                                                      .data!
                                                      .data!
                                                      .conversations![
                                                  i]
                                                      .user!
                                                      .name!,
                                                  textSubHeadSize+1,
                                                  black,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              snapshot
                                                  .data!
                                                  .data!
                                                  .conversations![
                                              i]
                                                  .lastMessage!
                                                  .messageType ==
                                                  'text'
                                                  ? Container(
                                                width:
                                                120.w,
                                                child: text(
                                                    context,
                                                    snapshot.data!.data!.conversations![i].lastMessage != null
                                                        ? snapshot.data!.data!.conversations![i].lastMessage!.messageType == 'text'
                                                        ? snapshot.data!.data!.conversations![i].lastMessage!.body!.length < 15
                                                        ? snapshot.data!.data!.conversations![i].lastMessage!.body!
                                                        : snapshot.data!.data!.conversations![i].lastMessage!.body!.substring(0, 15)
                                                        : '**'
                                                        : '',
                                                    textTitleSize,
                                                    black),
                                              ) : snapshot.data!.data!.conversations![i].lastMessage!.messageType ==
                                                  'image'
                                                  ? Icon(
                                                Icons.image,
                                                color: deepBlack,
                                              )
                                                  : snapshot.data!.data!.conversations![i].lastMessage!.messageType == 'video'
                                                  ? Icon(Icons.videocam_rounded, color: deepBlack)
                                                  : snapshot.data!.data!.conversations![i].lastMessage!.messageType == 'voice'
                                                  ? Icon(Icons.keyboard_voice, color: deepBlack)
                                                  : snapshot.data!.data!.conversations![i].lastMessage!.messageType == 'document'
                                                  ? Icon(Icons.file_present, color: deepBlack)
                                                  : SizedBox()
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                            left:
                                            8.0.w),
                                        child: SizedBox(
                                          height: 80.h,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              paddingg(
                                                  0.w,
                                                  0.w,
                                                  20.h,
                                                  text(
                                                      context,
                                                      snapshot.data!.data!.conversations![i].lastMessage != null
                                                          ? snapshot.data!.data!.conversations![i].lastMessage!.date!.substring(0, 10) == theformat.format(DateTime.now())
                                                          ? snapshot.data!.data!.conversations![i].lastMessage!.date!.substring(10)
                                                          : snapshot.data!.data!.conversations![i].lastMessage!.date!.substring(0, 10) == theformat.format(DateTime.now().subtract(Duration(days: 1)))
                                                          ? 'Yesterday'
                                                          : snapshot.data!.data!.conversations![i].lastMessage!.date!.substring(0, 10)
                                                          : '',
                                                      textTitleSize,
                                                      deepBlack)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0
                                                        .w),
                                                child: snapshot.data!.data!.conversations![i].countNotRead ==
                                                    0
                                                    ? SizedBox()
                                                    : CircleAvatar(
                                                    backgroundColor:
                                                    pink,
                                                    radius:
                                                    12.r,
                                                    child: SizedBox(
                                                      child: text(context, snapshot.data!.data!.conversations![i].countNotRead!.toString(), 12, white),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    goToPagePushRefresh(
                                        context,
                                        chatScreen(
                                            idd: snapshot
                                                .data!
                                                .data!
                                                .conversations![
                                            i]
                                                .id,
                                            conId: snapshot
                                                .data!
                                                .data!
                                                .conversations![
                                            i]
                                                .id),
                                        then: (value) {
                                          setState(() {
                                            cm =
                                                getConversations();
                                          });
                                        });
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => chatScreen( conId : snapshot.data!.data!.conversations![i].id )));
                                  },
                                ),
                                Divider()
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: mainLoad(context),
                  );
                }
              },
            ),
          ),
        )
      ),
    );
  }

  Future<ChatModel> getConversations() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl?page=$_page'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken'
      });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        print(response.body);
        setState(() {
          isReady = true;
        });
        setState(() {
          // _posts = ChatModel
          //     .fromJson(jsonDecode(response.body));
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
      // await Future.delayed(Duration(milliseconds: 500));
      return ChatModel.fromJson(jsonDecode(response.body));
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
          serverExceptions = false;
        return Future.error('serverExceptions');
      }
    }
  }
}
