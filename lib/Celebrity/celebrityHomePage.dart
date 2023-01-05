import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:celepraty/Account/Singup.dart';
import 'package:celepraty/Celebrity/CelebritySearch.dart';
import 'package:celepraty/Celebrity/ShowMoreCelebraty.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Users/CreateOrder/buildAdvOrder.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Account/LoggingSingUpAPI.dart';
import '../MainScreen/main_screen_navigation.dart';
import '../ModelAPI/ModelsAPI.dart';
import '../Models/Variables/Variables.dart';
import 'HomeScreen/celebrity_home_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class celebrityHomePage extends StatefulWidget {
  const celebrityHomePage({Key? key}) : super(key: key);

  @override
  _celebrityHomePageState createState() => _celebrityHomePageState();
}

class _celebrityHomePageState extends State<celebrityHomePage>
    with AutomaticKeepAliveClientMixin {
  late ValueNotifier<double> valueNotifier;
  final GlobalKey<NavigatorState> nKey = GlobalKey<NavigatorState>();
  final exploweKey = navigationKey;
  Map<int, Future<Category>> category = HashMap<int, Future<Category>>();
  PageController pageController = PageController();
  Future<Section>? sections;
  Future<link>? futureLinks;
  Future<header>? futureHeader;
  Future<Partner>? futurePartners;
  List<dynamic> allCellbrity = [];
  String token = '';
  bool isLoading = true;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool endLode = false;
  int page = 1;
  int currentIndex = 0;
  bool? isCompleteProfile;
  bool? isCompletePrise;
  bool? isCompleteContract;
  bool? isCompleteVerify;
  List<bool> checkComplete = [];
  DataCheck? futureCheckData;
  @override
  void initState() {
    getTok();
    sections = getSectionsData();
    futureLinks = fetchLinks();
    futureHeader = fetchHeader();

    futurePartners = fetchPartners();
    getAllCelebrity().then((value) {
      if (mounted) {
        setState(() {
          allCellbrity = value!;
          endLode = true;
        });
      }
    });

    super.initState();
    valueNotifier = ValueNotifier(0.0);
    getTokenAndData();
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          navigatorKey: nKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: purple),
          home: Scaffold(
            appBar: AppBar(
              toolbarHeight: 58,
              backgroundColor: Colors.grey[50],
              actions: [
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  child: GradientIcon(Icons.search, 30.sp, gradient()),
                  onTap: () {
                    endLode ? _showSearch() : print('loading');
                  },
                ),
                SizedBox(
                  width: 10.w,
                ),
                currentuser == 'user'
                    ? InkWell(
                        child: GradientIcon(Icons.add, 30, gradient()),
                        onTap: () {
                          goTopagepush(context, buildAdvOrder());
                        },
                      )
                    : const SizedBox(),
                const Spacer(),
                SizedBox(
                    height: 105.h,
                    width: 230.w,
                    child: Image(
                      image: AssetImage(
                        logo,
                      ),
                      fit: BoxFit.cover,
                    )),
              ],
            ),
            backgroundColor: white,
            body: RefreshIndicator(
              color: white,
              backgroundColor: purple,
              onRefresh: onRefresh,
              child: isConnectSection == false
                  ? Center(
                      child: internetConnection(context, reload: () {
                        setState(() {
                          onRefresh();
                          isConnectSection = true;
                        });
                      }),
                    )
                  : timeoutException == false
                      ? Center(
                          child: checkTimeOutException(context, reload: () {
                            setState(() {
                              onRefresh();
                              timeoutException = true;
                            });
                          }),
                        )
                      : serverExceptions == false
                          ? Center(
                              child: checkServerException(context, reload: () {
                                setState(() {
                                  onRefresh();
                                  serverExceptions = true;
                                });
                              }),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //search(),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 50.0.h),
                                    child: FutureBuilder<Section>(
                                      future: sections,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<Section> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(child: lodeing());
                                        } else if (snapshot.connectionState ==
                                                ConnectionState.active ||
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            print(
                                                '----------------------------------------------------');
                                            print(
                                                'statusCode ${snapshot.connectionState}');
                                            print(
                                                '----------------------------------------------------');
                                            return Center(
                                                child: Text(
                                                    snapshot.error.toString()));
                                            // if (snapshot.error.toString() ==
                                            //     'SocketException') {
                                            //   return Center(
                                            //       child: SizedBox(
                                            //           height: 200.h,
                                            //           width: 200.w,
                                            //           child: internetConnection(
                                            //               context, reload: () {
                                            //             setState(() {
                                            //               onRefresh();
                                            //               isConnectSection =
                                            //                   true;
                                            //             });
                                            //           })));
                                            // } else {
                                            //   return const Center(
                                            //       child: Text(
                                            //           'حدث خطا ما اثناء استرجاع البيانات'));
                                            // }
                                            //---------------------------------------------------------------------------
                                          } else if (snapshot.hasData) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (int sectionIndex = 0;
                                                    sectionIndex <
                                                        snapshot
                                                            .data!.data!.length;
                                                    sectionIndex++)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
//category--------------------------------------------------------------------------

                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'category')
                                                        categorySection(
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .categoryId,
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .title,
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .active),

//header--------------------------------------------------------------------------
                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'header')
                                                        headerSection(
                                                          snapshot
                                                              .data
                                                              ?.data![
                                                                  sectionIndex]
                                                              .active,
                                                        ),
//links--------------------------------------------------------------------------
                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'links')
                                                        linksSection(snapshot
                                                            .data
                                                            ?.data![
                                                                sectionIndex]
                                                            .active),
