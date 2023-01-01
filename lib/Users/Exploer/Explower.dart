//Explor-------------------------------------------------------------------------------------------------

import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../Account/LoggingSingUpAPI.dart';
import 'ExploerApi.dart';
import 'showViduo.dart';
import 'package:http/http.dart' as http;

class Explower extends StatefulWidget {
  const Explower({Key? key}) : super(key: key);

  @override
  State<Explower> createState() => _ExplowerState();
}

class _ExplowerState extends State<Explower> {
  VideoPlayerController? _controller;
  bool isSelect = false;
  int liksCounter = 100;
  bool hasMore = true;
  bool isLoading = false;
  int page = 1;
  int pageCount = 2;
  bool empty = false;
  bool isConnectSection = true;
  bool _isFirstLoadRunning = false;
  bool timeoutException = true;
  bool serverExceptions = true;
  ScrollController scrollController = ScrollController();
  List<Explorer> oldCelebraty = [];
  String token = '';
  @override
  void initState() {
    super.initState();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        token = value;
        fetchAnotherExplorer();
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          hasMore == false) {
        // print('getNew Data');
        fetchAnotherExplorer();
      }
    });
  }

//refresh list------------------------------------------------------------------
  Future refresh() async {
    setState(() {
      hasMore = true;
      isLoading = false;
      page = 1;
      oldCelebraty.clear();
    });
    fetchAnotherExplorer();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        color: white,
        backgroundColor: purple,
        onRefresh: refresh,
        child: Scaffold(
            appBar: AppBarNoIcon("اكسبلور"),
            body: isConnectSection == false
                ? Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: internetConnection(context, reload: () {
                        setState(() {
                          refresh();
                          isConnectSection = true;
                        });
                      }),
                    ),
                  )
                : timeoutException == false
                    ? Align(
                        alignment: Alignment.center,
                        child: checkTimeOutException(context, reload: () {
                          setState(() {
                            refresh();
                            timeoutException = true;
                          });
                        }),
                      )
                    : serverExceptions == false
                        ? Align(
                            alignment: Alignment.center,
                            child: checkServerException(context, reload: () {
                              setState(() {
                                refresh();
                                serverExceptions = true;
                              });
                            }),
                          )
                        : _isFirstLoadRunning == false && page == 1
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: 100.h, left: 10.w, right: 10.w),
                                child:Center(child: mainLoad(context) ,),
                                //lodeManyCards(),
                              )
                            : Padding(
                                padding: EdgeInsets.all(12.h),
                                child: empty
                                    ? noExplorer(context)
                                    : Column(
                                        children: [
//icon and text-----------------------------------------------------
                                          Expanded(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: text(
                                                        context,
                                                        "اكسبلور الاعلانات",
                                                        20,
                                                        black)),
                                              ])),
//view data-----------------------------------------------------

                                          Expanded(
                                              flex: 6,
                                              child: CustomScrollView(
                                                controller: scrollController,
                                                slivers: [
                                                  SliverGrid(
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  2, //عدد العناصر في كل صف
                                                              crossAxisSpacing: 13
                                                                  .h, // المسافات الراسية
                                                              childAspectRatio:
                                                                  0.70, //حجم العناصر
                                                              mainAxisSpacing: 13
                                                                  .w //المسافات الافقية

                                                              ),
                                                      delegate:
                                                          SliverChildBuilderDelegate(
                                                        (BuildContext context,
                                                            int index) {
                                                          return viewCard(
                                                              oldCelebraty,
                                                              index);
                                                        },
                                                        childCount:
                                                            oldCelebraty.length,
                                                      )),

//show loading when get data from api--------------------------------------------------------------------------------------------
                                                  SliverList(
                                                      delegate:
                                                          SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                                      return isLoading &&
                                                              pageCount >=
                                                                  page &&
                                                              oldCelebraty
                                                                  .isNotEmpty
                                                          ? showLode()
                                                          : const SizedBox();
                                                    },
                                                    childCount: 1,
                                                  )),
                                                ],
                                              )),
                                          SizedBox(height: 55.h),
                                        ],
                                      ))),
      ),
    );
  }

