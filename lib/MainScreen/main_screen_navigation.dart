///import section
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:celepraty/Celebrity/Unread.dart';
import 'package:celepraty/Celebrity/notificationList.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Exploer/Explower.dart';
import 'package:celepraty/Users/Setting/userProfile.dart';
import 'package:celepraty/Users/chat/chatListUser.dart';
import 'package:celepraty/celebrity/celebrityHomePage.dart';
import 'package:celepraty/celebrity/chat/chatsList.dart';
import 'package:celepraty/celebrity/setting/celebratyProfile.dart';
import 'package:celepraty/main.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:video_player/video_player.dart';
import '../Account/LoggingSingUpAPI.dart';
import 'package:http/http.dart' as http;

import '../Models/Methods/method.dart';

String? test;
String? currentuser;
int? unreadMessage;
VideoPlayerController? vp;
BuildContext? cx;
final navigationKey = GlobalKey<CurvedNavigationBarState>();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  PageController? pageController;
  int selectedIndex = 2;

  String? userToken;

//open specific page-------
  goToNavigationItem(int page) {
    final navigationState = navigationKey.currentState!;
    navigationState.setPage(page);
  }

  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    // var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var ios = const IOSInitializationSettings();
    // var platform = InitializationSettings(android: android, iOS: ios);
    //flutterLocalNotificationsPlugin.initialize(platform);
    //when message in foreground-----------------------------------------------------------------
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getUnread(userToken!);
      });
    });

    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    DatabaseHelper.getRememberUser().then((token) {
      setState(() {
        currentuser = token;
        print('currents user is:$currentuser');
      });
    });
    FirebaseMessaging.onMessage.listen(onMessageNotificationn);
  }

  void onMessageNotificationn(RemoteMessage message) async {
    if (message != null) {
      if (message.data['type'] == 'message_read' ||
          message.data['type'] == 'hidden_message') {
      } else {
        getUnread(userToken!);
        if (!mounted) return;
        setState(() {
          number = int.parse(message.data['conversation_count_not_read']);
        });
      }

      // print('foundMessage is:--------------------------$foundMessage');
      // var android = const AndroidNotificationDetails(
      //     'channel_id', 'channelName', 'channelDescription');
      // var ios = const IOSNotificationDetails();
      // var platform = NotificationDetails(iOS: ios, android: android);
    }
  }
//-----------------------------------------------------------------

  List<Widget> Famousscreens = [
    /// Explore
    Explower(),

    /// Activity page
    notificationList(),

    /// Home Screen
    celebrityHomePage(),

    /// Chats
    chatsList(),

    /// Celebrity Profile
    celebratyProfile(),
  ];
  List<Widget> userScreen = [
    /// Explore
    Explower(),

    /// Activity page
    notificationList(),

    /// Home Screen
    celebrityHomePage(),

    /// Chats
    chatsListUser(),

    /// Celebrity Profile
    userProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Container(
      color: deepwhite,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: currentuser == "celebrity" ? Famousscreens : userScreen,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              key: navigationKey,
              backgroundColor: Colors.transparent,
              color: deepwhite,
              index: selectedIndex,
              items: <Widget>[
                ///explore icon
                GradientIcon(
                    exploreIcon,
                    30.w,
                    const LinearGradient(
                      begin: Alignment(0.7, 2.0),
                      end: Alignment(-0.69, -1.0),
                      colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                      stops: [0.0, 1.0],
                    )),

                ///notification icon
                number == null || number == 0
                    ? GradientIcon(
                    notificationIcon,
                    30.w,
                    const LinearGradient(
                      begin: Alignment(0.7, 2.0),
                      end: Alignment(-0.69, -1.0),
                      colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                      stops: [0.0, 1.0],
                    ))
                    : Badge(
                  badgeColor: pink,
                  badgeContent: Text('$number',
                      style: TextStyle(color: white, fontSize: 12.sp)),
                  child: GradientIcon(
                      notificationIcon,
                      30.w,
                      const LinearGradient(
                        begin: Alignment(0.7, 2.0),
                        end: Alignment(-0.69, -1.0),
                        colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                        stops: [0.0, 1.0],
                      )),
                ),

                ///home icon
                GradientIcon(
                    homeIcon,
                    30.w,
                    const LinearGradient(
                      begin: Alignment(0.7, 2.0),
                      end: Alignment(-0.69, -1.0),
                      colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                      stops: [0.0, 1.0],
                    )),

                ///chat icon
                GradientIcon(
                    chatIcon,
                    30.w,
                    const LinearGradient(
                      begin: Alignment(0.7, 2.0),
                      end: Alignment(-0.69, -1.0),
                      colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                      stops: [0.0, 1.0],
                    )),

                ///account icon
                GradientIcon(
                    nameIcon,
                    30.w,
                    const LinearGradient(
                      begin: Alignment(0.7, 2.0),
                      end: Alignment(-0.69, -1.0),
                      colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                      stops: [0.0, 1.0],
                    )),
              ],
              height: 45.h,
              onTap: onTap,

              // animationDuration: const Duration(milliseconds: 100),
            ),
          ),
        ),
      ),
    );
  }

  //click methos--------------------------
  void onTap(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 1) {
        number = 0;
      }
      vp == null ? null : {vp!.pause(), vp = null};
      cx == null ? null : {Navigator.pop(cx!), cx = null};
      print((vp == null).toString() + '0000000000000000000000000000000000');
    });
    pageController!.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 10), curve: Curves.easeInCirc);

    print('notification number:$number');
  }
//=======================================================================================
  void getUnread(String tokenn) async {
    var response;
    try {
      response = await http.get(
          Uri.parse(
              'https://mobile.celebrityads.net/api/notifications-not-read'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenn'
          });
      if (response.statusCode == 200) {
        setState(() {
          number = (UnRead.fromJson(jsonDecode(response.body))
              .data!
              .notificationsNotRead !=
              null
              ? UnRead.fromJson(jsonDecode(response.body))
              .data!
              .notificationsNotRead!
              : null)!;

          print('unread = ' + unreadMessage.toString());
        });
      } else {
        return Future.error('notification error ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        return Future.error('تحقق من اتصالك بالانترنت');
      } else if (e is TimeoutException) {
        return Future.error('TimeoutException');
      } else {
        return Future.error('حدثت مشكله في السيرفر' + '${response.statusCode}');
      }
    }
  }
}

//---------------------------------------------------------------