//Advertising-banner--------------------------------------------------------------------------
                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'Advertising-banner')
                                                        advertisingBannerSection(
                                                          snapshot
                                                              .data
                                                              ?.data![
                                                                  sectionIndex]
                                                              .active,
                                                          snapshot
                                                              .data
                                                              ?.data![
                                                                  sectionIndex]
                                                              .imageMobile,
                                                          snapshot
                                                              .data
                                                              ?.data![
                                                                  sectionIndex]
                                                              .link,
                                                        ),
//join-us--------------------------------------------------------------------------
                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'join-us')
                                                        joinUsSection(snapshot
                                                            .data
                                                            ?.data![
                                                                sectionIndex]
                                                            .active),
//new_section---------------------------------------------------------------------------
                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'new_section')
                                                        newSection(
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .active,
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .imageMobile,
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .link),
//news ---------------------------------------------------------------------------
                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'news')
                                                        newsSection(
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .active,
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .imageMobile,
                                                            snapshot
                                                                .data
                                                                ?.data![
                                                                    sectionIndex]
                                                                .link),
//partners--------------------------------------------------------------------------
                                                      if (snapshot
                                                              .data!
                                                              .data![
                                                                  sectionIndex]
                                                              .sectionName ==
                                                          'partners')
                                                        partnersSection(snapshot
                                                            .data
                                                            ?.data![
                                                                sectionIndex]
                                                            .active),
                                                    ],
                                                  )
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                                child: Text('Empty data'));
                                          }
                                        } else {
                                          return Center(
                                              child: Text(
                                                  'State: ${snapshot.connectionState}'));
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ),
          ),
        ));
  }

//search history------------------------------
  Future<void> _showSearch() async {
    endLode
        ? await showSearch(
            context: context,
            delegate: CelebritySearch(
              allCelbrity: allCellbrity,
            ),
          )
        : print('lllllllllloding');
  }

//====================================================
  @override
  bool get wantKeepAlive => true;

  Future<Section> getSectionsData() async {
    try {
      var getSections = await http
          .get(Uri.parse("http://mobile.celebrityads.net/api/sections"));
      if (getSections.statusCode == 200) {
        final body = getSections.body;

        Section sections = Section.fromJson(jsonDecode(body));
        if (category.isNotEmpty) {
          category.clear();
        }
        for (int i = 0; i < sections.data!.length; i++) {
          if (sections.data?[i].sectionName == 'category') {
            category.putIfAbsent(sections.data![i].categoryId!,
                () => fetchCategories(sections.data![i].categoryId!, page));
            setState(() {});
          }
        }
        print('----------------------------------------------------');
        print('statusCode ${getSections.statusCode}');
        print('----------------------------------------------------');

        return sections;
      } else {
        setState(() {
          serverExceptions = false;
        });
        return Future.error('Server Error ${getSections.statusCode}');
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
  }

//------------------------------Slider image-------------------------------------------
  Widget imageSlider(List image, List link) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Swiper(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                // await launch(link[index].toString(), forceWebView: true);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 263.h,
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.r),
                    ),
                  ),
                  child: Stack(
                    children: [
// image------------------------------------------------------------------------------
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.r),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: image[index],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                              child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: white,
                          )),
                          errorWidget: (context, url, error) => Center(
                              child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.black45,
                                  child: const Icon(Icons.error))),
                        ),
                      ),
                    ],
                  )),
            );
          },
          onIndexChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          controller: SwiperController(),
          autoplay: true,
          //duration: 1000,
          autoplayDelay: 5000,
          axisDirection: AxisDirection.right,
          itemCount: image.length,
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
                      )),
                ),
              );
            },
          ),
          // control: SwiperControl(
          //     color: grey, padding: EdgeInsets.only(left: 5.w, right: 5.w)),
        ));
  }
