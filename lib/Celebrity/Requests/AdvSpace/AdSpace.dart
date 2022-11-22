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
import 'AdSpaceApi.dart';
import 'AdSpaceDetails.dart';

class AdSpace extends StatefulWidget {
  @override
  State<AdSpace> createState() => _AdSpaceState();
}

class _AdSpaceState extends State<AdSpace> with AutomaticKeepAliveClientMixin {
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
  List<AdSpaceOrders> oldAdvertisingOrder = [];
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        token = value;
        getAdSpaceOrder(token);
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          hasMore == false) {
        print('getNew Data');
        getAdSpaceOrder(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: oldAdvertisingOrder.length + 1,
                                  itemBuilder: (context, i) {
                                    if (oldAdvertisingOrder.length > i) {
                                      return InkWell(
                                          onTap: () {
                                            goToPagePushRefresh(
                                                context,
                                                AdSpaceDetails(
                                                  celerityCityName: '${oldAdvertisingOrder[i].celebrity!.city?.name!}',
                                                  celerityEmail: oldAdvertisingOrder[i].celebrity!.email!,
                                                  celerityIdNumber: oldAdvertisingOrder[i].celebrity!.idNumber!,
                                                  celerityName:  oldAdvertisingOrder[i].celebrity!.name!,
                                                  celerityNationality: '${oldAdvertisingOrder[i].celebrity!.nationality?.countryArNationality}',
                                                  celerityPhone: oldAdvertisingOrder[i].celebrity!.phonenumber!,
                                                  celerityVerifiedNumber:  oldAdvertisingOrder[i].celebrity!.commercialRegistrationNumber!,
                                                  celerityVerifiedType:oldAdvertisingOrder[i].celebrity?.celebrityType=='person'?'رخصة إعلانية':'سجل تجاري',
                                                  userCityName:  '${oldAdvertisingOrder[i].user!.city?.name!}',
                                                  userEmail: oldAdvertisingOrder[i].user!.email!,
                                                  userIdNumber:  oldAdvertisingOrder[i].user!.idNumber!,
                                                  userNationality:  '${oldAdvertisingOrder[i].user!.nationality?.countryArNationality}',
                                                  userPhone:  oldAdvertisingOrder[i].user!.phonenumber!,
                                                  userVerifiedNumber: oldAdvertisingOrder[i].user!.commercialRegistrationNumber!,
                                                  userVerifiedType:  'سجل تجاري',

                                                  i: i,
                                                  commercialRecord:
                                                      oldAdvertisingOrder[i]
                                                          .commercialRecord,
                                                  image: oldAdvertisingOrder[i]
                                                      .image,
                                                  link: oldAdvertisingOrder[i]
                                                      .link,
                                                  price: oldAdvertisingOrder[i]
                                                      .price,
                                                  orderId:
                                                      oldAdvertisingOrder[i].id,
                                                  token: token,
                                                  state: oldAdvertisingOrder[i]
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
                                                  userId: oldAdvertisingOrder[i]
                                                      .user!
                                                      .id!,
                                                  userName:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .name!,
                                                  userImage:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .image,
                                                          advDate:  oldAdvertisingOrder[i].date!,
                                                          singture: "${oldAdvertisingOrder[i].contract?.userSignature}",
                                                          celeritySigntion:"${oldAdvertisingOrder[i].contract?.celebritySignature}",
                                                ), then: (value) {
                                              if (clickAdvSpace) {
                                                setState(() {
                                                  refreshRequest();
                                                  clickAdvSpace = false;
                                                });
                                              }
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              getData(i, oldAdvertisingOrder),
                                            ],
                                          ));
                                    } else {
                                      return isLoading &&
                                              pageCount >= page &&
                                              oldAdvertisingOrder.isNotEmpty
                                          ? lodeOneData()
                                          : const SizedBox();
                                    }
                                  })),
    );
  }

//----------------------------------------------------------------------------------------
  Widget getData(int i, List<AdSpaceOrders>? adSpaceOrders) {
    return container(
        160,
        double.infinity,
        18,
        18,
        Colors.white,
        Column(
          children: [
//image----------------------
//
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
                        child: CachedNetworkImage(
                          imageUrl: adSpaceOrders![i].image!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      black.withOpacity(0.4),
                                      BlendMode.darken)),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                              child: Lottie.asset('assets/lottie/grey.json',
                                  height: 70.h, width: 70.w)),
                          errorWidget: (context, url, error) => Center(
                              child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.black45,
                                  child: const Icon(Icons.error))),
                        ),

                        // Image.network(
                        //   adSpaceOrders![i].image!,
                        //   color: black.withOpacity(0.4),
                        //   colorBlendMode: BlendMode.darken,
                        //   fit: BoxFit.cover,
                        //   height: double.infinity,
                        //   width: double.infinity,
                        //   loadingBuilder: (context, child, loadingProgress) {
                        //     if (loadingProgress == null) {
                        //       return child;
                        //     }
                        //     return Center(
                        //         child: Lottie.asset('assets/lottie/grey.json',
                        //             height: 70.h, width: 70.w));
                        //   },
                        //   errorBuilder: (BuildContext context, Object exception,
                        //       StackTrace? stackTrace) {
                        //     return Center(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Icon(
                        //             Icons.sync_problem,
                        //             size: 25.r,
                        //             color: pink,
                        //           ),
                        //           text(
                        //             context,
                        //             '  اضغط لاعادة تحميل الصورة',
                        //             12,
                        //             Colors.grey,
                        //           )
                        //         ],
                        //       ),
                        //     );
                        //   },
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
                                  adSpaceOrders[i].status!.name!,
                                  textTitleSize,
                                  white,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
// user name---------------------------------------------------------------------------------

                          Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 16.w, bottom: 10.h),
                                  child: text(
                                    context,
                                    'اعلان من ' + adSpaceOrders[i].user!.name!,
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
                                  adSpaceOrders[i].date!,
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

//get Advertising Orders------------------------------------------------------------------------
  Future getAdSpaceOrder(String token) async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
      _isFirstLoadRunning = false;
    });
    print('pageApi $pageCount pagNumber $page');
    String url =
        "https://mobile.celebrityads.net/api/celebrity/AdSpaceOrders?page=$page";
    try {
      final respons = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (respons.statusCode == 200) {
        final body = respons.body;
        AdSpaceOrder advertising = AdSpaceOrder.fromJson(jsonDecode(body));
        var newItem = advertising.data!.adSpaceOrders!;
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

  Future refreshRequest() async {
    setState(() {
      hasMore = true;
      isLoading = false;
      page = 1;
      oldAdvertisingOrder.clear();
    });
    getAdSpaceOrder(token);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
