import 'dart:async';
import 'dart:convert';
import 'package:celepraty/Account/VerifyUser.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/introduction_screen/ModelIntro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Account/LoggingSingUpAPI.dart';
import 'Account/ResetPassword/ResetNewPassword.dart';
import 'Celebrity/Requests/Ads/AdvDetials.dart';
import 'Celebrity/Requests/ReguistMainPage.dart';
import 'Celebrity/chat/chat_Screen.dart';
import 'Celebrity/chat/chatsList.dart';
import 'Celebrity/notificationList.dart';
import 'Users/UserRequests/UserReguistMainPage.dart';
import 'Users/chat/chatListUser.dart';
import 'Users/chat/chatRoom.dart';
import 'introduction_screen/introduction_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

int? initScreen;
int number = 0;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
bool foundMessage = false;
RemoteMessage? foregroundMessage;
String? notificationId;
String? whereTo;
void main() async {
  //show splash screen one time
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen(onMessageNotification);
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  runApp(
    MyApp(), // Wrap your app
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {
  Future<IntroData>? futureIntro;
  String? isLogging;
  final GlobalKey<NavigatorState> myNavigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const IOSInitializationSettings();
    var platform = InitializationSettings(android: android, iOS: ios); //
    flutterLocalNotificationsPlugin.initialize(platform,
        onSelectNotification: (String? payload) {
      debugPrint('payload is: $payload');
      onSelect();
    });
//===================================================================================
    //clicked notification when app in background
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage foregroundMessage) {
      if (foregroundMessage != null) {
        debugPrint('notification type: ${foregroundMessage.data}');
//Request notification-----------------------------------------------------------------------------
        if (foregroundMessage.data['type'] == 'order') {
          if (foregroundMessage.data['user_type'] == 'celebrity') {
            Map<String, dynamic> data =
                json.decode(foregroundMessage.data['notification']);
            print('---------------==========================');
            print(data);
            print('---------------=========================');
            if (data["ad_type_id"] == 1) {
              setState(() {
                whereTo = null;
              });
              myNavigatorKey.currentState?.pushNamed('celebrityRequest');
            } else if (data["ad_type_id"] == 2) {
              setState(() {
                whereTo = 'gift';
              });
              myNavigatorKey.currentState?.pushNamed('celebrityRequest');
            } else if (data["ad_type_id"] == 3) {
              setState(() {
                whereTo = 'advSpace';
              });
              myNavigatorKey.currentState?.pushNamed('celebrityRequest');
            }
// user Requests-----------------------------------------------------------------------
          } else {
            Map<String, dynamic> data =
                json.decode(foregroundMessage.data['notification']);
            print('---------------==========================');
            print(data);
            print('---------------=========================');
            if (data["ad_type_id"] == 1) {
              setState(() {
                whereTo = null;
              });
              myNavigatorKey.currentState?.pushNamed('userRequest');
            } else if (data["ad_type_id"] == 2) {
              setState(() {
                whereTo = 'gift';
              });
              myNavigatorKey.currentState?.pushNamed('userRequest');
            } else if (data["ad_type_id"] == 3) {
              setState(() {
                whereTo = 'advSpace';
              });
              myNavigatorKey.currentState?.pushNamed('userRequest');
            }
          }
        }
//Message notification-----------------------------------------------------------------------------
        else if (foregroundMessage.data['type'] == 'message') {
          if (foregroundMessage.data['user_type'] == 'celebrity') {
            setState(() {
              notificationId = foregroundMessage.data['notification_id'];
            });
            myNavigatorKey.currentState?.pushNamed('celebrityMessage');
          } else {
            setState(() {
              notificationId = foregroundMessage.data['notification_id'];
            });
            myNavigatorKey.currentState?.pushNamed('userMessage');
          }
        }

        // if(message.data['type'] == 'message'){
        //   goTopagepush(context, RequestMainPage());
        // }else if(message.data['type'] == 'order'){
        //   goTopagepush(context, RequestMainPage());
      }
    });
//===================================================================================
    //clicked notification when app is terminated
    getInisMessage();
//===================================================================================
    futureIntro = getIntroData();
    DatabaseHelper.getRememberToken().then((token) {
      setState(() {
        isLogging = token;
      });
    });
    print('isLogging:$isLogging');
  }

  Future onRefresh() async {
    setState(() {
      futureIntro = getIntroData();
    });
  }

  //------------------------------------------------
  void onSelect() async {
    if (foregroundMessage != null) {
      debugPrint('notification type: ${foregroundMessage?.data}');
//Request notification-----------------------------------------------------------------------------
      if (foregroundMessage?.data['type'] == 'order') {
        if (foregroundMessage?.data['user_type'] == 'celebrity') {
          Map<String, dynamic> data =
              json.decode(foregroundMessage?.data['notification']);
          print('---------------==========================');
          print(data);
          print('---------------=========================');
          if (data["ad_type_id"] == 1) {
            setState(() {
              whereTo = null;
            });
            myNavigatorKey.currentState?.pushNamed('celebrityRequest');
          } else if (data["ad_type_id"] == 2) {
            setState(() {
              whereTo = 'gift';
            });
            myNavigatorKey.currentState?.pushNamed('celebrityRequest');
          } else if (data["ad_type_id"] == 3) {
            setState(() {
              whereTo = 'advSpace';
            });
            myNavigatorKey.currentState?.pushNamed('celebrityRequest');
          }
// user Requests-----------------------------------------------------------------------
        } else {
          Map<String, dynamic> data =
              json.decode(foregroundMessage?.data['notification']);
          print('---------------==========================');
          print(data);
          print('---------------=========================');
          if (data["ad_type_id"] == 1) {
            setState(() {
              whereTo = null;
            });
            myNavigatorKey.currentState?.pushNamed('userRequest');
          } else if (data["ad_type_id"] == 2) {
            setState(() {
              whereTo = 'gift';
            });
            myNavigatorKey.currentState?.pushNamed('userRequest');
          } else if (data["ad_type_id"] == 3) {
            setState(() {
              whereTo = 'advSpace';
            });
            myNavigatorKey.currentState?.pushNamed('userRequest');
          }
        }
      }
//Message notification-----------------------------------------------------------------------------
      else if (foregroundMessage?.data['type'] == 'message') {
        if (foregroundMessage?.data['user_type'] == 'celebrity') {
          setState(() {
            notificationId = foregroundMessage?.data['notification_id'];
          });
          myNavigatorKey.currentState?.pushNamed('celebrityMessage');
        } else {
          setState(() {
            notificationId = foregroundMessage?.data['notification_id'];
          });
          myNavigatorKey.currentState?.pushNamed('userMessage');
        }
      }
      //
    }
    //if (payload != null) {
    // debugPrint('notification payload: $payload');
// Here you can check notification payload and redirect user to the respective screen

    //}
  }
  //------------------------------------------------

  @override
  Widget build(BuildContext context) {
    print('wher to: $whereTo');
    super.build(context);
    return ScreenUtilInit(
      designSize: const Size(413, 763),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: () => MaterialApp(

        navigatorKey: myNavigatorKey,
        debugShowCheckedModeBanner: false,
        //to save data when app killed by os
        restorationScopeId: 'root',
        title: 'منصة المشاهير',
        theme: ThemeData(
          fontFamily: "Cairo",
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: purple.withOpacity(0.5)),
          scaffoldBackgroundColor: Colors.white,
        ),
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        initialRoute: initScreen == 0 || initScreen == null
            ? 'firstPage'
            : isLogging == ''
                ? 'logging'
                : 'MainScreen',
        routes: {
          'firstPage': (context) => firstPage(),
          'logging': (context) => Logging(),
          'MainScreen': (context) => const MainScreen(),
          'userRequest': (context) => UserRequestMainPage(
                whereTo: whereTo,
              ),
          'celebrityRequest': (context) => RequestMainPage(whereTo: whereTo),
          'userMessage': (context) => chatRoom(
                conId: int.parse(notificationId!),
              ),
          'celebrityMessage': (context) => chatScreen(
                idd: int.parse(notificationId!),
                conId: int.parse(notificationId!),
              )
        },
        //  home:ResetNewPassword(username: 'tatooo7331@gmail.com',)
      ),
    );
  }