//explorer bottom image--------------------------------------------------------------

  // Widget drowButtom(List<Links>? links, int length) {
  //   return Row(
  //     children: [
  //       // showButton("صور", "assets/image/cam.jpeg"),
  //       // SizedBox(
  //       //   width: 10.w,
  //       // ),
  //       showButton("اكسبلور",
  //           "assets/image/search.jpeg"
  //       ),
  //       SizedBox(
  //         width: 10.w,
  //       ),
  //       showButton("بكسل آدز",
  //           "assets/image/star.jpeg"
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget showButton(String utext,
  //     String image
  //     ) {
  //   return Expanded(
  //       child: gradientContainerNoborder(
  //           105,
  //           Stack(
  //             children: [
  //                // Align(
  //                //   alignment: Alignment.topLeft,
  //                //   child: Image(image: AssetImage(image)),
  //                // ),
  //               Align(
  //                   alignment: Alignment.center,
  //                   child: text(context, utext, 14, white,
  //                       fontWeight: FontWeight.bold)),
  //             ],
  //           ),
  //           reids: 5));
  // }
  Widget drowButtom(list, int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        showButton(list[2].image, list[2].link),
        SizedBox(
          width: 10.w,
        ),
        showButton(list[1].imageMobile, list[1].link, i: 1),
        SizedBox(
          width: 10.w,
        ),
        showButton(list[0].imageMobile, list[0].link),
      ],
    );
  }

  // Widget drowButtom(list, int length) {
  //   return Row(
  //     // mainAxisAlignment: MainAxisAlignment.end,
  //     // crossAxisAlignment: CrossAxisAlignment.end,
  //     children: [
  //       showButton(list[2].image, list[2].link),
  //       SizedBox(
  //         width: 10.67.w,
  //       ),
  //       showButton(list[1].imageMobile, list[1].link),
  //       SizedBox(
  //         width: 9.67.w,
  //       ),
  //       showButton(list[0].imageMobile, list[0].link),
  //     ],
  //   );
  // }
  Widget showButton(String image, String link, {int? i}) {
    return Expanded(
        child: InkWell(
      onTap: () async {
       // getTokenAndData();

        if (i == 1) {
          final navigationState = exploweKey.currentState!;
          navigationState.setPage(0);
        } else {
          print('$link');
          var url = link;
          await launch(url.toString());
        }
      },
      child: Container(
          //width: 100.w,
          decoration: BoxDecoration(
            //  color: Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(5.r),
            ),
          ),
          child: Stack(
            children: [
// image------------------------------------------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(
                      child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: lightGrey.withOpacity(0.5),
                  )),
                  errorWidget: (context, url, error) => Center(
                      child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.black45,
                          child: const Icon(Icons.error))),
                ),
              ),
            ],
          )),
    ));
  }

//--------------------------------------------------------------------------
//   Widget showButton(String image, String link) {
//     return Expanded(
//         child: InkWell(
//       onTap: () async {
//         var url = link;
//         await launch(url.toString(), forceWebView: true);
//       },
//       child: Container(
//           width: 120.33.w,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//                color: Colors.grey,
//               // borderRadius: BorderRadius.all(
//               //   Radius.circular(8.r),
//               // ),
//               ),
//           child: Stack(
//             alignment: AlignmentDirectional.center,
//             children: [
// // image------------------------------------------------------------------------------
//               ClipRRect(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(0.r),
//                 ),
//                 child: Image.network(
//                   image,
//                   // color: black.withOpacity(0.4),
//                   // colorBlendMode: BlendMode.darken,
//                   fit: BoxFit.fitWidth,
//                   height: 60.h,
//                   width: 120.33.w,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) {
//                       return child;
//                     }
//                     return Center(
//                         child: Lottie.asset('assets/lottie/grey.json',
//                             height: 70.h, width: 70.w));
//                   },
//                   errorBuilder: (BuildContext context, Object exception,
//                       StackTrace? stackTrace) {
//                     return const Center(
//                         //     child: Icon(
//                         //   error,
//                         //   size: 30.r,
//                         //   color: red,
//                         // )
//                         );
//                   },
//                 ),
//               ),
//             ],
//           )),
//     ));
//   }

//-----------------------------------------------------------------------------
  Widget jouinFaums(String title, String contint, String buttomText) {
    return gradientContainerNoborder(
        184.5,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 26.h,
            ),
            text(context, title, 18, white, fontWeight: FontWeight.bold),
            SizedBox(
              height: 11.h,
            ),
            text(context, contint, 14, white, fontWeight: FontWeight.bold),
            SizedBox(
              height: 26.h,
            ),
            container(
              28.92,
              87,
              0,
              0,
              black_,
              Center(
                  child: text(context, buttomText, 10, white,
                      fontWeight: FontWeight.bold)),
              bottomLeft: 10,
              bottomRight: 10,
              topLeft: 10,
              topRight: 10,
              pL: 10,
              pR: 10,
            ),
            SizedBox(
              height: 44.h,
            ),
          ],
        ));
  }