//----------------view data method-------------------------------------------------------------------------------
  Widget viewCard(List<Explorer> oldCelebraty, int index) {
    return InkWell(
        onTap: () {
          goToPagePushRefresh(
              context,
              ShowVideo(
                  token: token,
                  thumbnail: oldCelebraty[index].vedio!.thumbnail!,
                  image: oldCelebraty[index].celebrity!.image!,
                  pageURL: oldCelebraty[index].celebrity!.pageUrl!,
                  videoURL: oldCelebraty[index].vedio!.image!,
                  videoId: oldCelebraty[index].vedio!.id!,
                  videoLikes: oldCelebraty[index].vedio!.likes!),
              then: (value) {
            if (isBressLike) {
              setState(() {
                refresh();
                isBressLike = false;
              });
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: black.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(5.h),
            ),
          ),
          child: Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(5.h),
              ),
              child: Image.network(
                oldCelebraty[index].vedio!.thumbnail!,
                color: black.withOpacity(0.2),
                colorBlendMode: BlendMode.darken,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                      child: Lottie.asset('assets/lottie/grey.json',
                          height: 70.h, width: 70.w));
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Center(
                    child: Icon(
                      error,
                      size: 40.r,
                      color: red,
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    GradientIcon(Icons.play_arrow, 40.sp, gradient()),
                    text(context, "${oldCelebraty[index].vedio!.views}", 15,
                        white,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            )
          ]),
        ));
  }

//pagination---------------------------------------------------------------------------------
  fetchAnotherExplorer() async {
    // try {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
      _isFirstLoadRunning = false;
    });

    print('pageApi $pageCount pagNumber $page');

    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/explorer?page=$page'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        final body = response.body;
        TrendExplorer explorer = TrendExplorer.fromJson(jsonDecode(body));
        var newItem = explorer.data!.explorer!;
        pageCount = explorer.data!.pageCount!;
        print('length ${newItem.length}');
        if (!mounted) return;
        setState(() {
          if (newItem.isNotEmpty) {
            hasMore = newItem.isEmpty;
            oldCelebraty.addAll(newItem);
            isLoading = false;
            _isFirstLoadRunning = true;
            page++;
          } else if (newItem.isEmpty && page == 1) {
            _isFirstLoadRunning = true;
            empty = true;
          }
        });
      }else{
        setState(() {
          serverExceptions = false;
        });
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
      } else if (e is TimeoutException) {
        setState(() {
          timeoutException = false;
        });
      } else {
        setState(() {
          serverExceptions = false;
        });
      }
    }
  }

  Widget showLode() {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 10.h),
      child: const Center(child: CircularProgressIndicator()),
    );
    // return Padding(
    //   padding: EdgeInsets.only(top: 13.h),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       SizedBox(
    //         width: 190.w,
    //         height: 200.h,
    //         child: Shimmer(
    //             enabled: true,
    //             gradient: LinearGradient(
    //               tileMode: TileMode.mirror,
    //               // begin: Alignment(0.7, 2.0),
    //               //end: Alignment(-0.69, -1.0),
    //               colors: [mainGrey, Colors.white],
    //               stops: const [0.1, 0.88],
    //             ),
    //             child: Card()),
    //       ),
    //       SizedBox(
    //         width: 190.w,
    //         height: 200.h,
    //         child: Shimmer(
    //             enabled: true,
    //             gradient: LinearGradient(
    //               tileMode: TileMode.mirror,
    //               // begin: Alignment(0.7, 2.0),
    //               //end: Alignment(-0.69, -1.0),
    //               colors: [mainGrey, Colors.white],
    //               stops: const [0.1, 0.88],
    //             ),
    //             child: const Card()),
    //       ),
    //     ],
    //   ),
    // );
  }
}