//----------------------------------------------------------------------
  Widget firstPage() {
    return FutureBuilder<IntroData>(
      future: futureIntro,
      builder: (BuildContext context, AsyncSnapshot<IntroData> snapshot) {
        var getData = snapshot.data;

        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            if (snapshot.error.toString() == 'SocketException') {
              return Scaffold(
                body: Center(
                    child: internetConnection(context, reload: () {
                  setState(() {
                    onRefresh();
                  });
                })),
              );
            } else {
              return Scaffold(
                body: Center(
                    child: checkServerException(context, reload: () {
                  setState(() {
                    onRefresh();
                  });
                })),
              );
            }
            //---------------------------------------------------------------------------
          } else if (snapshot.hasData) {
            return IntroductionScreen(data: getData?.data);
          }
        }
        return Center(child: splash());
      },
    );
  }

//----------------------------------------------------------------------
  Widget splash() {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80.r,
              backgroundColor: white,
              backgroundImage: Image.asset(
                'assets/image/log.png',
              ).image,
            ),
            SizedBox(
              height: 20.h,
            ),
            text(context, 'مرحبا بكم في منصة المشاهير', 20, white,
                align: TextAlign.center),
            SizedBox(
              height: 40.h,
            ),
            Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.r,
                backgroundColor: grey!,
                color: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void getInisMessage() async {
    var foregroundMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (foregroundMessage != null) {
      debugPrint('notification type: ${foregroundMessage.data}');
//Request notification-----------------------------------------------------------------------------
      if (foregroundMessage.data['type'] == 'order') {
        if (foregroundMessage.data['user_type'] == 'celebrity') {
          Map<String, dynamic> data =
              json.decode(foregroundMessage.data['notification']);
          print('---------------==========================');
          print(data);
          print('---------------=========================');
          if (data["ad_type_id"] == 1) {
            setState(() {
              whereTo = null;
            });
            myNavigatorKey.currentState?.pushNamed('celebrityRequest');
          } else if (data["ad_type_id"] == 2) {
            setState(() {
              whereTo = 'gift';
            });
            myNavigatorKey.currentState?.pushNamed('celebrityRequest');
          } else if (data["ad_type_id"] == 3) {
            setState(() {
              whereTo = 'advSpace';
            });
            myNavigatorKey.currentState?.pushNamed('celebrityRequest');
          }
// user Requests-----------------------------------------------------------------------
        } else {
          Map<String, dynamic> data =
              json.decode(foregroundMessage.data['notification']);
          print('---------------==========================');
          print(data);
          print('---------------=========================');
          if (data["ad_type_id"] == 1) {
            setState(() {
              whereTo = null;
            });
            myNavigatorKey.currentState?.pushNamed('userRequest');
          } else if (data["ad_type_id"] == 2) {
            setState(() {
              whereTo = 'gift';
            });
            myNavigatorKey.currentState?.pushNamed('userRequest');
          } else if (data["ad_type_id"] == 3) {
            setState(() {
              whereTo = 'advSpace';
            });
            myNavigatorKey.currentState?.pushNamed('userRequest');
          }
        }
      }
//Message notification-----------------------------------------------------------------------------
      else if (foregroundMessage.data['type'] == 'message') {
        if (foregroundMessage.data['user_type'] == 'celebrity') {
          setState(() {
            notificationId = foregroundMessage.data['notification_id'];
          });
          myNavigatorKey.currentState?.pushNamed('celebrityMessage');
        } else {
          setState(() {
            notificationId = foregroundMessage.data['notification_id'];
          });
          myNavigatorKey.currentState?.pushNamed('userMessage');
        }
      }
    }
  }
}