//--------------------------------------------------------
  Widget sponsors(String image, String link, int index) {
    return InkWell(
      onTap: () async {
        var url = link;
        await launch(url);
      },
      child: SizedBox(
        height: 90.h,
        width: 180.w,
        child: Card(
          //color: blue,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0.r),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
                child: Image.network(
                  image,
                  //color: black.withOpacity(0.4),
                  //colorBlendMode: BlendMode.darken,
                  fit: BoxFit.fill,
                  height: double.infinity,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                        child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: lightGrey.withOpacity(0.5),
                    ));
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Center(
                        child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.black45,
                            child: const Icon(Icons.error)));
                  },
                ),
              )

              //
              // CachedNetworkImage(
              //   imageUrl: image,
              //   imageBuilder: (context, imageProvider) => Container(
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: imageProvider,
              //         fit: BoxFit.fill,
              //       ),
              //     ),
              //   ),
              //   placeholder: (context, url) => Center(
              //       child: Container(
              //     height: double.infinity,
              //     width: double.infinity,
              //     color: lightGrey.withOpacity(0.5),
              //   )),
              //   errorWidget: (context, url, error) => Center(
              //       child: Container(
              //           height: double.infinity,
              //           width: double.infinity,
              //           color: Colors.black45,
              //           child: const Icon(Icons.error))),
              // ),
              ),
        ),
      ),
    );
  }

//--------------------------------------------------------
  Widget advPanel() {
    return gradientContainerNoborder(
        double.infinity,
        Row(
          children: [
            //logo-----------------------------------------
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Transform.rotate(
                  angle: 45,
                  child: container(
                    80,
                    90,
                    0,
                    0,
                    white,
                    Transform.rotate(
                        angle: -45,
                        child: Image(
                          image: const AssetImage("assets/image/log.png"),
                          fit: BoxFit.cover,
                          height: 52.h,
                          width: 52.w,
                        )),
                    bottomLeft: 25,
                    bottomRight: 25,
                    topLeft: 25,
                    topRight: 25,
                  ),
                ),
              ),
            ),
//join now+text--------------------------------------------------------------
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 28.w, right: 28.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //text----------------------------------------
                        text(context, "منصة المشاهير", 21, white,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          height: 10.h,
                        ),
                        //buttom----------------------------------------
                        container(
                          34,
                          101,
                          0,
                          0,
                          yallow,
                          Center(
                              child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingUp()));
                            },
                            child: text(context, "انضم الان", 17, black,
                                fontWeight: FontWeight.bold),
                          )),
                          bottomLeft: 19,
                          bottomRight: 19,
                          topLeft: 19,
                          topRight: 19,
                          pL: 10,
                          pR: 10,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
        height: 120.h,
        blurRadius: 1);
  }

