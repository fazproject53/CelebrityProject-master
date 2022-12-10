///import section
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Exploer/viewData.dart';
import 'package:celepraty/Users/Exploer/viewDataImage.dart';
import 'package:celepraty/introduction_screen/ModelIntro.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../MainScreen/main_screen_navigation.dart';
import '../../ModelAPI/CelebrityScreenAPI.dart';
import '../../ModelAPI/ModelsAPI.dart';
import '../../Models/Methods/classes/GradientIcon.dart';

import '../Requests/DownloadImages.dart';
import '../notificationList.dart';
import '../orders/advArea.dart';
import '../orders/advForm.dart';
import '../orders/gifttingForm.dart';
import 'package:http/http.dart' as http;

class CelebrityHome extends StatefulWidget {
  final String? pageUrl;

  const CelebrityHome({Key? key, this.pageUrl}) : super(key: key);

  @override
  _CelebrityHomeState createState() => _CelebrityHomeState();
}

class _CelebrityHomeState extends State<CelebrityHome>
    with AutomaticKeepAliveClientMixin {
  bool isSelect = false;
  Future<introModel>? celebrityHome;

  bool clicked = false;

  ///list of string to store the advertising area images
  List<String> advImage = [];

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  String token = '';
  bool activeConnection = true;
  String T = "";

  BuildContext? context2;
  int currentIndex = 0;
  CheckUserData? ch;
  ///---------------------------------------------------------------------------
  ///Pagination Variable Section News
  int page = 1;
  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  //This holds the news fetched from the server
  List _news = [];
  ScrollController scrollController = ScrollController();

  ///---------------------------------------------------------------------------
  ///Pagination Variable Section Studio
  int pageStudio = 1;
  // There is next page or not
  bool _hasNextPageStudio = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunningStudio = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunningStudio = false;

  //This holds the news fetched from the server
  List _studio = [];
  ScrollController scrollControllerStudio = ScrollController();

  Map<int, VideoPlayerController> videos = HashMap();
  Map<int, String> thumbImage = HashMap();

  ///This function will be called when the app launches
  void _firstLoadNews(String pageUrl) async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res = await http.get(Uri.parse(
          "https://mobile.celebrityads.net/api/celebrity-page/$pageUrl?page=$page"));
      introModel newsModel = introModel.fromJson(jsonDecode(res.body));
      var newNews = newsModel.data!.news;
      setState(() {
        _news = newNews!;
      });
    } catch (err) {
      if (kDebugMode) {
        print('first load Something went wrong');
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  ///LoadMore Function will be triggered whenever the user scroll
  void _loadMoreNews() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 200) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      page += 1; // Increase _page by 1
      try {
        final res = await http.get(Uri.parse(
            "https://mobile.celebrityads.net/api/celebrity-page/${widget.pageUrl}?page=$page"));
        introModel newsModel = introModel.fromJson(jsonDecode(res.body));
        final List<News> fetchedNews = newsModel.data!.news!;
        if (fetchedNews.isNotEmpty) {
          setState(() {
            _news.addAll(fetchedNews);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!2222');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  ///This function will be called when the app launches
  void _firstLoadStudio(String pageUrl) async {
    setState(() {
      _isFirstLoadRunningStudio = true;
    });
    try {
      final res = await http.get(Uri.parse(
          "https://mobile.celebrityads.net/api/celebrity-page/$pageUrl?page=$pageStudio"));

      if (res.statusCode == 200) {
        setState(() {
          _studio = introModel.fromJson(jsonDecode(res.body)).data!.studio!;

          for (int i = 0; i < _studio.length; i++) {
            if (introModel
                    .fromJson(jsonDecode(res.body))
                    .data!
                    .studio![i]
                    .type ==
                'vedio') {
              VideoPlayerController vv = VideoPlayerController.network(
                  introModel
                      .fromJson(jsonDecode(res.body))
                      .data!
                      .studio![i]
                      .image!);

              videos.putIfAbsent(i, () => vv);
              thumbImage.putIfAbsent(
                  i,
                  () => introModel
                      .fromJson(jsonDecode(res.body))
                      .data!
                      .studio![i]
                      .thumbnail!);
            }
          }
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (err) {
      if (kDebugMode) {
        print('first load Something went wrong newStudio');
      }
    }
    setState(() {
      _isFirstLoadRunningStudio = false;
    });
  }

  ///LoadMore Function will be triggered whenever the user scroll
  void _loadMoreStudio() async {
    if (_hasNextPageStudio == true &&
        _isFirstLoadRunningStudio == false &&
        _isLoadMoreRunningStudio == false &&
        scrollControllerStudio.position.maxScrollExtent ==
            scrollControllerStudio.offset) {
      setState(() {
        _isLoadMoreRunningStudio =
            true; // Display a progress indicator at the bottom
      });
      pageStudio += 1; // Increase _page by 1
      try {
        final res = await http.get(Uri.parse(
            "https://mobile.celebrityads.net/api/celebrity-page/${widget.pageUrl}?page=$pageStudio"));

        if (introModel
            .fromJson(jsonDecode(res.body))
            .data!
            .studio!
            .isNotEmpty) {
          setState(() {
            List _studio2 = [];
            int i2 = _studio.length;
            _studio2 = introModel.fromJson(jsonDecode(res.body)).data!.studio!;
            _studio.addAll(_studio2);

            for (int i = 0; i < _studio.length; i++) {
              if (_studio[i].studio!.type == 'vedio') {
                VideoPlayerController vv =
                    VideoPlayerController.network(_studio[i].studio!.image!);

                videos.putIfAbsent(i, () => vv);
                thumbImage.putIfAbsent(i, () => _studio[i].thumbnail!);
                i2 = i2 + 1;
              }
            }
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPageStudio = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!777777777');
        }
      }

      setState(() {
        _isLoadMoreRunningStudio = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        token = value;
        fetchCheckData(token);
      });
    });
    celebrityHome = getSectionsData(widget.pageUrl!);

    _firstLoadNews(widget.pageUrl!);
    _firstLoadStudio(widget.pageUrl!);
    scrollController = ScrollController()..addListener(_loadMoreNews);
    scrollControllerStudio = ScrollController()..addListener(_loadMoreStudio);
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMoreNews);
    scrollControllerStudio.removeListener(_loadMoreStudio);
    for (int i = 0; i < videos.length; i++) {
      videos[i] != null ? videos[i]!.dispose() : null;
    }
    super.dispose();
  }

  Future<introModel> getSectionsData(String pageUrl) async {
    final response = await http.get(
        Uri.parse(
            'https://mobile.celebrityads.net/api/celebrity-page/$pageUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);

      return introModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: white,
        body: activeConnection
            ? SingleChildScrollView(
                controller: scrollControllerStudio,
                child: FutureBuilder<introModel>(
                    future: celebrityHome,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: mainLoad(context));
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          //throw snapshot.error.toString();
                          if (snapshot.error.toString() == 'SocketException') {
                            return Center(
                                child: SizedBox(
                                    height: 500.h,
                                    width: 250.w,
                                    child:
                                        internetConnection(context, reload: () {
                                      setState(() {
                                        celebrityHome =
                                            getSectionsData(widget.pageUrl!);
                                        isConnectSection = true;
                                      });
                                    })));
                          } else {
                            ///error grt the info from server
                            return Center(
                                child: SizedBox(
                                    height: 500.h,
                                    width: 250.w,
                                    child: checkServerException(context,
                                        reload: () {
                                      setState(() {
                                        celebrityHome =
                                            getSectionsData(widget.pageUrl!);
                                        serverExceptions = true;
                                      });
                                    })));
                          }
                          //---------------------------------------------------------------------------
                        } else if (snapshot.hasData) {
                          print(' the youtube link is :' +
                              snapshot.data!.data!.celebrity!.youtube!);

                          ///get the adv image from API and store it inside th list
                          for (int i = 0;
                              i < snapshot.data!.data!.adSpaceOrders!.length;
                              i++) {
                            advImage.contains(snapshot
                                    .data!.data!.adSpaceOrders![i].image!)
                                ? null
                                : advImage.add(snapshot
                                    .data!.data!.adSpaceOrders![i].image!);
                          }
                          return Column(
                            children: [
                              ///Stack for image and there information
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      SizedBox(
                                        width: 500.w,
                                        height: 420.h,
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                goTopagepush(
                                                    context,
                                                    ImageData(
                                                      image: snapshot.data!.data!
                                                          .celebrity!.image!,
                                                    ));
                                              },
                                              child: CachedNetworkImage(
                                                  imageUrl: snapshot.data!.data!
                                                      .celebrity!.image!,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  color: black.withOpacity(0.4),
                                                  colorBlendMode:
                                                      BlendMode.darken,
                                                  placeholder: (context,
                                                      loadingProgress) {
                                                    return Center(
                                                        child: Container(
                                                      color: lightGrey
                                                          .withOpacity(0.60),
                                                    ));
                                                  }),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 30.h,
                                                right: 20.w,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ///back icon to the main screen
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.arrow_back_ios),
                                                    color: white,
                                                    iconSize: 30,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.h, top: 10.h),
                                                    child: Visibility(
                                                        visible: currentuser ==
                                                                'user'
                                                            ? true
                                                            : false,
                                                        child: padding(
                                                          15,
                                                          15,
                                                          Container(
                                                            height: 40.h,
                                                            // width: 48.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(8
                                                                            .r),
                                                                border: Border.all(
                                                                    color: pink,
                                                                    width:
                                                                        1.5.w)
                                                                // gradient: LinearGradient(
                                                                //     colors: <Color>[pink, blue],
                                                                //     begin: Alignment.topLeft,
                                                                //     end: Alignment.bottomRight),
                                                                ),
                                                            // child: Icon(Icons.add , color: white, size: 30,),
                                                            child: Container(
                                                              width: 100.w,
                                                              child: buttoms(
                                                                  context,
                                                                  'اطلب ',
                                                                  20,
                                                                  white, () {
                                                                    ch!.data!.profile!
                                                                    ? showBottomSheett(
                                                                        context,
                                                                        bottomSheetMenu(
                                                                            snapshot.data!.data!.celebrity!.id!
                                                                                .toString(),
                                                                            snapshot
                                                                                .data!.data!.celebrity!.image!,
                                                                            snapshot.data!.data!.celebrity!.name!
                                                                                .toString(),
                                                                            snapshot
                                                                                .data!.data!.celebrity!.advertisingPolicy!,
                                                                            snapshot
                                                                                .data!.data!.celebrity!.giftingPolicy!,
                                                                            snapshot
                                                                                .data!.data!.celebrity!.adSpacePolicy!,
                                                                            snapshot
                                                                                .data!.data!.celebrity!))
                                                                    : failureDialog(
                                                                        context,
                                                                        'الملف الشخصي لم يكتمل ',
                                                                        ' عذرا لا يمكنك الطلب الا بعد اكمال ملفك الشخصي',
                                                                        "assets/lottie/Failuer.json",
                                                                        '',
                                                                        () {},
                                                                        title:
                                                                            'حسنا');
                                                              }),
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                  // Padding(
                                                  //   padding: const EdgeInsets.all(5.0),
                                                  //   child: GradientIcon(Icons.add, 50, gradient()),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          snapshot.data!.data!.celebrity!
                                                      .accountStatus!.id ==
                                                  2
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20.h,
                                                      right: 25.w),
                                                  child: Row(children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.h),
                                                        child: SizedBox()),

                                                    ///SizedBox
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    text(
                                                        context,
                                                        snapshot.data!.data!
                                                            .celebrity!.name!,
                                                        35,
                                                        white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ]),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 200.h, right: 25.w),
                                                  child: Row(children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5.h),
                                                      child: Image.asset(
                                                        'assets/image/Verification.png',
                                                        height: 25.h,
                                                      ),
                                                    ),

                                                    ///SizedBox
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    text(
                                                        context,
                                                        snapshot.data!.data!
                                                            .celebrity!.name!,
                                                        35,
                                                        white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ]),
                                                ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0.h, right: 25.w),
                                            child: text(
                                              context,
                                              snapshot.data!.data!.celebrity!
                                                  .description!,
                                              14,
                                              white.withOpacity(0.9),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 25.w),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 10.r,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                    child: Image.network(
                                                      snapshot
                                                          .data!
                                                          .data!
                                                          .celebrity!
                                                          .country!
                                                          .flag!,
                                                      fit: BoxFit.fill,
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),

                                                ///SizedBox
                                                SizedBox(
                                                  width: 7.w,
                                                ),
                                                text(
                                                    context,
                                                    snapshot
                                                        .data!
                                                        .data!
                                                        .celebrity!
                                                        .category!
                                                        .name!,
                                                    14,
                                                    white),

                                                ///SizedBox
                                                SizedBox(
                                                  width: 7.w,
                                                ),

                                                // text(
                                                //     context,
                                                //     snapshot
                                                //         .data!
                                                //         .data!
                                                //         .celebrity!
                                                //         .country!
                                                //         .name!,
                                                //     14,
                                                //     white),
                                              ],
                                            ),
                                          ),

                                          // Padding(
                                          //   padding:
                                          //   EdgeInsets.only(right: 25.w),
                                          //   child:  text(context, snapshot
                                          //       .data!
                                          //       .data!
                                          //       .celebrity!.city!.name!, 14, white),
                                          // ),

                                          ///SizedBox
                                          SizedBox(
                                            height: 10.h,
                                          ),

                                          ///Social media icons
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 25.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ///facebook
                                                Visibility(
                                                  visible: snapshot.data!.data!
                                                          .celebrity!.facebook!
                                                          .replaceAll(
                                                              'https://www.facebook.com/',
                                                              '')
                                                          .isNotEmpty
                                                      ? true
                                                      : false,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.w),
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: InkWell(
                                                        child: Image.asset(
                                                          'assets/image/icon- faceboock.png',
                                                        ),
                                                        onTap: () async {
                                                          var url = snapshot
                                                              .data!
                                                              .data!
                                                              .celebrity!
                                                              .facebook!;
                                                          if (url == "") {
                                                            ///Do nothing
                                                          } else {
                                                            await launch(url);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                ///instagram
                                                Visibility(
                                                  visible: snapshot.data!.data!
                                                          .celebrity!.instagram!
                                                          .replaceAll(
                                                              'https://www.instagram.com/',
                                                              '')
                                                          .isNotEmpty
                                                      ? true
                                                      : false,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.w),
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: InkWell(
                                                          child: Image.asset(
                                                            'assets/image/icon- insta.png',
                                                          ),
                                                          onTap: () async {
                                                            var url = snapshot
                                                                .data!
                                                                .data!
                                                                .celebrity!
                                                                .instagram!;
                                                            if (url == "") {
                                                              ///Do nothing
                                                            } else {
                                                              await launch(url);
                                                            }
                                                          }),
                                                    ),
                                                  ),
                                                ),

                                                ///snapchat
                                                Visibility(
                                                  visible: snapshot.data!.data!
                                                          .celebrity!.snapchat!
                                                          .replaceAll(
                                                              'https://www.snapchat.com/add/',
                                                              '')
                                                          .isNotEmpty
                                                      ? true
                                                      : false,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.w),
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: InkWell(
                                                          child: Image.asset(
                                                            'assets/image/icon- snapchat.png',
                                                          ),
                                                          onTap: () async {
                                                            var url = snapshot
                                                                .data!
                                                                .data!
                                                                .celebrity!
                                                                .snapchat!;
                                                            if (url == "") {
                                                              ///Do nothing
                                                            } else {
                                                              try {
                                                                final response =
                                                                    await http.get(
                                                                        Uri.parse(
                                                                            url));
                                                                if (response
                                                                        .statusCode ==
                                                                    404) {
                                                                } else {
                                                                  await launch(
                                                                      url);
                                                                }
                                                              } catch (e) {}
                                                            }
                                                          }),
                                                    ),
                                                  ),
                                                ),

                                                ///twitter
                                                Visibility(
                                                  visible: snapshot.data!.data!
                                                          .celebrity!.twitter!
                                                          .replaceAll(
                                                              'https://www.twitter.com/',
                                                              '')
                                                          .isNotEmpty
                                                      ? true
                                                      : false,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.w),
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: InkWell(
                                                          child: Image.asset(
                                                            'assets/image/icon- twitter.png',
                                                          ),
                                                          onTap: () async {
                                                            var url = snapshot
                                                                .data!
                                                                .data!
                                                                .celebrity!
                                                                .twitter!;
                                                            if (url == "") {
                                                              ///Do nothing
                                                            } else {
                                                              await launch(url);
                                                            }
                                                          }),
                                                    ),
                                                  ),
                                                ),

                                                ///tiktok
                                                Visibility(
                                                  visible: snapshot.data!.data!
                                                          .celebrity!.tiktok!
                                                          .replaceAll(
                                                              'https://www.tiktok.com/',
                                                              '')
                                                          .isNotEmpty
                                                      ? true
                                                      : false,
                                                  child: SizedBox(
                                                    width: 40,
                                                    height: 32,
                                                    child: InkWell(
                                                      child: Image.asset(
                                                        'assets/image/tiktokicon2.png',
                                                      ),
                                                      onTap: () async {
                                                        var url = snapshot
                                                            .data!
                                                            .data!
                                                            .celebrity!
                                                            .tiktok!;
                                                        if (url == "") {
                                                          ///Do nothing
                                                        } else {
                                                          await launch(url);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: snapshot.data!.data!
                                                          .celebrity!.youtube!
                                                          .replaceAll(
                                                              'https://youtube.com/',
                                                              '')
                                                          .isNotEmpty
                                                      ? true
                                                      : false,
                                                  child: SizedBox(
                                                    width: 40,
                                                    height: 32,
                                                    child: InkWell(
                                                      child: Image.asset(
                                                        'assets/image/icon-youtube-38.png',
                                                      ),
                                                      onTap: () async {
                                                        var url = snapshot
                                                            .data!
                                                            .data!
                                                            .celebrity!
                                                            .youtube!;
                                                        if (url == "") {
                                                          ///Do nothing
                                                        } else {
                                                          await launch(url);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 5.h,
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  margin: EdgeInsets.only(
                                                      top: 8.h,
                                                      right: 25.w,
                                                      bottom: 10.h),
                                                  child: InkWell(
                                                      onTap: () {
                                                        showDialogFunc(
                                                            context,
                                                            '',
                                                            snapshot
                                                                .data!
                                                                .data!
                                                                .celebrity!
                                                                .advertisingPolicy!,
                                                            snapshot
                                                                .data!
                                                                .data!
                                                                .celebrity!
                                                                .giftingPolicy!,
                                                            snapshot
                                                                .data!
                                                                .data!
                                                                .celebrity!
                                                                .adSpacePolicy!);
                                                      },
                                                      child: text(
                                                          context,
                                                          'سياسة التعامل مع ' +
                                                              snapshot
                                                                  .data!
                                                                  .data!
                                                                  .celebrity!
                                                                  .name!,
                                                          16,
                                                          white,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline))),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              ///SizedBox
                              SizedBox(
                                height: 10.h,
                              ),

                              ///horizontal listView for news
                              _isFirstLoadRunning
                                  ? mainLoad(context)
                                  : Visibility(
                                      visible: _news.isEmpty ? false : true,
                                      child: SizedBox(
                                        height: 68.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          controller: scrollController,
                                          itemCount: _news.length,
                                          itemBuilder: (_, index) =>
                                              Row(children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.w),
                                                child: Container(
                                                  height: 70.h,
                                                  width: 230.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(50.r),
                                                      bottomRight:
                                                          Radius.circular(50.r),
                                                      topLeft:
                                                          Radius.circular(15.r),
                                                      bottomLeft:
                                                          Radius.circular(15.r),
                                                    ),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin:
                                                          Alignment(0.5, 2.0),
                                                      end: Alignment(
                                                          -0.69, -1.0),
                                                      colors: [
                                                        Color(0xffe468ca),
                                                        Color(0xff0ab3d0),
                                                      ],
                                                      stops: [0.0, 1.0],
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.w),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              lightGrey
                                                                  .withOpacity(
                                                                      0.20),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.r),
                                                            child:
                                                                CachedNetworkImage(
                                                                    imageUrl: snapshot
                                                                        .data!
                                                                        .data!
                                                                        .celebrity!
                                                                        .image!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                    placeholder:
                                                                        (context,
                                                                            loadingProgress) {
                                                                      return Center(
                                                                          child:
                                                                              Container(
                                                                        color: lightGrey
                                                                            .withOpacity(0.20),
                                                                      ));
                                                                    }),
                                                          ),
                                                          radius: 30.r,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        SizedBox(
                                                          height: 70.h,
                                                          width: 135.w,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              text(
                                                                  context,
                                                                  _news[index]
                                                                      .description,
                                                                  11,
                                                                  white,
                                                                  align: TextAlign
                                                                      .justify),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                          ]),
                                        ),
                                      ),
                                    ),
                              // when the _loadMore function is running
                              if (_isLoadMoreRunning == true)
                                //mainLoad(context),

                                // When nothing else to load
                                if (_hasNextPage == false) const SizedBox(),

                              SizedBox(
                                height: 10.h,
                              ),

                              ///SizedBox
                              Visibility(
                                visible: advImage.isEmpty ? false : true,
                                child: SizedBox(
                                  height: 20.h,
                                ),
                              ),

                              Visibility(
                                visible: advImage.isEmpty ? false : true,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        right: 10.w, left: 10.w),
                                    height: 150.h,
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius:
                                            BorderRadius.circular(7.r)),
                                    child: imageSlider(advImage)),
                              ),

                              SizedBox(
                                height: 10.h,
                              ),

                              Visibility(
                                visible: snapshot
                                    .data!.data!.celebrity!.brand!.isNotEmpty,
                                child: SizedBox(
                                  height: 20.h,
                                ),
                              ),

                              ///Container for celebrity store
                              Visibility(
                                visible: snapshot
                                    .data!.data!.celebrity!.brand!.isNotEmpty,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 10.w, left: 10.w),
                                  height: 90.h,
                                  width: 440.w,
                                  decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(7.r)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            text(
                                                context,
                                                'قم بزيارة المتجر الان',
                                                12,
                                                white),
                                            text(
                                                context,
                                                'المتجر الخاص ب ' +
                                                    snapshot.data!.data!
                                                        .celebrity!.name!,
                                                16,
                                                white),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: InkWell(
                                          child: gradientContainerNoborder2(
                                              90,
                                              30,
                                              text(context, 'زيارة المتجر', 15,
                                                  white,
                                                  align: TextAlign.center)),
                                          onTap: () {
                                            snapshot
                                                .data!.data!.celebrity!.brand!;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Visibility(
                                //snapshot.data!.data!.celebrity!.brand!.isNotEmpty
                                visible: snapshot
                                    .data!.data!.celebrity!.brand!.isNotEmpty,
                                child: SizedBox(
                                  height: 20.h,
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                              ),

                              ///studio
                              _isFirstLoadRunningStudio
                                  ? mainLoad(context)
                                  : Visibility(
                                      visible: _studio.isEmpty ? false : true,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 10.w, left: 10.w),
                                        child: SizedBox(
                                          //height: 500.h,
                                          width: double.infinity,
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            itemCount: _studio.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  2, //عدد العناصر في كل صف
                                              crossAxisSpacing:
                                                  15.h, // المسافات الراسية
                                              childAspectRatio:
                                                  0.90, //حجم العناصر
                                              mainAxisSpacing: 5.w,
                                            ),
                                            itemBuilder: (context, i) {
                                              ///play the celebrity video
                                              return Card(
                                                elevation: 10,
                                                child: Stack(
                                                  children: [
                                                    ///IMAGE SECTION
                                                    _studio[i].type! == "image"
                                                        ? InkWell(
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5.r),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                      imageUrl:
                                                                          _studio[i]
                                                                              .image!,
                                                                      height: double
                                                                          .infinity,
                                                                      width: double
                                                                          .infinity,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      placeholder:
                                                                          (context,
                                                                              loadingProgress) {
                                                                        return Container(
                                                                            color:
                                                                                lightGrey.withOpacity(0.20));
                                                                      }),
                                                            ),
                                                            onTap: () {
                                                              goTopagepush(
                                                                  context,
                                                                  ImageData(
                                                                    image: _studio[
                                                                            i]
                                                                        .image!,
                                                                  ));
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) =>
                                                              //             ImageData(image: _studio[i].studio!.image!,
                                                              //             )));
                                                            },
                                                          )

                                                        ///Video Section==============================================================================================
                                                        : InkWell(
                                                            child: Stack(
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          200.w,
                                                                      height: double
                                                                          .infinity,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.r),
                                                                        ),
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: _studio[i].thumbnail,
                                                                            fit: BoxFit.cover,
                                                                            placeholder: (context, loadingProgress) {
                                                                              return Container(color: lightGrey.withOpacity(0.20));
                                                                            }),
                                                                      )),
                                                                  Center(
                                                                    child: GradientIcon(
                                                                        playVideo,
                                                                        50.sp,
                                                                        const LinearGradient(
                                                                          begin: Alignment(
                                                                              0.7,
                                                                              2.0),
                                                                          end: Alignment(
                                                                              -0.69,
                                                                              -1.0),
                                                                          colors: [
                                                                            Color(0xff0ab3d0),
                                                                            Color(0xffe468ca)
                                                                          ],
                                                                          stops: [
                                                                            0.0,
                                                                            1.0
                                                                          ],
                                                                        )),
                                                                  )
                                                                ]),
                                                            onTap: () {
                                                              // videos[i]!..initialize();
                                                              vp = videos[i];
                                                              goToPagePushRefresh(
                                                                  context,
                                                                  viewData(
                                                                    videoLikes:
                                                                        _studio[i]
                                                                            .likes,
                                                                    video: _studio[
                                                                            i]
                                                                        .image,
                                                                    thumbnail:
                                                                        _studio[i]
                                                                            .thumbnail,
                                                                    id: _studio[
                                                                            i]
                                                                        .id,
                                                                    token:
                                                                        token,
                                                                  ), then:
                                                                      (value) {
                                                                if (isBressLikeStdio) {
                                                                  setState(() {
                                                                    refresh();
                                                                    isBressLikeStdio =
                                                                        false;
                                                                  });
                                                                }
                                                              });
                                                            },
                                                          )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                              if (_isLoadMoreRunningStudio == true)
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 50.h),
                                  child: CircularProgressIndicator(
                                    color: purple.withOpacity(0.5),
                                  ),
                                ),

                              // When nothing else to load
                              if (_hasNextPageStudio == false) const SizedBox(),

                              SizedBox(
                                height: 20.h,
                              ),

                              SizedBox(
                                height: currentuser == 'user' ? 50.h : 50.h,
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: Text('No info to show!!'));
                        }
                      } else {
                        return Center(
                            child: Text('State: ${snapshot.connectionState}'));
                      }
                    }),
              )
            : Center(
                child: SizedBox(
                    height: 300.h,
                    width: 250.w,
                    child: internetConnection(context, reload: () {
                      checkUserConnection();
                      celebrityHome = getSectionsData(widget.pageUrl!);
                    }))),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  ///image slider
  Widget imageSlider(List image) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Swiper(
          itemBuilder: (context, index) {
            return Container(
                height: 90.h,
                width: 440.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(7.r),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.r),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: image[index],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        placeholder: (context, loadingProgress) {
                          return Center(
                              child: Container(
                            color: lightGrey.withOpacity(0.20),
                          ));
                        },
                      ),
                    ),
                  ],
                ));
          },
          onIndexChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          controller: SwiperController(),
          autoplay: true,
          axisDirection: AxisDirection.right,
          itemCount: image.length,

          ///test it later
          autoplayDelay: 5000,
          pagination: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: 6.h, left: 10.w, right: 10.w),
                    child: DotsIndicator(
                      dotsCount: image.length,
                      position: currentIndex.toDouble(),
                      decorator: DotsDecorator(
                        size: const Size.square(10.0),
                        color: Color(0xFF46D1D3).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.0)),
                        activeColor: Color(0xFFE368C9).withOpacity(0.8),
                        spacing: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 8.h),
                        activeSize: Size(25.0.w, 4.2.h),
                        sizes: getDotSize(image),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.0)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  ///order from the celebrity
  Widget bottomSheetMenu(String id, image, name, pp1, pp2, pp3, celebrity) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
        child:Scaffold(
          backgroundColor: black,
        body: Builder(
        builder: (contextt) {
      return SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 50.h,
          ),
          text(context, 'قم باختيار ما يناسبك من التالي', 22, white),
          SizedBox(
            height: 30.h,
          ),
          InkWell(
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gifttingForm(
                      id: id,
                      image: image,
                      name: name,
                      privacyPolicy: pp2,
                    )),
              );
            },
            child: SizedBox(
              height: 63.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: <Color>[pink, blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        height: 40.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 10.w),
                          child: Icon(arrow, size: 25.w, color: white),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => gifttingForm(
                              id: id,
                              image: image,
                              name: name,
                              privacyPolicy: pp2,
                            )),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: 150.w,
                        child: text(context, ' طلب اهداء', 14, white,
                            fontWeight: FontWeight.bold),
                      ),
                      text(
                        context,
                        'اطلب اهداءك الان من مشهورك المفضل',
                        10,
                        darkWhite,
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                      height: 70.h,
                      width: 70.w,
                      child: Center(
                          child: GradientIcon(
                              copun,
                              40.0.w,
                              const LinearGradient(
                                  colors: <Color>[pink, blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))))
                ],
              ),
            ),
          ),
          const Divider(
            color: darkWhite,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => advForm(
                      id: id,
                      image: image,
                      name: name,
                      privacyPolicy: pp1,
                    )),
              );
            },
            child: SizedBox(
              height: 63.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: <Color>[pink, blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(70.r))),
                        height: 40.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 10.w),
                          child: Icon(arrow, size: 25.w, color: white),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => advForm(
                              id: id,
                              image: image,
                              name: name,
                              privacyPolicy: pp1,
                            )),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        child: text(context, ' طلب اعلان', 14, white,
                            fontWeight: FontWeight.bold),
                      ),
                      text(
                        context,
                        'اطلب اعلانك الان من مشهورك المفضل',
                        10,
                        darkWhite,
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.all(Radius.circular(10.r))),
                      alignment: Alignment.centerRight,
                      height: 70.h,
                      width: 70.w,
                      child: Center(
                          child: GradientIcon(
                              ad,
                              40.0.w,
                              const LinearGradient(
                                  colors: <Color>[pink, blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))))
                ],
              ),
            ),
          ),
          const Divider(color: darkWhite),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => advArea(
                      id: id,
                      privacyPolicy: pp3,
                      name: name,
                      cel: celebrity,
                    )),
              );
            },
            child: SizedBox(
              height: 65.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: <Color>[pink, blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(50.r))),
                        height: 40.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 10.w),
                          child: Icon(arrow, size: 25.w, color: white),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => advArea(
                              id: id,
                              privacyPolicy: pp3,
                              name: name,
                              cel: celebrity,
                            )),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        child: text(context, 'طلب مساحة اعلانية', 14, white,
                            fontWeight: FontWeight.bold),
                      ),
                      text(
                        context,
                        '                اطلب مساحتك الاعلانية الان',
                        10,
                        darkWhite,
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.all(Radius.circular(10.r))),
                      alignment: Alignment.centerRight,
                      height: 70.h,
                      width: 70.w,
                      child: Center(
                          child: GradientIcon(
                              adArea,
                              40.0.w,
                              const LinearGradient(
                                  colors: <Color>[pink, blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))))
                ],
              ),
            ),
          ),
          const Divider(
            color: darkWhite,
          ),
          InkWell(
            onTap: (){
              var snackBar = SnackBar(
                content: text(context2!,'.....قريبا', 15, black, align: TextAlign.center, fontWeight: FontWeight.bold),
                shape: StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: getSize(context2!).height/3, right: 130.w, left: 130.w),
                backgroundColor: white,
                elevation: 20,
                duration: Duration(milliseconds: 500),

              );
              // Step 3
              ScaffoldMessenger.of(context2!).showSnackBar(snackBar);

            },
            child: SizedBox(
              height: 63.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: <Color>[pink, blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(50.r))),
                        height: 40.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 10.w),
                          child: Icon(arrow, size: 25.w, color: white),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => advArea(
                              id: id,
                              privacyPolicy: pp3,
                              name: name,
                              cel: celebrity,
                            )),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        child: text(context, 'طلب تدشين افتتاح/ حفل', 14, white,
                            fontWeight: FontWeight.bold),
                      ),
                      text(
                        context,
                        ' ',
                        10,
                        darkWhite,
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.all(Radius.circular(10.r))),
                      alignment: Alignment.centerRight,
                      height: 70.h,
                      width: 70.w,
                      child: Center(
                          child: GradientIcon(
                              Icons.celebration,
                              40.0.w,
                              const LinearGradient(
                                  colors: <Color>[pink, blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))))
                ],
              ),
            ),
          ),
          const Divider(
            color: darkWhite,
          ),
          InkWell(
            onTap: (){
              var snackBar = SnackBar(
                content: text(context2!,'.....قريبا', 15, black, align: TextAlign.center, fontWeight: FontWeight.bold),
                shape: StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: getSize(context2!).height/3, right: 130.w, left: 130.w),
                backgroundColor: white,
                elevation: 20,
                duration: Duration(milliseconds: 500),

              );
              // Step 3
              ScaffoldMessenger.of(context2!).showSnackBar(snackBar);

            },
            child: SizedBox(
              height: 63.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: <Color>[pink, blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(50.r))),
                        height: 40.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 10.w),
                          child: Icon(arrow, size: 25.w, color: white),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => advArea(
                              id: id,
                              privacyPolicy: pp3,
                              name: name,
                              cel: celebrity,
                            )),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        child: text(context, 'طلب لقاء', 14, white,
                            fontWeight: FontWeight.bold),
                      ),
                      text(
                        context,
                        '  ',
                        10,
                        darkWhite,
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.all(Radius.circular(10.r))),
                      alignment: Alignment.centerRight,
                      height: 70.h,
                      width: 70.w,
                      child: Center(
                          child: GradientIcon(
                              Icons.videocam,
                              40.0.w,
                              const LinearGradient(
                                  colors: <Color>[pink, blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))))
                ],
              ),
            ),
          ),
          const Divider(
            color: darkWhite,
          ),
          InkWell(
            onTap: (){
              var snackBar = SnackBar(
                content: text(context2!,'.....قريبا', 15, black, align: TextAlign.center, fontWeight: FontWeight.bold),
                shape: StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: getSize(context2!).height/3, right: 130.w, left: 130.w),
                backgroundColor: white,
                elevation: 20,
                duration: Duration(milliseconds: 500),

              );
              // Step 3
              ScaffoldMessenger.of(context2!).showSnackBar(snackBar);

            },
            child: SizedBox(
              height: 63.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: <Color>[pink, blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(50.r))),
                        height: 40.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 10.w),
                          child: Icon(arrow, size: 25.w, color: white),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => advArea(
                              id: id,
                              privacyPolicy: pp3,
                              name: name,
                              cel: celebrity,
                            )),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        child: text(context, 'شاركني إبداعك', 14, white,
                            fontWeight: FontWeight.bold),
                      ),
                      text(
                        context,
                        '                ',
                        10,
                        darkWhite,
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.all(Radius.circular(10.r))),
                      alignment: Alignment.centerRight,
                      height: 70.h,
                      width: 70.w,
                      child: Center(
                          child: GradientIcon(
                              Icons.share,
                              40.0.w,
                              const LinearGradient(
                                  colors: <Color>[pink, blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))))
                ],
              ),
            ),
          ),
          const Divider(
            color: darkWhite,
          ),
          InkWell(
            onTap: (){
              var snackBar = SnackBar(
                content: text(context2!,'.....قريبا', 15, black, align: TextAlign.center, fontWeight: FontWeight.bold),
                shape: StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: getSize(context2!).height/3, right: 130.w, left: 130.w),
                backgroundColor: white,
                elevation: 20,
                duration: Duration(milliseconds: 500),

              );
              // Step 3
              ScaffoldMessenger.of(context2!).showSnackBar(snackBar);

            },
            child: SizedBox(
              height: 65.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: <Color>[pink, blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(50.r))),
                        height: 40.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 10.w),
                          child: Icon(arrow, size: 25.w, color: white),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => advArea(
                              id: id,
                              privacyPolicy: pp3,
                              name: name,
                              cel: celebrity,
                            )),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        child: text(context, 'زودني باقتراحك', 14, white,
                            fontWeight: FontWeight.bold),
                      ),
                      text(
                        context,
                        '                ',
                        10,
                        darkWhite,
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.all(Radius.circular(10.r))),
                      alignment: Alignment.centerRight,
                      height: 70.h,
                      width: 70.w,
                      child: Center(
                          child: GradientIcon(
                              Icons.assistant,
                              40.0.w,
                              const LinearGradient(
                                  colors: <Color>[pink, blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight))))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
        ]),
      );
    }
    ),
    )
    );
  }

  ///privacy policy for the celebrity
  showDialogFunc(context, title, adDes, giftDes, areaDes) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: white,
              ),
              padding: EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
              height: 500.h,
              width: 380.w,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: TextDirection.rtl,
                  children: [
                    ///Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///text
                        text(context, 'تفاصيل سياسة التعامل', 14, grey!),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),

                    ///Adv Title
                    text(context, 'سياسة الاعلان', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Adv Details
                    text(
                      context,
                      adDes,
                      14,
                      ligthtBlack,
                    ),

                    ///---------------------
                    SizedBox(
                      height: 20.h,
                    ),

                    ///---------------------

                    ///Gifting Title
                    text(context, 'سياسة الاهداء', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Gifting Details
                    text(
                      context,
                      giftDes,
                      14,
                      ligthtBlack,
                    ),

                    ///---------------------
                    SizedBox(
                      height: 15.h,
                    ),

                    ///---------------------

                    ///Area Title
                    text(context, 'سياسة المساحة الاعلانية', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Area Details
                    text(
                      context,
                      areaDes,
                      14,
                      ligthtBlack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getDotSize(List image) {
    return List.generate(
      image.length,
      (index) => Size(25.0.w, 4.2.h),
    );
  }

//refresh list------------------------------------------------------------------
  Future refresh() async {
    setState(() {
      _studio.clear();
      pageStudio = 1;
      _hasNextPageStudio = true;
      _isFirstLoadRunningStudio = false;
      _isLoadMoreRunningStudio = false;
      _firstLoadStudio(widget.pageUrl!);
    });
  }


  void showBottomSheett(context, buttomMenue) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        context: context,
        useRootNavigator: false,
        builder: (contextt) {
            context2 = contextt;
          return Container(
            height: 700.h,
            child: buttomMenue,
          );
        });
  }
  fetchCheckData(String token) async {
    var response;
    try {
      response =
      await http.get(Uri.parse('https://mobile.celebrityads.net/api/check-user-profile'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 200) {
        final body = response.body;

        setState(() {
          ch = CheckUserData.fromJson(jsonDecode(body));
        });
        print("------------Reading CheckData from network");
      } else {
        return Future.error('fetchCheckData error ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        return Future.error('تحقق من اتصالك بالانترنت');
      } else if (e is TimeoutException) {
        return Future.error('TimeoutException');
      } else {
        return Future.error('serverError' + '${response.statusCode}');
      }
    }
  }
}