Future backgroundMessage(RemoteMessage message) async {
  if (message != null) {
    debugPrint('notification: ${message.data}');

    if (message.data['type'] == 'message') {
      number = int.parse(message.data['count_not_read']);
      print(
          '***-------------*************-------------*****************-----------***');
      debugPrint('notification count_not_read: ${number}');
      print(
          '***-------------*************-------------*****************-----------***');
    }

    if (message.data['type'] == 'order') {
      // number = int.parse(message.data['count_not_read']);
    }
  }
  var android = const AndroidNotificationDetails(
    'channel_id',
    'channelName',
    channelDescription: 'channelDescription',
    importance: Importance.max,
    priority: Priority.high,
  );
  var ios = const IOSNotificationDetails();
  var platform = NotificationDetails(iOS: ios, android: android);
  if (message.data['type'] == 'message' || message.data['type'] == 'order') {
    await flutterLocalNotificationsPlugin.show(createUniqueID(),
        message.data['title'], message.data['body'], platform);
  }
  if (message.data['type'] == 'read_message') {}
}

//=============================================================================
void onMessageNotification(RemoteMessage message) async {
  if (message != null) {
    debugPrint('notification: ${message.data}');
    foundMessage = true;
    foregroundMessage = message;
    if (message.data['type'] == 'message') {
      number = int.parse(message.data['conversation_count_not_read']);
      print(
          '***-------------*************-------------*****************-----------***');
      debugPrint('notification count_not_read: ${number}');
      print(
          '***-------------*************-------------*****************-----------***');
    }

    if (message.data['type'] == 'order') {
      // number = int.parse(message.data['count_not_read']);
    }

    if (message.data['type'] == 'read_message') {}
  }

  var android = const AndroidNotificationDetails('channel_id', 'channelName',
      channelDescription: 'channelDescription');
  var ios = const IOSNotificationDetails();
  var platform = NotificationDetails(iOS: ios, android: android);
  if (message.data['type'] == 'message') {
    theName == '' || !message.data['body'].contains(theName)
        ? {
            await flutterLocalNotificationsPlugin.show(createUniqueID(),
                message.data['title'], message.data['body'], platform)
          }
        : null;
  }
  if (message.data['type'] == 'order') {
    await flutterLocalNotificationsPlugin.show(createUniqueID(),
        message.data['title'], message.data['body'], platform);
  }
  if (message.data['type'] == 'read_message') {}
}