//categorySection-----------------------------------------
  categorySection(int? categoryId, String? title, int? active) {
    return active == 1
        ? FutureBuilder(
            future: category[categoryId],
            builder: ((context, AsyncSnapshot<Category> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: 5.0.w, right: 5.0.w, top: 60.h, bottom: 4.h),
                  child: SizedBox(
                    height: 300.h,
                    child: Shimmer(
                        enabled: true,
                        gradient: LinearGradient(
                          tileMode: TileMode.mirror,
                          colors: [mainGrey, Colors.white],
                          stops: const [0.1, 0.88],
                        ),
                        child: shapeRow(300, width: 230.w)),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == 'تحقق من اتصالك بالانترنت') {
                    return const Center(child: Text(''));
                  } else {
                    return const Center(child: Text(''));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return snapshot.data!.data!.celebrities!.isNotEmpty
                      ? SizedBox(
                          height: 300.h,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                              child: InkWell(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
//category name-----------------------------------------------------------
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5.0.w,
                                        right: 5.0.w,
                                        top: 20.h,
                                        bottom: 4.h),
                                    child: text(context, title!, 22, black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: ListView.builder(
                                          // controller: scrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data!.data!
                                                  .celebrities!.length +
                                              1,
                                          itemBuilder:
                                              (context, int itemPosition) {
                                            if (snapshot.data!.data!
                                                .celebrities!.isEmpty) {
                                              return const SizedBox();
                                            }
                                            if (itemPosition <
                                                snapshot.data!.data!
                                                    .celebrities!.length) {
//show more -----------------------------------------------------------------------
                                              return SizedBox(
                                                width: 180.w,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CelebrityHome(
                                                                    pageUrl: snapshot
                                                                        .data!
                                                                        .data!
                                                                        .celebrities![
                                                                            itemPosition]
                                                                        .pageUrl!,
                                                                  )));
                                                      // goTopagepush(
                                                      //     context,
                                                      //     CelebrityHome(
                                                      //       pageUrl: snapshot
                                                      //           .data!
                                                      //           .data!
                                                      //           .celebrities![
                                                      //               itemPosition]
                                                      //           .pageUrl!,
                                                      //     ));
                                                    },
                                                    child: Card(
                                                      elevation: 1,
                                                      child: Container(
                                                          decoration: decoration(
                                                              snapshot
                                                                  .data!
                                                                  .data!
                                                                  .celebrities![
                                                                      itemPosition]
                                                                  .image!),
                                                          child: Stack(
                                                            children: [
// image------------------------------------------------------------------------------
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          4.r),
                                                                ),
                                                                child: Image.network(
                                                                  snapshot
                                                                      .data!
                                                                      .data!
                                                                      .celebrities![
                                                                  itemPosition].image!,
                                                                  color: black.withOpacity(0.4),
                                                                  colorBlendMode: BlendMode.darken,
                                                                  fit: BoxFit.cover,
                                                                  height: double.infinity,
                                                                  width: double.infinity,
                                                                  loadingBuilder: (context, child, loadingProgress) {
                                                                    if (loadingProgress == null) {
                                                                      return child;
                                                                    }
                                                                    return Center(
                                                                        child: Container(
                                                                          height: double.infinity,
                                                                          width: double.infinity,
                                                                          color: lightGrey.withOpacity(0.5),
                                                                        ));
                                                                  },
                                                                  errorBuilder: (BuildContext context, Object exception,
                                                                      StackTrace? stackTrace) {
                                                                    return Center(
                                                                        child: Container(
                                                                            height: double.infinity,
                                                                            width: double.infinity,
                                                                            color: Colors.black45,
                                                                            child: const Icon(Icons.error)));
                                                                  },
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    Container(
                                                                  height: 100.h,
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .all(10.0
                                                                            .w),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          snapshot.data!.data!.celebrities![itemPosition].accountStatus!.id == 2
                                                                              ? SizedBox(
                                                                                  width: 0.w,
                                                                                )
                                                                              : Row(
                                                                                  children: [
                                                                                    Image.asset(
                                                                                      'assets/image/Verification.png',
                                                                                      height: 20.r,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5.w,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                          text(
                                                                              context,
                                                                              snapshot.data!.data!.celebrities![itemPosition].name == ''
                                                                                  ? "name"
                                                                                  //:'محمد خالد احمد',
                                                                                  : snapshot.data!.data!.celebrities![itemPosition].name!,
                                                                              15,
                                                                              white,
                                                                              fontWeight: FontWeight.bold,
                                                                              overFlow: TextOverflow.ellipsis),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    )
                                                    //:Container(color: Colors.green,),
                                                    ),
                                              );
//if found more celebraty---------------------------------------------------------------------
                                            } else {
                                              //  lode mor data if pag mor than 2
                                              return snapshot.data!.data!
                                                          .pageCount! >
                                                      1
                                                  ? SizedBox(
                                                      width: 150.w,
                                                      child: InkWell(
                                                        onTap: () {
                                                          goTopagepush(
                                                              context,
                                                              ShowMoreCelebraty(
                                                                title,
                                                                categoryId,
                                                              ));
                                                        },
                                                        child: Card(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Spacer(),
                                                              //Icon More---------------------------------------------------------------------------

                                                              Center(
                                                                child:
                                                                    CircleAvatar(
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color:
                                                                          white,
                                                                      size:
                                                                          30.r,
                                                                    ),
                                                                  ),
                                                                  radius: 30.r,
                                                                  backgroundColor:
                                                                      purple.withOpacity(
                                                                          0.3),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),

                                                              //lode more text----------------------
                                                              text(
                                                                  context,
                                                                  'عرض الكل',
                                                                  14,
                                                                  black
                                                                      .withOpacity(
                                                                          0.8),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox();
                                            }
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                ],
                              )),
                            ),
                          ))
                      : const SizedBox();
                } else {
                  return const Center(
                      child: Center(child: Text('لايوجد مشاهير لعرضهم حاليا')));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }

//headerSection-------------------------------------------
  headerSection(int? active) {
    List<String> image = [];
    List<String> headerLink = [];
    return active == 1
        ? FutureBuilder(
            future: futureHeader,
            builder: ((context, AsyncSnapshot<header> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingData(310, double.infinity);
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));

                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  for (int headerIndex = 0;
                      headerIndex < snapshot.data!.data!.header!.length;
                      headerIndex++) {
                    image.add(
                        snapshot.data!.data!.header![headerIndex].imageMobile!);
                    headerLink
                        .add(snapshot.data!.data!.header![headerIndex].link!);
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        child: SizedBox(
                            height: 263.h,
                            width: double.infinity,
                            child: Stack(
                              children: [
//slider image----------------------------------------------------
                                imageSlider(image, headerLink),
//icon+ logo------------------------------------------------------
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('لايوجد سلايدر لعرضهم حاليا'));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }

//linksSection--------------------------------------------
  linksSection(int? active) {
    return active == 1
        ? FutureBuilder(
            future: futureLinks,
            builder: ((context, AsyncSnapshot<link> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: 10.h, right: 5.w, left: 5.w, bottom: 30.h),
                  child: SizedBox(
                    height: 120.h,
                    child: Shimmer(
                        enabled: true,
                        gradient: LinearGradient(
                          tileMode: TileMode.mirror,
                          colors: [mainGrey, Colors.white],
                          stops: const [0.1, 0.88],
                        ),
                        child: shapeRow(90)),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10.67.w, left: 11.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            height: 55.h,
                            width: MediaQuery.of(context).size.width,
                            child: drowButtom(snapshot.data?.data?.links,
                                snapshot.data!.data!.links!.length)),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  );
                }
                // else if (snapshot.hasData) {
                //   return Padding(
                //     padding: EdgeInsets.only(right: 15.67.w, left: 16.w),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //             height: 60.h,
                //             width: MediaQuery.of(context).size.width,
                //             child: drowButtom(snapshot.data?.data?.links,
                //                 snapshot.data!.data!.links!.length)),
                //         SizedBox(
                //           height: 0.h,
                //         ),
                //       ],
                //     ),
                //   );
                // }
                else {
                  return const Center(
                      // child: Text('لايوجد لينك لعرضهم حاليا')
                      );
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }

//advertisingBannerSection--------------------------------
  advertisingBannerSection(int? active, String? imageUrl, String? link) {
    return active == 1
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.w),
            child: InkWell(
              onTap: () async {
                print(imageUrl);
                var url = link;
                await launch(url!);
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.r),
                    ),
                    //color: Colors.red,
                  ),
                  width: double.infinity,
                  height: 183.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.r),
                    ),
                    child: Image.network(
                      imageUrl!,
                      //color: black.withOpacity(0.4),
                      //colorBlendMode: BlendMode.darken,
                      fit: BoxFit.contain,
                      height: double.infinity,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                            child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: lightGrey.withOpacity(0.5),
                        ));
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Center(
                            child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black45,
                                child: const Icon(Icons.error)));
                      },
                    ),
                  )),
            ),
          )
        : const SizedBox();
  }

