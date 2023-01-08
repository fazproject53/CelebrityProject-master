import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../../Account/LoggingSingUpAPI.dart';
import 'GiftApi.dart';
import 'GiftDetials.dart';

class Gift extends StatefulWidget {
  const Gift({Key? key}) : super(key: key);

  @override
  State<Gift> createState() => _GiftState();
}

class _GiftState extends State<Gift> with AutomaticKeepAliveClientMixin {
  String token = '';

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool _isFirstLoadRunning = false;
  bool hasMore = true;
  bool isLoading = false;
  int page = 1;
  int pageCount = 2;
  bool empty = false;
  int? newItemLength;
  List<GiftOrders> oldAdvertisingOrder = [];
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        token = value;
        getGiftingOrders(token);
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          hasMore == false) {
        print('getNew Data');
        getGiftingOrders(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: refreshRequest,
      child: isConnectSection == false
          ? Center(
              child: internetConnection(context, reload: () {
                setState(() {
                  refreshRequest();
                  isConnectSection = true;
                });
              }),
            )
          : timeoutException == false
              ? Center(
                  child: checkTimeOutException(context, reload: () {
                    setState(() {
                      refreshRequest();
                      timeoutException = true;
                    });
                  }),
                )
              : serverExceptions == false
                  ? Center(
                      child: checkServerException(context, reload: () {
                        setState(() {
                          refreshRequest();
                          serverExceptions = true;
                        });
                      }),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: empty
                          ? noData(context)
                          : _isFirstLoadRunning == false && page == 1
                              ? firstLode(double.infinity, 160)
                              : NotificationListener<
                                  OverscrollIndicatorNotification>(
                                  onNotification:
                                      (OverscrollIndicatorNotification?
                                          overscroll) {
                                    overscroll!.disallowGlow();
                                    return true;
                                  },
                                  child: ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      itemCount: oldAdvertisingOrder.length + 1,
                                      itemBuilder: (context, i) {
                                        if (oldAdvertisingOrder.length > i) {
                                          return InkWell(
                                              onTap: () {
                                                goToPagePushRefresh(
                                                    context,
                                                    GiftDetials(
                                                      i: i,
                                                      price:
                                                          oldAdvertisingOrder[i]
                                                              .price,
                                                      description:
                                                          oldAdvertisingOrder[i]
                                                              .description,
                                                      advTitle:
                                                          oldAdvertisingOrder[i]
                                                              .occasion
                                                              ?.name,
                                                      type:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .type,
                                                      advType:
                                                          oldAdvertisingOrder[i]
                                                              .giftType
                                                              ?.name,
                                                      orderId:
                                                          oldAdvertisingOrder[i]
                                                              .id,
                                                      token: token,
                                                      state:
                                                          oldAdvertisingOrder[i]
                                                              .status
                                                              ?.id,
                                                      rejectResonName:
                                                          oldAdvertisingOrder[i]
                                                              .rejectReson
                                                              ?.name!,
                                                      rejectResonId:
                                                          oldAdvertisingOrder[i]
                                                              .rejectReson
                                                              ?.id,
                                                      from:
                                                          oldAdvertisingOrder[i]
                                                              .from!,
                                                      to: oldAdvertisingOrder[i]
                                                          .to!,
                                                      userId:
                                                          oldAdvertisingOrder[i]
                                                              .user!
                                                              .id!,
                                                      userName:
                                                          oldAdvertisingOrder[i]
                                                              .user!
                                                              .name,
                                                      userImage:
                                                          oldAdvertisingOrder[i]
                                                              .user!
                                                              .image!,
                                                    ), then: (value) {
                                                  if (clickGift) {
                                                    setState(() {
                                                      refreshRequest();
                                                      clickGift = false;
                                                    });
                                                  }
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  getData(
                                                      i, oldAdvertisingOrder),
                                                ],
                                              ));
                                        } else {
                                          return isLoading &&
                                                  pageCount >= page &&
                                                  oldAdvertisingOrder.isNotEmpty
                                              ? lodeOneData()
                                              : const SizedBox();
                                        }
                                      }),
                                )),
    );
  }

  //----------------------------------------------------------------------
  Future refreshRequest() async {
    setState(() {
      hasMore = true;
      isLoading = false;
      page = 1;
      oldAdvertisingOrder.clear();
    });
    getGiftingOrders(token);
  }

  //----------------------------------------------------------------------
  Future getGiftingOrders(String token) async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
      _isFirstLoadRunning = false;
    });
    print('pageApi $pageCount pagNumber $page');
    String url =
        "https://mobile.celebrityads.net/api/celebrity/GiftOrders?page=$page";
    try {
      final respons = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (respons.statusCode == 200) {
        final body = respons.body;
        Gifting advertising = Gifting.fromJson(jsonDecode(body));
        print('=========================================');
        print(body);
        print('=========================================');
        var newItem = advertising.data!.giftOrders!;
        pageCount = advertising.data!.pageCount!;
        print('length ${newItem.length}');
        if (!mounted) return;
        setState(() {
          if (newItem.isNotEmpty) {
            hasMore = newItem.isEmpty;
            oldAdvertisingOrder.addAll(newItem);
            isLoading = false;
            newItemLength = newItem.length;
            _isFirstLoadRunning = true;
            page++;
          } else if (newItem.isEmpty && page == 1) {
            _isFirstLoadRunning = true;
            empty = true;
          }
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
  } //refreshRequest-----------------------------------------------------------------

  Widget getData(int i, List<GiftOrders>? giftOrders) {
    return container(
        160,
        double.infinity,
        18,
        18,
        Colors.white,
        Column(
          children: [
//image------------------------------------------------------------------------------------
            Expanded(
              flex: 2,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.h),
                    ),
                  ),
                  child: Stack(
                    children: [
// image------------------------------------------------------------------------------
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        child: Image.network(
                          giftOrders![i].occasion!.image!,
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
                        // CachedNetworkImage(
                        //   imageUrl:   giftOrders![i].occasion!.image!,
                        //   imageBuilder: (context, imageProvider) =>
                        //       Container(
                        //         decoration: BoxDecoration(
                        //           image: DecorationImage(
                        //               image: imageProvider,
                        //               fit: BoxFit.cover,
                        //               colorFilter: ColorFilter.mode(
                        //                   black.withOpacity(0.4),
                        //                   BlendMode.darken)),
                        //         ),
                        //       ),
                        //   placeholder: (context, url) => Center(
                        //       child: Lottie.asset('assets/lottie/grey.json',
                        //           height: 70.h, width: 70.w)),
                        //   errorWidget: (context, url, error) => Center(
                        //       child: Container(
                        //           height: double.infinity,
                        //           width: double.infinity,
                        //           color: Colors.black45,
                        //           child: const Icon(Icons.error))),
                        // ),
                      ),

//status-----------------------------------------------------------------------------------

                      Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: text(
                                  context,
                                  giftOrders[i].status!.name!,
                                  textTitleSize,
                                  white,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
// occasion name---------------------------------------------------------------------------------

                          Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 16.w, bottom: 10.h),
                                  child: text(
                                    context,
                                    "اهداء ل" + giftOrders[i].occasion!.name!,
                                    textTitleSize,
                                    white,
                                    fontWeight: FontWeight.bold,
                                  ))),
//date and icon---------------------------------------------------------------------------------
                          const Spacer(),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 16.w, bottom: 10.h),
                                child: text(
                                  context,
                                  giftOrders[i].date!,
                                  textTitleSize,
                                  white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),

                          SizedBox(width: 10.w),
                        ],
                      )
                    ],
                  )),
            ),

//details-------------------------------------------------------------------------------
          ],
        ),
        bottomLeft: 10,
        bottomRight: 10,
        topLeft: 10,
        topRight: 10,
        marginB: 15,
        blur: 5,
        marginT: 5);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
/*
*
*
* */
