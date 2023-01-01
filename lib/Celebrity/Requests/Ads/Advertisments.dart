import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Account/LoggingSingUpAPI.dart';
import 'package:celepraty/Celebrity/Requests/Ads/AdvertisinApi.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'AdvDetials.dart';

class Advertisment extends StatefulWidget {
  @override
  State<Advertisment> createState() => _AdvertismentState();
}

class _AdvertismentState extends State<Advertisment>
    with AutomaticKeepAliveClientMixin {
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
  List<AdvertisingOrders> oldAdvertisingOrder = [];
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    DatabaseHelper.getToken().then((value) {
      setState(() {
        token = value;

        getAdvertisingOrder(token);
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          hasMore == false) {
        print('getNew Data');
        getAdvertisingOrder(token);
      }
    });
  }

//--------------------------------------------------------------------------------
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
                              ? firstLode(double.infinity, 200)
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: oldAdvertisingOrder.length + 1,
                                  itemBuilder: (context, i) {
                                    if (oldAdvertisingOrder.length > i) {
                                      return InkWell(
                                          onTap: () {
                                            goToPagePushRefresh(
                                                context,
                                                AdvDetials(
                                                  i: i,
                                                  time: oldAdvertisingOrder[i]
                                                      .adTiming!
                                                      .name!,
                                                  celerityCityName:
                                                      '${oldAdvertisingOrder[i].celebrity!.city?.name!}',
                                                  celerityEmail:
                                                      oldAdvertisingOrder[i]
                                                          .celebrity!
                                                          .email!,
                                                  celerityIdNumber:
                                                      oldAdvertisingOrder[i]
                                                          .celebrity!
                                                          .idNumber!,
                                                  celerityName:
                                                      oldAdvertisingOrder[i]
                                                          .celebrity!
                                                          .name!,
                                                  celerityNationality:
                                                      '${oldAdvertisingOrder[i].celebrity!.nationality?.countryArNationality}',
                                                  celerityPhone:
                                                      oldAdvertisingOrder[i]
                                                          .celebrity!
                                                          .phonenumber!,
                                                  celerityVerifiedNumber:
                                                      oldAdvertisingOrder[i]
                                                          .celebrity!
                                                          .commercialRegistrationNumber!,
                                                  celerityVerifiedType:
                                                      oldAdvertisingOrder[i]
                                                                  .celebrity
                                                                  ?.celebrityType ==
                                                              'person'
                                                          ? 'رخصة إعلانية'
                                                          : 'سجل تجاري',
                                                  userCityName:
                                                      '${oldAdvertisingOrder[i].user!.city?.name!}',
                                                  userEmail:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .email!,
                                                  userIdNumber:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .idNumber!,
                                                  userNationality:
                                                      '${oldAdvertisingOrder[i].user!.nationality?.countryArNationality}',
                                                  userPhone:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .phonenumber!,
                                                  userVerifiedNumber:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .commercialRegistrationNumber!,
                                                  userVerifiedType:
                                                      oldAdvertisingOrder[i]
                                                                  .adOwner!
                                                                  .name ==
                                                              'فرد'
                                                          ? 'وثيقة عمل حر'
                                                          : 'سجل تجاري',
                                                  sendDate: DateTime.now(),
                                                  commercialRecord:
                                                      oldAdvertisingOrder[i]
                                                          .commercialRecord,
                                                  owner: oldAdvertisingOrder[i]
                                                      .adOwner
                                                      ?.name,
                                                  image: oldAdvertisingOrder[i]
                                                      .file,
                                                  advTitle:
                                                      oldAdvertisingOrder[i]
                                                          .advertisingAdType!
                                                          .name,
                                                  description:
                                                      oldAdvertisingOrder[i]
                                                          .description,
                                                  orderId:
                                                      oldAdvertisingOrder[i].id,
                                                  token: token,
                                                  platform:
                                                      oldAdvertisingOrder[i]
                                                          .platform
                                                          ?.name,
                                                  state: oldAdvertisingOrder[i]
                                                      .status
                                                      ?.id,
                                                  price: oldAdvertisingOrder[i]
                                                      .price,
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
                                                          .name,
                                                  userImage:
                                                      oldAdvertisingOrder[i]
                                                          .user!
                                                          .image,
                                                  advDate:
                                                      oldAdvertisingOrder[i]
                                                          .date!,
                                                  singture: "",
                                                  celeritySigntion: "",
                                                ), then: (value) {
                                              if (clickAdv) {
                                                setState(() {
                                                  refreshRequest();
                                                  clickAdv = false;
                                                });
                                              }
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              body(i, oldAdvertisingOrder),
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

  Widget body(int i, List<AdvertisingOrders>? advertisingOrders) {
    return advertisingOrders!.isNotEmpty
        ? container(
            200,
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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.h),
                          topRight: Radius.circular(10.h),
                        ),
                      ),
//status-----------------------------------------------------------------------------------

                      child: Stack(
                        children: [
// image------------------------------------------------------------------------------
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r)),
                            child: CachedNetworkImage(
                              imageUrl: advertisingOrders[i].file!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: text(
                                      context,
                                      advertisingOrders[i].status!.name!,
                                      textTitleSize,
                                      white,
                                      fontWeight: FontWeight.bold,
                                    ))),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
// Is attendance required or not?---------------------------------------------------------------------------------

                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.r),
                                      child: text(
                                        context,
                                        advertisingOrders[i].adFeature!.name!,
                                        textTitleSize,
                                        white,
                                        fontWeight: FontWeight.bold,
                                      ))),
//date and icon---------------------------------------------------------------------------------
                              const Spacer(),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: text(
                                    context,
                                    advertisingOrders[i].date!,
                                    textTitleSize,
                                    white,
                                    fontWeight: FontWeight.bold,
                                  )),

                              SizedBox(width: 10.w),
                            ],
                          )
                        ],
                      )),
                ),