//================================uniqueID==============================================================
int createUniqueID() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100);
}
//جعل الفيديو يحمل بسرعه

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// main() {
//   runApp(MaterialApp(
//     home: VideoPlayerDemo(),
//   ));
// }
//
// class VideoPlayerDemo extends StatefulWidget {
//   @override
//   _VideoPlayerDemoState createState() => _VideoPlayerDemoState();
// }
//
// class _VideoPlayerDemoState extends State<VideoPlayerDemo> {
//   int index = 0;
//   double _position = 0;
//   double _buffer = 0;
//   bool _lock = true;
//   final Map<String, VideoPlayerController> _controllers = {};
//   final Map<int, VoidCallback> _listeners = {};
//   final Set<String> _urls = {
//     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4#1',
//     'https://mobile.celebrityads.net/storage/images/studio/YsZLgLxNyMvclXO0MY36G2uHrphI3nUzBhJx56p3.mp4',
//     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4#7',
//   };
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (_urls.isNotEmpty) {
//       _initController(0).then((_) {
//         _playController(0);
//       });
//     }
//
//     if (_urls.length > 1) {
//       _initController(1).whenComplete(() => _lock = false);
//     }
//   }
//
//   VoidCallback _listenerSpawner(index) {
//     return () {
//       int dur = _controller(index)!.value.duration.inMilliseconds;
//       int pos = _controller(index)!.value.position.inMilliseconds;
//       int buf = _controller(index)!.value.buffered.last.end.inMilliseconds;
//
//       setState(() {
//         if (dur <= pos) {
//           _position = 0;
//           return;
//         }
//         _position = pos / dur;
//         _buffer = buf / dur;
//       });
//       if (dur - pos < 1) {
//         if (index < _urls.length - 1) {
//           _nextVideo();
//         }
//       }
//     };
//   }
//
//   VideoPlayerController? _controller(int index) {
//     return _controllers[_urls.elementAt(index)];
//   }
//
//   Future<void> _initController(int index) async {
//     var controller = VideoPlayerController.network(_urls.elementAt(index));
//     _controllers[_urls.elementAt(index)] = controller;
//     await controller.initialize();
//   }
//
//   void _removeController(int index) {
//     _controller(index)?.dispose();
//     _controllers.remove(_urls.elementAt(index));
//     _listeners.remove(index);
//   }
//
//   void _stopController(int index) {
//     _controller(index)?.removeListener(_listeners[index]!);
//     _controller(index)?.pause();
//     _controller(index)?.seekTo(Duration(milliseconds: 0));
//   }
//
//   void _playController(int index) async {
//     if (!_listeners.keys.contains(index)) {
//       _listeners[index] = _listenerSpawner(index);
//     }
//     _controller(index)?.addListener(_listeners[index]!);
//     await _controller(index)?.play();
//     setState(() {});
//   }
//
//   void _previousVideo() {
//     if (_lock || index == 0) {
//       return;
//     }
//     _lock = true;
//
//     _stopController(index);
//
//     if (index + 1 < _urls.length) {
//       _removeController(index + 1);
//     }
//
//     _playController(--index);
//
//     if (index == 0) {
//       _lock = false;
//     } else {
//       _initController(index - 1).whenComplete(() => _lock = false);
//     }
//   }
//
//   void _nextVideo() async {
//     if (_lock || index == _urls.length - 1) {
//       return;
//     }
//     _lock = true;
//
//     _stopController(index);
//
//     if (index - 1 >= 0) {
//       _removeController(index - 1);
//     }
//
//     _playController(++index);
//
//     if (index == _urls.length - 1) {
//       _lock = false;
//     } else {
//       _initController(index + 1).whenComplete(() => _lock = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Playing ${index + 1} of ${_urls.length}"),
//       ),
//       body: Stack(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () => _controller(index)?.pause(),
//             onDoubleTap: () => _controller(index)?.play(),
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: _controller(index)!.value.aspectRatio,
//                 child: Center(child: VideoPlayer(_controller(index)!)),
//               ),
//             ),
//           ),
//           Positioned(
//             child: Container(
//               height: 10,
//               width: MediaQuery.of(context).size.width * _buffer,
//               color: Colors.grey,
//             ),
//           ),
//           Positioned(
//             child: Container(
//               height: 10,
//               width: MediaQuery.of(context).size.width * _position,
//               color: Colors.greenAccent,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           FloatingActionButton(onPressed: _previousVideo, child: Icon(Icons.arrow_back)),
//           const SizedBox(width: 24),
//           FloatingActionButton(onPressed: _nextVideo, child: Icon(Icons.arrow_forward)),
//         ],
//       ),
//     );
//   }
// }

//when message in background-------------------------------------