//joinUsSection-------------------------------------------
  joinUsSection(int? active) {
    return active != 1
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    height: 226.5.h,
                    child: Padding(
                      padding: EdgeInsets.only(left: 13.0.w, right: 13.0.w),
                      child: Row(
                        children: [
                          Expanded(
                              child: jouinFaums("انضم الان كنجم",
                                  "اضم الينا الان\nوكن جزء منا", "انضم كنجم")),
                          SizedBox(
                            width: 32.w,
                          ),
                          Expanded(
                              child: jouinFaums(
                                  "انضم الان كمستخدم",
                                  "اضم الينا الان\nوكن جزء منا",
                                  "انضم كمستخدم")),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 24.h,
                ),
              ],
            ))
        : const SizedBox();
  }

//partnersSection-----------------------------------------
  partnersSection(int? active) {
    return active == 1
        ? FutureBuilder(
            future: futurePartners,
            builder: ((context, AsyncSnapshot<Partner> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return linkShap(90, width: 175);
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
//---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: text(context, "الرعاة الرسميين", 20, black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: SizedBox(
                              width: double.infinity,
                              height: 90.h,
                              child: ListView.builder(
                                  itemCount:
                                      snapshot.data!.data!.partners!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    return sponsors(
                                        snapshot
                                            .data!.data!.partners![i].image!,
                                        snapshot.data!.data!.partners![i].link!,
                                        i);
                                  })),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('لايوجد رعاة رسمين لعرضهم حاليا'));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }

//new section---------------------------------------------
  newsSection(int? active, String? imageUrl, String? link) {
    return active == 1
        ? imageUrl == ''
            ? const SizedBox()
            : Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.w),
                child: InkWell(
                  onTap: () async {
                    var url = link;
                    await launch(url!);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        color: white,
                      ),
                      width: double.infinity,
                      height: 196.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.r),
                          ),
                          child: Image.network(
                            imageUrl!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return waitingData(196, double.infinity);
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Icon(
                                error,
                                size: 40.r,
                                color: red!,
                              );
                            },
                            fit: BoxFit.cover,
                          ))),
                ),
              )
        : const SizedBox();
  }