//details-----------------------------------------------------------------------------------------------------

                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: text(
                                      context,
                                      "النوع",
                                      textDetails,
                                      black,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: text(
                                        context,
                                        advertisingOrders[i]
                                            .advertisingAdType!
                                            .name!,
                                        textDetails,
                                        pink,
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                        divider(),
//owner-------------------------------------------------------------------------------------------

                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: text(
                                      context,
                                      "المالك",
                                      textDetails,
                                      black,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: text(
                                        context,
                                        advertisingOrders[i].adOwner!.name!,
                                        textDetails,
                                        pink,
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                        divider(),
//time----------------------------------------------------------------------------------------

                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: text(
                                      context,
                                      "الوقت",
                                      textDetails,
                                      black,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: text(
                                        context,
                                        advertisingOrders[i].adTiming!.name!,
                                        textDetails,
                                        pink,
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                      ],
                    ))
              ],
            ),
            bottomLeft: 10,
            bottomRight: 10,
            topLeft: 10,
            topRight: 10,
            marginB: 15,
            blur: 3,
            marginT: 5)
        : Center(
            child: Container(
              color: Colors.red,
              child: Expanded(
                child: text(
                  context,
                  "لاتوجد طلبات لعرضها حاليا",
                  15,
                  black,
                ),
              ),
            ),
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

//get Advertising Orders------------------------------------------------------------------------
  Future getAdvertisingOrder(String token) async {
    print('pageApi $pageCount pagNumber $page');
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
      _isFirstLoadRunning = false;
    });

    String url =
        "https://mobile.celebrityads.net/api/celebrity/AdvertisingOrders?page=$page";

    try {
      final respons = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (respons.statusCode == 200) {
        final body = respons.body;
        Advertising advertising = Advertising.fromJson(jsonDecode(body));
        var newItem = advertising.data!.advertisingOrders!;
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
      if (page == 1) {
        Navigator.pop(context);
      }
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
    getAdvertisingOrder(token);
  }
}
