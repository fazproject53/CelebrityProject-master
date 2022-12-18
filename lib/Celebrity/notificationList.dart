import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Celebrity/NotificationModel.dart' as nl;
import 'package:celepraty/Celebrity/chat/chat_Screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../Account/LoggingSingUpAPI.dart';
import '../MainScreen/main_screen_navigation.dart';
import '../Users/UserRequests/UserAds/UserAdvDetials.dart';
import '../Users/UserRequests/UserAdvSpace/UserAdvSpaceDetails.dart';
import '../Users/UserRequests/UserGift/UserGiftDetials.dart';
import '../Users/UserRequests/UserReguistMainPage.dart';
import '../Users/chat/chatRoom.dart';
import 'Requests/Ads/AdvDetials.dart';
import 'Requests/Ads/Advertisments.dart';
import 'Requests/AdvSpace/AdSpace.dart';
import 'Requests/AdvSpace/AdSpaceDetails.dart';
import 'Requests/Gift/Gift.dart';
import 'Requests/Gift/GiftDetials.dart';
import 'Requests/ReguistMainPage.dart';

bool change = false;

class notificationList extends StatefulWidget {
  _notificationListState createState() => _notificationListState();
}

class _notificationListState extends State<notificationList>
    with AutomaticKeepAliveClientMixin {
  final _baseUrl = 'https://mobile.celebrityads.net/api/notifications';
  int _page = 1;
  int? userId;
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
  List _posts = [];
  ScrollController _controller = ScrollController();

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  String? userToken;
  String? cImage;

  void _loadMore() async {
    print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.maxScrollExtent == _controller.offset) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;
      try {
        final res =
        await http.get(Uri.parse("$_baseUrl?page=$_page"), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });

        if (nl.NotificationModel.fromJson(jsonDecode(res.body)).data != null) {
          setState(() {
            _posts = _posts +
                nl.NotificationModel.fromJson(jsonDecode(res.body))
                    .data!
                    .notifications!;
          });
        } else {
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

  Future onRefreshnotification() async {
    setState(() {
      getNotifications(userToken!);
    });
  }

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getNotifications(userToken!);
      });
    });
    DatabaseHelper.getUserData().then((value) {
      setState(() {
        userId = value;
      });
    });
    _controller.addListener(_loadMore);
    FirebaseMessaging.onMessage.listen(getRefresh2);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  void getRefresh2(RemoteMessage message) async {
    print(message.data['type'].toString() +
        '========================================');
    if (message.data['type'] != 'hidden_message') {
      setState(() {
        getNotifications(userToken!);
      });
    }

    // var android = const AndroidNotificationDetails(
    //     'channel_id', 'channelName', 'channelDescription');
    // var ios = const IOSNotificationDetails();
    // var platform = NotificationDetails(iOS: ios, android: android);
    // await flutterLocalNotificationsPlugin.show(
    //     0, message.data['body'], message.data['body'], platform);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarNoIcon('التنبيهات'),
        body: !isConnectSection
            ? Center(
            child: Padding(
              padding: EdgeInsets.only(top: 0.h),
              child: SizedBox(
                  height: 300.h,
                  width: 250.w,
                  child: internetConnection(context, reload: () {
                    setState(() {
                      getNotifications(userToken!);
                      isConnectSection = true;
                    });
                  })),
            ))
            : !serverExceptions
            ? Container(
          height: getSize(context).height / 1.40,
          child: Center(
              child: checkServerException(context, reload: () {
                setState(() {
                  getNotifications(userToken!);
                });
              })),
        )
            : !timeoutException
            ? Center(
          child: checkTimeOutException(context, reload: () {
            setState(() {
              getNotifications(userToken!);
            });
          }),
        )
            : _isFirstLoadRunning
            ? Center(
          child: mainLoad(context),
        )
            : _posts.isEmpty
            ? SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 70.h),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Lottie.asset(
                        'assets/lottie/notify.json',
                      ),
                      text(context, 'لا يوجد تنبيهات حاليا', 20,
                          black),
                    ],
                  ),
                )))
            : RefreshIndicator(
          color: white,
          backgroundColor: purple,
          onRefresh: () => onRefreshnotification(),
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                paddingg(
                  10.w,
                  10.w,
                  20.h,
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext context,
                        int index) {
                      return InkWell(
                        child: Container(
                          height: 150.h,
                          child: Card(
                            color: _posts[index].read == 0
                                ? Colors.white60
                                : white,
                            elevation: 3,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.only(
                                          right:
                                          15.w),
                                      child: CircleAvatar(
                                        backgroundColor:
                                        lightGrey
                                            .withOpacity(
                                            0.10),
                                        radius: 50.r,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              100.r),
                                          child:
                                          CachedNetworkImage(
                                            imageUrl: _posts[
                                            index]
                                                .sendUser!
                                                .image!,
                                            fit: BoxFit
                                                .fill,
                                            height: double
                                                .infinity
                                                .h,
                                            width: 95.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        text(
                                            context,
                                            _posts[index]
                                                .sendUser!
                                                .username!,
                                            textTitleSize,
                                            black,
                                            fontWeight:
                                            FontWeight
                                                .normal),
                                        text(
                                            context,
                                            _posts[index]
                                                .createdAt!,
                                            textDetails,
                                            black.withOpacity(
                                                0.80)),
                                        Container(
                                          margin: EdgeInsets
                                              .only(
                                              bottom:
                                              10.h),
                                          height: 55.h,
                                          width: 250.w,
                                          child: text(
                                              context,
                                              _posts[index]
                                                  .body!,
                                              textTitleSize,
                                              black.withOpacity(
                                                  0.80)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          readNotification(
                              _posts[index].id);
                          _posts[index].user.type ==
                              'celebrity'
                              ? {
                            if (_posts[index]
                                .type ==
                                'message')
                              {
                                print(_posts[index]
                                    .notificationId
                                    .toString() +
                                    '================================================================'),
                                goToPagePushRefresh(
                                    context,
                                    chatScreen(
                                      conId: _posts[
                                      index]
                                          .notificationId,
                                      idd: _posts[
                                      index]
                                          .notificationId,
                                    ),
                                    then: (value) {
                                      setState(() {
                                        _posts.clear();
                                        _page = 1;
                                        _hasNextPage =
                                        true;
                                        _isFirstLoadRunning =
                                        false;
                                        _isLoadMoreRunning =
                                        false;
                                        getNotifications(
                                            userToken!);
                                      });
                                    }),
                              }
                            else
                              {
                                if (_posts[index]
                                    .type ==
                                    'order')
                                  {
                                    if (_posts[index]
                                        .notification
                                        .adType
                                        .id ==
                                        1)
                                      {
                                        goToPagePushRefresh(
                                          context,
                                          AdvDetials(
                                            commercialRecord: _posts[index]
                                                .notification
                                                .commercialRecord,
                                            owner: _posts[index]
                                                .sendUser
                                                .name,
                                            image: _posts[index]
                                                .notification
                                                .file,
                                            advTitle: _posts[index]
                                                .notification
                                                .advertisingAdType!
                                                .name,
                                            description: _posts[index]
                                                .notification
                                                .description,
                                            orderId:
                                            _posts[index].notificationId,
                                            token:
                                            userToken,
                                            platform: _posts[index].notification.platform ==
                                                null
                                                ? null
                                                : _posts[index].notification.platform.name,
                                            state: _posts[index]
                                                .notification
                                                .status
                                                .id,
                                            price: _posts[index]
                                                .notification
                                                .price,
                                            rejectResonName: _posts[index].notification.rejectReson !=
                                                null
                                                ? _posts[index].notification.rejectReson.name!
                                                : null,
                                            rejectResonId: _posts[index].notification.rejectReson !=
                                                null
                                                ? _posts[index].notification.rejectReson.id
                                                : null,
                                            userId: _posts[index]
                                                .sendUser
                                                .id!,
                                            userName: _posts[index]
                                                .sendUser
                                                .name,
                                            userImage: _posts[index]
                                                .sendUser
                                                .image,
                                            time: _posts[index]
                                                .notification
                                                .adTiming!
                                                .name!,
                                            celerityCityName:
                                            '${_posts[index].notification.celebrity!.city?.name!}',
                                            celerityEmail: _posts[index]
                                                .notification
                                                .celebrity!
                                                .email!,
                                            celerityIdNumber:
                                            '${_posts[index].notification.celebrity!.idNumber}',
                                            celerityName: _posts[index]
                                                .notification
                                                .celebrity!
                                                .name!,
                                            celerityNationality:
                                            '${_posts[index].notification.celebrity!.nationality?.countryArNationality}',
                                            celerityPhone: _posts[index]
                                                .notification
                                                .celebrity!
                                                .phonenumber!,
                                            celerityVerifiedNumber:
                                            '${_posts[index].notification.celebrity!.commercialRegistrationNumber}',
                                            celerityVerifiedType: _posts[index].notification.celebrity?.celebrityType ==
                                                'person'
                                                ? 'رخصة إعلانية'
                                                : 'سجل تجاري',
                                            userCityName:
                                            '${_posts[index].notification.user!.city?.name!}',
                                            userEmail: _posts[index]
                                                .notification
                                                .user!
                                                .email!,
                                            userIdNumber:
                                            '${_posts[index].notification.user!.idNumber}',
                                            userNationality:
                                            '${_posts[index].notification.user!.nationality?.countryArNationality}',
                                            userPhone: _posts[index]
                                                .notification
                                                .user!
                                                .phonenumber!,
                                            userVerifiedNumber:
                                            '${_posts[index].notification.user!.commercialRegistrationNumber}',
                                            userVerifiedType: _posts[index].notification.adOwner!.name ==
                                                'فرد'
                                                ? 'وثيقة عمل حر'
                                                : 'سجل تجاري',
                                            sendDate: DateTime.now(),
                                            advDate: _posts[index]
                                                .notification
                                                .date!,
                                            singture:
                                            "",
                                            celeritySigntion:
                                            "",
                                          ),
                                          then:
                                              (value) {
                                            setState(
                                                    () {
                                                  _posts.clear();
                                                  _page =
                                                  1;
                                                  _hasNextPage =
                                                  true;
                                                  _isFirstLoadRunning =
                                                  false;
                                                  _isLoadMoreRunning =
                                                  false;
                                                  getNotifications(userToken!);
                                                });
                                          },
                                        )
                                      }
                                    else
                                      {
                                        if (_posts[index]
                                            .notification
                                            .adType
                                            .id ==
                                            2)
                                          {
                                            goToPagePushRefresh(
                                                context,
                                                GiftDetials(
                                                  price: _posts[index].notification.price,
                                                  description: _posts[index].notification.description,
                                                  advTitle: "${_posts[index].notification.occasion.name}",
                                                  advType: "${_posts[index].notification.giftType.name}",
                                                  orderId: _posts[index].notificationId,
                                                  token: userToken,
                                                  state: _posts[index].notification.status.id,
                                                  rejectResonName: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.name! : null,
                                                  rejectResonId: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.id : null,
                                                  from: _posts[index].notification.from!,
                                                  to: _posts[index].notification.to!,
                                                  userId: _posts[index].sendUser.id!,
                                                  userName: _posts[index].sendUser.name,
                                                  userImage: _posts[index].sendUser.image,
                                                  platform: _posts[index].notification.platform == null ? null : _posts[index].notification.platform.name,
                                                ),
                                                then:
                                                    (value) {
                                                  setState(
                                                          () {
                                                        _posts.clear();
                                                        _page =
                                                        1;
                                                        _hasNextPage =
                                                        true;
                                                        _isFirstLoadRunning =
                                                        false;
                                                        _isLoadMoreRunning =
                                                        false;
                                                        getNotifications(userToken!);
                                                      });
                                                }),
                                          }
                                        else
                                          {
                                            goToPagePushRefresh(
                                                context,
                                                AdSpaceDetails(
                                                  commercialRecord: _posts[index].notification.commercialRecord,
                                                  image: _posts[index].notification.image,
                                                  link: _posts[index].notification.link,
                                                  price: _posts[index].notification.price,
                                                  orderId: _posts[index].notificationId,
                                                  token: userToken,
                                                  state: _posts[index].notification.status.id,
                                                  rejectResonName: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.name! : null,
                                                  rejectResonId: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.id : null,
                                                  userId: _posts[index].sendUser.id!,
                                                  userName: _posts[index].sendUser.name,
                                                  userImage: _posts[index].sendUser.image,
                                                  celerityCityName: '${_posts[index].notification.celebrity!.city?.name!}',
                                                  celerityEmail: _posts[index].notification.celebrity!.email!,
                                                  celerityIdNumber: '${_posts[index].notification.celebrity!.idNumber}',
                                                  celerityName: _posts[index].notification.celebrity!.name!,
                                                  celerityNationality: '${_posts[index].notification.celebrity!.nationality?.countryArNationality}',
                                                  celerityPhone: _posts[index].notification.celebrity!.phonenumber!,
                                                  celerityVerifiedNumber: '${_posts[index].notification.celebrity!.commercialRegistrationNumber}',
                                                  celerityVerifiedType: _posts[index].notification.celebrity?.celebrityType == 'person' ? 'رخصة إعلانية' : 'سجل تجاري',
                                                  userCityName: '${_posts[index].notification.user!.city?.name!}',
                                                  userEmail: _posts[index].notification.user!.email!,
                                                  userIdNumber: '${_posts[index].notification.user!.idNumber}',
                                                  userNationality: '${_posts[index].notification.user!.nationality?.countryArNationality}',
                                                  userPhone: _posts[index].notification.user!.phonenumber!,
                                                  userVerifiedNumber: '${_posts[index].notification.user!.commercialRegistrationNumber}',
                                                  userVerifiedType: 'سجل تجاري',
                                                  advDate: _posts[index].notification.date!,
                                                  singture: "${_posts[index].notification.contract?.userSignature}",
                                                  celeritySigntion: "${_posts[index].notification.contract?.celebritySignature}",
                                                  sendDate: _posts[index].notification.contract != null ? DateTime.parse(_posts[index].notification.contract.date!) : null,
                                                ),
                                                then:
                                                    (value) {
                                                  setState(
                                                          () {
                                                        _posts.clear();
                                                        _page =
                                                        1;
                                                        _hasNextPage =
                                                        true;
                                                        _isFirstLoadRunning =
                                                        false;
                                                        _isLoadMoreRunning =
                                                        false;
                                                        getNotifications(userToken!);
                                                      });
                                                }),
                                          }
                                      }
                                  }
                                else
                                  {}
                              }
                          }
                              : {
                            if (_posts[index]
                                .type ==
                                'message')
                              {
                                print(_posts[index]
                                    .notificationId
                                    .toString() +
                                    '================================================================'),
                                goToPagePushRefresh(
                                    context,
                                    chatRoom(
                                      conId: _posts[
                                      index]
                                          .notificationId,
                                    ),
                                    then: (value) {
                                      setState(() {
                                        _posts.clear();
                                        _page = 1;
                                        _hasNextPage =
                                        true;
                                        _isFirstLoadRunning =
                                        false;
                                        _isLoadMoreRunning =
                                        false;
                                        getNotifications(
                                            userToken!);
                                      });
                                    }),
                              }
                            else
                              {
                                if (_posts[index]
                                    .type ==
                                    'order')
                                  {
                                    if (_posts[index]
                                        .notification
                                        .adType
                                        .id ==
                                        1)
                                      {
                                        goToPagePushRefresh(
                                            context,
                                            UserAdvDetials(
                                              userId: _posts[index]
                                                  .user
                                                  .id!,
                                              time: _posts[index]
                                                  .notification
                                                  .adTiming
                                                  .name,
                                              commercialRecord: _posts[index]
                                                  .notification
                                                  .commercialRecord,
                                              image: _posts[index]
                                                  .notification
                                                  .file,
                                              advTitle: _posts[index]
                                                  .notification
                                                  .advertisingAdType!
                                                  .name,
                                              description: _posts[index]
                                                  .notification
                                                  .description,
                                              orderId:
                                              _posts[index].notificationId,
                                              token:
                                              userToken,
                                              platform: _posts[index].notification.platform == null
                                                  ? null
                                                  : _posts[index].notification.platform.name,
                                              state: _posts[index]
                                                  .notification
                                                  .status
                                                  .id,
                                              price: _posts[index]
                                                  .notification
                                                  .price,
                                              rejectResonName: _posts[index].notification.rejectReson != null
                                                  ? _posts[index].notification.rejectReson.name!
                                                  : null,
                                              rejectResonId: _posts[index].notification.rejectReson != null
                                                  ? _posts[index].notification.rejectReson.id
                                                  : null,
                                              celebrityId: _posts[index]
                                                  .sendUser
                                                  .id!,
                                              celebrityName: _posts[index]
                                                  .sendUser
                                                  .name,
                                              celImage: _posts[index]
                                                  .sendUser
                                                  .image,
                                              celebrityImage: _posts[index]
                                                  .notification
                                                  .celebrity
                                                  .image,
                                              celebrityPagUrl: _posts[index]
                                                  .notification
                                                  .celebrity
                                                  .pageUrl,
                                              celerityCityName:
                                              '${_posts[index].notification.celebrity!.city?.name!}',
                                              celerityEmail: _posts[index]
                                                  .notification
                                                  .celebrity!
                                                  .email!,
                                              celerityIdNumber:
                                              '${_posts[index].notification.celebrity!.idNumber}',
                                              celerityName: _posts[index]
                                                  .notification
                                                  .celebrity!
                                                  .name!,
                                              celerityNationality:
                                              '${_posts[index].notification.celebrity!.nationality?.countryArNationality}',
                                              celerityPhone: _posts[index]
                                                  .notification
                                                  .celebrity!
                                                  .phonenumber!,
                                              celerityVerifiedNumber:
                                              '${_posts[index].notification.celebrity!.commercialRegistrationNumber}',
                                              celerityVerifiedType: _posts[index].notification.celebrity?.celebrityType == 'person'
                                                  ? 'رخصة إعلانية'
                                                  : 'سجل تجاري',
                                              userCityName:
                                              '${_posts[index].notification.user!.city?.name!}',
                                              userEmail: _posts[index]
                                                  .notification
                                                  .user!
                                                  .email!,
                                              userIdNumber:
                                              '${_posts[index].notification.user!.idNumber}',
                                              userNationality:
                                              '${_posts[index].notification.user!.nationality?.countryArNationality}',
                                              userPhone: _posts[index]
                                                  .notification
                                                  .user!
                                                  .phonenumber!,
                                              userVerifiedNumber:
                                              '${_posts[index].notification.user!.commercialRegistrationNumber}',
                                              userVerifiedType: _posts[index].notification.adOwner!.name == 'فرد'
                                                  ? 'وثيقة عمل حر'
                                                  : 'سجل تجاري',
                                              singture:
                                              '',
                                              userName: _posts[index]
                                                  .notification
                                                  .user!
                                                  .name!,
                                              advDate: _posts[index]
                                                  .notification
                                                  .date!,
                                              celeritySigntion:
                                              "${_posts[index].notification.contract?.celebritySignature}",
                                              sendDate: _posts[index].notification.contract == null
                                                  ? null
                                                  : DateTime.parse(_posts[index].notification.contract!.date!),
                                              owner: _posts[index]
                                                  .notification
                                                  .adOwner
                                                  ?.name,
                                            ), then:
                                            (value) {
                                          setState(
                                                  () {
                                                _posts
                                                    .clear();
                                                _page =
                                                1;
                                                _hasNextPage =
                                                true;
                                                _isFirstLoadRunning =
                                                false;
                                                _isLoadMoreRunning =
                                                false;
                                                getNotifications(
                                                    userToken!);
                                              });
                                        }),
                                      }
                                    else
                                      {
                                        print('the second user is is :' +
                                            _posts[index]
                                                .sendUser
                                                .id
                                                .toString()),
                                        if (_posts[index]
                                            .notification
                                            .adType
                                            .id ==
                                            2)
                                          {
                                            goToPagePushRefresh(
                                                context,
                                                UserGiftDetials(
                                                  userId: _posts[index].user.id!,
                                                  advType: _posts[index].notification.giftType.name,
                                                  price: _posts[index].notification.price,
                                                  celebrityPagUrl: _posts[index].notification.celebrity.pageUrl,
                                                  celebrityImage: _posts[index].sendUser.image,
                                                  description: _posts[index].notification.description,
                                                  advTitle: _posts[index].notification.ocassion.name,
                                                  orderId: _posts[index].notificationId,
                                                  token: userToken,
                                                  state: _posts[index].notification.status.id,
                                                  rejectResonName: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.name! : null,
                                                  rejectResonId: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.id : null,
                                                  from: _posts[index].notification.from!,
                                                  to: _posts[index].notification.to!,
                                                  celebrityId: _posts[index].sendUser.id!,
                                                  celebrityName: _posts[index].sendUser.name,
                                                  celImage: _posts[index].sendUser.image,
                                                  platform: _posts[index].notification.platform == null ? null : _posts[index].notification.platform.name,
                                                ),
                                                then:
                                                    (value) {
                                                  setState(
                                                          () {
                                                        _posts.clear();
                                                        _page =
                                                        1;
                                                        _hasNextPage =
                                                        true;
                                                        _isFirstLoadRunning =
                                                        false;
                                                        _isLoadMoreRunning =
                                                        false;
                                                        getNotifications(userToken!);
                                                      });
                                                }),
                                          }
                                        else
                                          {
                                            goToPagePushRefresh(
                                                context,
                                                UserAdvSpaceDetails(
                                                  commercialRecord: _posts[index].notification.commercialRecord,
                                                  image: _posts[index].notification.image,
                                                  link: _posts[index].notification.link,
                                                  platform: _posts[index].notification.platform == null ? null : _posts[index].notification.platform.name,
                                                  description: _posts[index].notification.description,
                                                  price: _posts[index].notification.price,
                                                  orderId: _posts[index].notificationId,
                                                  token: userToken,
                                                  state: _posts[index].notification.status.id,
                                                  rejectResonName: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.name! : null,
                                                  rejectResonId: _posts[index].notification.rejectReson != null ? _posts[index].notification.rejectReson.id : null,
                                                  userId: _posts[index].sendUser.id!,
                                                  celebrityId: _posts[index].sendUser.id!,
                                                  celebrityName: _posts[index].sendUser.name,
                                                  celImage: _posts[index].sendUser.image,
                                                ),
                                                then:
                                                    (value) {
                                                  setState(
                                                          () {
                                                        _posts.clear();
                                                        _page =
                                                        1;
                                                        _hasNextPage =
                                                        true;
                                                        _isFirstLoadRunning =
                                                        false;
                                                        _isLoadMoreRunning =
                                                        false;
                                                        getNotifications(userToken!);
                                                      });
                                                }),
                                          }
                                      }
                                  }
                                else
                                  {}
                              }
                          };
                        },
                      );
                    },
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getNotifications(String tokenn) async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDI4MTY3ZWY1YWE0ZDBjZWQ0MDBjOTViMzBmNWQwZGFiNmY4MzgxMWU3YTUwMWUyMmYwMmMyZGU2YjRjOTIwOGI0MjFjNmZjZGM3YWMzZjUiLCJpYXQiOjE2NTM5ODg2MjAuNjgyMDE4OTk1Mjg1MDM0MTc5Njg3NSwibmJmIjoxNjUzOTg4NjIwLjY4MjAyNDk1NTc0OTUxMTcxODc1LCJleHAiOjE2ODU1MjQ2MjAuNjczNjY3OTA3NzE0ODQzNzUsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.OguFfzEWNOyCU4xSZ_PbLwg1xmyEbIMYAQ-J9wRApGKMq0qo1aEiM1OvcfvEaopxRiKngk-ckebhhcl7MRtGopNZcNjJwp9jWS7yZuyH7DBvct0O6tys47HL4eBU0QLwgmxMmh8nLkADARdIvVdZJFw9vLp-7X-4Huj6I2E1SFjeYnV6l7Fu_c1BYMAJmXpBwIALxTvwxg8tbxuhKmFBtLnnY3K25Tedra9IMc0nR_nXV3ifXdp4v7fsvbCLLYNr5ihc3ElE_QWczOvkkYeOPTP4yFMFlZFpWUNeER5wiEdbcO6WzzxzCRkLXriedWDI3G6qOrMAUAjiAUxS51--_7x9iI0qHalXHyGxgudUnAHGNsYpvLJ8JVCM2k_dtGazmZtA5w5wDSTI8gSuWUZxf2OpQNCmyt8k80Pbi_Olz2xDMSuDKYmiomWrUhwIwunk_gsU9lC5oLcEzJ2BLcaiiuwFex9xraMbbC1ZyipSIZZhW1l1CppYeYmPSxLC8hEIywRy5Lbvw-WQ25CpurNgEMiHefGooDxCsHqnkfWCQ1MnFAGiEs2hPtG7DVp8RArzCyXXaVrtVi2wbBFrCPDK52yNQxQjs3z8JBNlDwEFR2uDa-VRup61j2WESvyUKPMloD7gL7FsthAl6IZquYh7XujHWEcf1Lnprd6D5J6CPWM';
    setState(() {
      _isFirstLoadRunning = true;
    });
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
        setState(() {
          if (nl.NotificationModel.fromJson(jsonDecode(response.body))
              .data!
              .notifications!
              .isNotEmpty) {
            _posts = nl.NotificationModel.fromJson(jsonDecode(response.body))
                .data!
                .notifications!;
            cImage = nl.NotificationModel.fromJson(jsonDecode(response.body))
                .data!
                .notifications![0]
                .user!
                .image !=
                null
                ? nl.NotificationModel.fromJson(jsonDecode(response.body))
                .data!
                .notifications![0]
                .user!
                .image!
                : null;
          }
        });
        print(response.body);
        setState(() {
          isReady = true;
          unreadMessage = 0;
          change = true;
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

  Future<ReadNotification> readNotification(id) async {
    //try{
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/read-notification/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(jsonDecode(response.body));
      return ReadNotification.fromJson(jsonDecode(response.body));
    } else {
      // print(userToken);
      return Future.error('read error ${response.statusCode}');
    }
    // }catch(e){
    //   if (e is SocketException) {
    //     setState(() {
    //       isConnectSection = false;
    //     });
    //     return Future.error('SocketException');
    //   } else if (e is TimeoutException) {
    //     setState(() {
    //       timeoutException = false;
    //     });
    //     return Future.error('TimeoutException');
    //   } else {
    //     setState(() {
    //       serverExceptions = false;
    //     });
    //     return Future.error('serverExceptions');
    //   }
    // }
  }
}

class ReadNotification {
  bool? success;
  Data? data;
  Message? message;

  ReadNotification({this.success, this.data, this.message});

  ReadNotification.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  int? status;

  Data({this.status});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class Message {
  String? en;
  String? ar;

  Message({this.en, this.ar});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}