//new section---------------------------------------------
  newSection(int? active, String? imageUrl, String? link) {
    return active == 1
        ? imageUrl == ''
            ? const SizedBox()
            : Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.w),
                child: InkWell(
                  onTap: () async {
                    var url = link;
                    await launch(url!);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        color: white,
                      ),
                      width: double.infinity,
                      height: 196.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.r),
                          ),
                          child: Image.network(
                            imageUrl!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return waitingData(196, double.infinity);
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Center(
                                child: Icon(
                                  error,
                                  size: 40.r,
                                  color: red!,
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          ))),
                ),
              )
        : const SizedBox();
  }

//loading methode-----------------------------------------
  Widget lodeing() {
    return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Shimmer(
            enabled: true,
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [mainGrey, Colors.white],
              stops: const [0.1, 0.88],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                waitingData(360, double.infinity),
                //SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(top: 10.h, right: 5.w, left: 5.w),
                  child: SizedBox(
                    height: 90.h,
                    child: Shimmer(
                        enabled: true,
                        gradient: LinearGradient(
                          tileMode: TileMode.mirror,
                          colors: [mainGrey, Colors.white],
                          stops: const [0.1, 0.88],
                        ),
                        child: shapeRow(90)),
                  ),
                ),
                SizedBox(height: 30.h),
                linkShap(180.0),
                SizedBox(height: 10.h),
                // linkShap(180.0),
                // SizedBox(height: 10.h),
                // linkShap(196.0),
              ],
            )));
  }

//--------------------------------------------------------
  shapeRow(double j, {double width = 354}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.r))),
            width: width.w,
            height: j.h,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.r))),
            width: 354.w,
            height: j.h,
          ),
        ),
        // SizedBox(
        //   width: 10.w,
        // ),
        // Expanded(
        //   child: Container(
        //     decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.all(Radius.circular(5.r))),
        //     width: 354.w,
        //     height: j.h,
        //   ),
        // )
      ],
    );
  }

//--------------------------------------------------------
  linkShap(double height, {double width = 354}) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: SizedBox(
        height: height.h,
        child: Shimmer(
            enabled: true,
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [mainGrey, Colors.white],
              stops: const [0.1, 0.88],
            ),
            child: shapeRow(height, width: width)),
      ),
    );
  }

//--------------------------------------------------------
  Future onRefresh() async {
    setState(() {
      sections = getSectionsData();
      futureLinks = fetchLinks();
      futureHeader = fetchHeader();
      futurePartners = fetchPartners();
      //getIsCompliteProfile();
      getAllCelebrity();
    });
  }

//--------------------------------------------------------
  Widget search() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SizedBox(
          height: 60.h,
          width: double.infinity,
          // color: red,
          //margin: EdgeInsets.only(top: 15.h),
          child: Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 0.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            color: Colors.grey[50],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                        height: 105.h,
                        width: 190.w,
                        child: const Image(
                          image: AssetImage(
                            "assets/image/final-logo.png",
                          ),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),

                currentuser == 'user'
                    ? Expanded(
                        flex: 1,
                        child: InkWell(
                          child: GradientIcon(Icons.add, 40, gradient()),
                          onTap: () {
                            goTopagepush(context, buildAdvOrder());
                          },
                        ))
                    : const SizedBox(),
                InkWell(
                  child: GradientIcon(Icons.search, 35.sp, gradient()),
                  onTap: () {
                    endLode ? _showSearch() : print('loading');
                  },
                ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }

//search for celebrity--------------------------------------------------------
  Future getAllCelebrity() async {
    try {
      var getSections = await http
          .get(Uri.parse("https://mobile.celebrityads.net/api/celebrities"));
      if (getSections.statusCode == 200) {
        final body = getSections.body;
        AllCelebrities celebrity = AllCelebrities.fromJson(jsonDecode(body));
        setState(() {
          endLode = true;
        });
        return celebrity.data!.celebrities;
      } else {
        return Future.error('serverExceptions');
      }
    } catch (e) {
      if (e is SocketException) {
        isConnectSection = false;
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
        timeoutException = false;
        return Future.error('TimeoutException');
      } else {
        serverExceptions = false;
        return Future.error('serverExceptions');
      }
    }
  }

  Future<void> getTok() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    print(
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('deviceToken is $deviceToken');
    print(
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  }

//get Recent Searches Celebrity---------------------------
  getDotSize(List image) {
    return List.generate(
      image.length,
      (index) => Size(25.0.w, 4.2.h),
    );
  }

  getIsCompliteProfile() async {
    setState(() {
      isCompleteProfile = futureCheckData?.profile;
      isCompleteContract = futureCheckData?.contract;
      isCompletePrise = futureCheckData?.price;
      isCompleteVerify = futureCheckData?.verified;
      valueNotifier.value = 0;
    });
    print('/////////////////////////////////////////////////////');
    print('userType:${futureCheckData?.userType}');
    print('profile:$isCompleteProfile');
    print('price:$isCompletePrise');
    print('contract:$isCompleteContract');
    print('verified:$isCompleteVerify');
    print('status:${futureCheckData?.status}');

    if (futureCheckData?.userType == 'user') {
      checkComplete = [];
      checkComplete.add(isCompleteProfile!);
    } else {
      checkComplete = [];
      checkComplete.add(isCompleteProfile!);
      checkComplete.add(isCompletePrise!);
      checkComplete.add(isCompleteContract!);
      checkComplete.add(isCompleteVerify!);
    }
    print('/////////////////////////////////////////////////////');

    if (futureCheckData?.userType == 'user') {
      for (int i = 0; i < checkComplete.length; i++) {
        if (checkComplete.elementAt(i) == true) {
          setState(() {
            valueNotifier.value = valueNotifier.value + 100.0;
          });
        }
      }
    } else {
      for (int i = 0; i < checkComplete.length; i++) {
        if (checkComplete.elementAt(i) == true) {
          setState(() {
            valueNotifier.value = valueNotifier.value + 25.0;
          });
        }
      }
    }

    print(checkComplete);
    print('%:${valueNotifier.value}');
    await Future.delayed(const Duration(milliseconds: 4000));
    return futureCheckData?.status == 200 && valueNotifier.value < 100.0
        ? showModal(
            configuration: const FadeScaleTransitionConfiguration(
              transitionDuration: Duration(milliseconds: 500),
              reverseTransitionDuration: Duration(milliseconds: 500),
            ),
            context: context,
            //nKey.currentContext!

            builder: (context2) => AlertDialog(
                  contentPadding: EdgeInsets.all(15.r),
                  insetPadding: EdgeInsets.all(20.r),
                  title: Center(
                    child: text(context, 'ملفك الشخصي لم يكتمل', 19, black,
                        fontWeight: FontWeight.bold),
                  ),
                  content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
//progress bar============================================================
                          text(
                              context,
                              'الرجاء اكمال المعلومات الاتية لاستقبال وعرض الطلبات',
                              18,
                              black.withOpacity(0.9),
                              align: TextAlign.right),
                          SizedBox(height: 15.h),
//progress bar============================================================
                          SimpleCircularProgressBar(
                            valueNotifier: valueNotifier,
                            mergeMode: true,
                            progressStrokeWidth: 8.r,
                            backStrokeWidth: 8.r,
                            size: 130.sp,
                            animationDuration: 4,
                            progressColors: const [
                              Color(0xff0ab3d0),
                              purple,
                              Color(0xffe468ca),
                            ],
                            backColor: Colors.grey.withOpacity(0.5),
                            onGetText: (double value) {
                              return Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
//information============================================================
                          info('اكمل بيانات المعلومات الشخصية', nameIcon,
                              isComplete: isCompleteProfile),
                          SizedBox(
                              height: futureCheckData?.userType == 'user'
                                  ? 0
                                  : 10.h),

                          info('اصدار العقد مع المنصة في قسم العقود',
                              contractIcon,
                              isComplete: isCompleteContract),

                          SizedBox(
                              height: futureCheckData?.userType == 'user'
                                  ? 0
                                  : 10.h),
                          info('اضافة عرض سعر الطلبات', price,
                              isComplete: isCompletePrise),
                          SizedBox(
                              height: futureCheckData?.userType == 'user'
                                  ? 0
                                  : 10.h),
                          info('رفع ملف التوثيق', verifyIcon,
                              isComplete: isCompleteVerify),
                        ],
                      )),
//bottoms===========================================================================
                  actions: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: buttoms(context2, 'ذكرني لاحق', 14, white, () {
                            Navigator.pop(context2);
                          }, backgrounColor: Colors.grey),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                            child: buttoms(
                          context2,
                          'اكمل البيانات',
                          14,
                          white,
                          () {
                            final navigationState = exploweKey.currentState!;
                            Navigator.pop(context2);
                            navigationState.setPage(4);
                          },
                          backgrounColor: purple.withOpacity(0.5),
                        )),
                      ],
                    )
                  ],
                ))
        : '';
  }

//==============================================================
  info(String name, IconData icon, {bool? isComplete}) {
    return isComplete != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: purple),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: text(context, name, 17, black.withOpacity(0.8),
                          align: TextAlign.right),
                    ),
                  ],
                ),
              ),
              Icon(
                isComplete ? Icons.check_circle : Icons.cancel,
                color: isComplete ? purple : Colors.grey.withOpacity(0.5),
              ),
            ],
          )
        : const SizedBox();
  }

  getTokenAndData() async {
    token = await DatabaseHelper.getToken();
    futureCheckData = await fetchCheckData(token);
    getIsCompliteProfile();
  }

//====================================================================

}
