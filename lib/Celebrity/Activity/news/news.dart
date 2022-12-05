import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Celebrity/Activity/news/addNews.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../Account/LoggingSingUpAPI.dart';
import '../../../Account/logging.dart';
List posts = [];
String? cImage;
int page = 1;
class news extends StatefulWidget {
  _newsState createState() => _newsState();
}

class _newsState extends State<news> with AutomaticKeepAliveClientMixin{

  final _baseUrl ='https://mobile.celebrityads.net/api/celebrity/news';

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

  ScrollController _controller = ScrollController();

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  bool add = false;
  bool edit = false;

String? userToken;
 Map<int, String> tempTitle = HashMap<int, String>();
 Map<int, String> tempDesc = HashMap<int, String>();
  int? theindex;
  bool? temp;

  TextEditingController newstitle = new TextEditingController();
  TextEditingController newsdesc = new TextEditingController();

  void _loadMore() async {

    print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false && _controller.position.maxScrollExtent ==
        _controller.offset ) {

      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      setState(() {
        page += 1;
      });
      try {
        final res =
        await http.get(Uri.parse("$_baseUrl?page=$page"), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });

        if (GeneralNews
            .fromJson(jsonDecode(res.body))
            .data!.news!
            .isNotEmpty) {
          setState(() {
            posts= posts +GeneralNews
                .fromJson(jsonDecode(res.body))
                .data!
                .news!;
            print(jsonDecode(res.body));
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

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  void initState() {
    CheckUserConnection();
   DatabaseHelper.getToken().then((value) {
     setState(() {
       userToken = value;
       posts.isEmpty?fetchNews(userToken!):null;
     });
   });
   _controller.addListener(_loadMore);
   super.initState();
}

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: !add ?FloatingActionButton(onPressed: (){  setState(() {
          add = true;
        });}, backgroundColor: pink, child: Icon(Icons.add),):null,
        body: !isConnectSection?Center(
            child: Padding(
              padding:  EdgeInsets.only(top: 0.h),
              child: SizedBox(
                  height: 300.h,
                  width: 250.w,
                  child: internetConnection(
                      context, reload: () {
                    setState(() {
                      fetchNews(userToken!);
                      isConnectSection = true;
                    });
                  })),
            )): !serverExceptions? Container(
          height: getSize(context).height/2,
          child: Center(
              child: checkServerException(context)
          ),
        ): !timeoutException? Center(
          child: checkTimeOutException(context, reload: (){ setState(() {
            fetchNews(userToken!);
          });}),
        ):add
            ? addNews()
            : SafeArea(
                child:_isFirstLoadRunning
                    ?  Center(
                  child: mainLoad(context),
                ): SingleChildScrollView(
                  controller: _controller,
                child: Column(
                  children: [

                    posts.isEmpty? Padding(
                              padding: EdgeInsets.only(top:getSize(context).height/7),
                              child: Center(child: Column(
                                children: [
                                 Image.asset('assets/image/news.png', height: 150.h, width: 180.w,),
                                  text(context, 'لا توجد اخبار حاليا', 23, black),
                                ],
                              )),
                            ): paddingg(
                              10,
                              10,
                              0,
                              ListView.builder(
                                itemCount: posts.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {

                                  return paddingg(
                                    8,
                                    8,
                                    5,
                                    SingleChildScrollView(
                                      child: SizedBox(
                                        height: edit && theindex == index
                                            ? 180.h
                                            : 150,
                                        width: 300.w,
                                        child: Card(
                                          elevation: 5,
                                          color: white,
                                          child: paddingg(
                                            0,
                                            0,
                                            5,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    paddingg(
                                                      5,
                                                      5,
                                                      0,
                                                      Container(
                                                        alignment:
                                                            Alignment.centerRight,
                                                        child: CircleAvatar(
                                                          radius: 50.r,
                                                          backgroundColor: lightGrey.withOpacity(0.30),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100.r),
                                                            child: cImage != null? Image.network(
                                                              cImage!,
                                                              fit: BoxFit.cover,
                                                              height: edit
                                                                  ? 150.h
                                                                  : 130.h,
                                                              width: 100.w,
                                                              errorBuilder: (BuildContext, Object, StackTrace){

                                                                return Center(
                                                                    child: Icon(failure, color: red, size: 20.r,)
                                                                );
                                                              },
                                                              loadingBuilder:
                                                                  (context, child, loadingProgress) {
                                                                if (loadingProgress == null) return child;
                                                                return Center(
                                                                );
                                                              },
                                                            ):Image.network(
                                                              Logging.theUser!.image!,
                                                              fit: BoxFit.cover,
                                                              height: edit
                                                                  ? 150.h
                                                                  : 130.h,
                                                              width: 100.w,
                                                              loadingBuilder:
                                                                  (context, child, loadingProgress) {
                                                                if (loadingProgress == null) return child;
                                                                return Center(
                                                                    child: Lottie.asset('assets/lottie/grey.json', height: 80.h, width: 60.w )
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        margin: EdgeInsets.only(
                                                            bottom: 5.h),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5.w,),
                                            SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),

                                                          SizedBox(
                                                            height: edit &&
                                                                    theindex ==
                                                                        index
                                                                ? 8.h
                                                                : 0.h,
                                                          ),
                                                          SizedBox(height: 20.h,),
                                                           Container(
                                                              width: 190.w,
                                                              height: 80.h,
                                                              child:
                                                                  edit &&
                                                                          theindex ==
                                                                              index
                                                                      ?  TextFormField(
                                                                            cursorColor:
                                                                                black,
                                                                            controller:
                                                                                newsdesc,
                                                                    maxLines: null,
                                                                    minLines: 10,
                                                                    maxLength: 63,
                                                                    buildCounter: (context,
                                                                          {required currentLength, required isFocused, maxLength}) {
                                                                        return Container(child: Text(
                                                                            '${maxLength!}' + '/' + '${currentLength}'));
                                                                    },
                                                                    validator: (String? value) {
                                                                        if (
                                                                        value == null || value.isEmpty) {
                                                                          return 'حقل اجباري';
                                                                        } else {
                                                                          if (value.length > 63) {
                                                                            return 'الحد الاقصى للخبر 63 حرف';
                                                                          }
                                                                        };
                                                                    },
                                                                            style: TextStyle(
                                                                                color:
                                                                                    black,
                                                                                fontSize:
                                                                                textTitleSize.sp,
                                                                                fontFamily:
                                                                                    'Cairo'),
                                                                            decoration: InputDecoration(
                                                                                fillColor:
                                                                                    lightGrey,
                                                                                focusedBorder: UnderlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        color:
                                                                                            pink)),
                                                                                contentPadding:
                                                                                    EdgeInsets.all(0.h)),
                                                                          )
                                                                      : text(
                                                                          context,
                                                                      tempDesc.containsKey(posts[index].id!)?
                                                                      tempDesc[posts[index].id!]! :posts[index].description!,
                                                                      textTitleSize,
                                                                          black),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                edit && theindex == index
                                                    ? Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 110.0.h,
                                                            left: 15.w,
                                                            right: 15.w),
                                                        child: InkWell(
                                                          child: Container(
                                                            child: Icon(
                                                              save,
                                                              color: white,
                                                              size: 18,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                50),
                                                                    gradient:
                                                                        const LinearGradient(
                                                                      begin:
                                                                          Alignment(
                                                                              0.7,
                                                                              2.0),
                                                                      end: Alignment(
                                                                          -0.69,
                                                                          -1.0),
                                                                      colors: [
                                                                        Color(
                                                                            0xff0ab3d0),
                                                                        Color(
                                                                            0xffe468ca)
                                                                      ],
                                                                      stops: [
                                                                        0.0,
                                                                        1.0
                                                                      ],
                                                                    )),
                                                            height: 28.h,
                                                            width: 32.w,
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              tempTitle.putIfAbsent(posts[index].id!, () => newstitle.text);
                                                              tempDesc.putIfAbsent(posts[index].id!, () => newsdesc.text);
                                                              updateNews(posts[index].id!, userToken!);
                                                              edit = false;

                                                            });
                                                          },
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 30.0.h,
                                                            left: 10.w,
                                                            right: 15.w),
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              child: Container(
                                                                child: Icon(
                                                                  editDiscount,
                                                                  color: white,
                                                                  size: 18,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                50),
                                                                        gradient:
                                                                            const LinearGradient(
                                                                          begin: Alignment(
                                                                              0.7,
                                                                              2.0),
                                                                          end: Alignment(
                                                                              -0.69,
                                                                              -1.0),
                                                                          colors: [
                                                                            Color(
                                                                                0xff0ab3d0),
                                                                            Color(
                                                                                0xffe468ca)
                                                                          ],
                                                                          stops: [
                                                                            0.0,
                                                                            1.0
                                                                          ],
                                                                        )),
                                                                height: 28.h,
                                                                width: 32.w,
                                                              ),
                                                              onTap: () {
                                                                setState(() {

                                                                  newsdesc.text = tempDesc.containsKey(posts[index].id!)?
                                                                  tempDesc[posts[index].id!]! : posts[index].description!;
                                                                  edit = true;
                                                                  theindex =
                                                                      index;

                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 15.h,
                                                            ),
                                                            InkWell(
                                                              child: Container(
                                                                child: Icon(
                                                                  removeDiscount,
                                                                  color: white,
                                                                  size: 18,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                50),
                                                                        gradient:
                                                                            const LinearGradient(
                                                                          begin: Alignment(
                                                                              0.7,
                                                                              2.0),
                                                                          end: Alignment(
                                                                              -0.69,
                                                                              -1.0),
                                                                          colors: [
                                                                            Color(
                                                                                0xff0ab3d0),
                                                                            Color(
                                                                                0xffe468ca)
                                                                          ],
                                                                          stops: [
                                                                            0.0,
                                                                            1.0
                                                                          ],
                                                                        )),
                                                                height: 28.h,
                                                                width: 32.w,
                                                              ),
                                                              onTap: (){
                                                                setState(() {
                                                                  failureDialog(
                                                                    context,
                                                                    'حذف خبر',
                                                                    'هل انت متأكد من حذف الخبر ؟',
                                                                    "assets/lottie/Failuer.json",
                                                                    'حذف',
                                                                        () {
                                                                      ///delete the discount code
                                                                      ///Alert dialog to conform
                                                                          deleteNew(posts[index].id!, userToken!);
                                                                          Navigator.pop(
                                                                              context,
                                                                              'حذف');

                                                                        },
                                                                  );


                                                              });}
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                    _isLoadMoreRunning == true?
                    SizedBox():
                    SizedBox(height: 35.h,),
                    if (_isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
    ),
      )
      )
    );
  }

  Future<http.Response> deleteNew(int id, String token) async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';

    final http.Response response = await http.delete(
      Uri.parse('https://mobile.celebrityads.net/api/celebrity/news/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    setState(() {
      posts.clear();
      page = 1;
      // There is next page or not
      _hasNextPage = true;

      // Used to display loading indicators when _firstLoad function is running
      _isFirstLoadRunning = false;

      // Used to display loading indicators when _loadMore function is running
      _isLoadMoreRunning = false;
       fetchNews(userToken!);
    });
    return response;
  }

  void fetchNews(String tokenn) async {

    var token ='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDI4MTY3ZWY1YWE0ZDBjZWQ0MDBjOTViMzBmNWQwZGFiNmY4MzgxMWU3YTUwMWUyMmYwMmMyZGU2YjRjOTIwOGI0MjFjNmZjZGM3YWMzZjUiLCJpYXQiOjE2NTM5ODg2MjAuNjgyMDE4OTk1Mjg1MDM0MTc5Njg3NSwibmJmIjoxNjUzOTg4NjIwLjY4MjAyNDk1NTc0OTUxMTcxODc1LCJleHAiOjE2ODU1MjQ2MjAuNjczNjY3OTA3NzE0ODQzNzUsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.OguFfzEWNOyCU4xSZ_PbLwg1xmyEbIMYAQ-J9wRApGKMq0qo1aEiM1OvcfvEaopxRiKngk-ckebhhcl7MRtGopNZcNjJwp9jWS7yZuyH7DBvct0O6tys47HL4eBU0QLwgmxMmh8nLkADARdIvVdZJFw9vLp-7X-4Huj6I2E1SFjeYnV6l7Fu_c1BYMAJmXpBwIALxTvwxg8tbxuhKmFBtLnnY3K25Tedra9IMc0nR_nXV3ifXdp4v7fsvbCLLYNr5ihc3ElE_QWczOvkkYeOPTP4yFMFlZFpWUNeER5wiEdbcO6WzzxzCRkLXriedWDI3G6qOrMAUAjiAUxS51--_7x9iI0qHalXHyGxgudUnAHGNsYpvLJ8JVCM2k_dtGazmZtA5w5wDSTI8gSuWUZxf2OpQNCmyt8k80Pbi_Olz2xDMSuDKYmiomWrUhwIwunk_gsU9lC5oLcEzJ2BLcaiiuwFex9xraMbbC1ZyipSIZZhW1l1CppYeYmPSxLC8hEIywRy5Lbvw-WQ25CpurNgEMiHefGooDxCsHqnkfWCQ1MnFAGiEs2hPtG7DVp8RArzCyXXaVrtVi2wbBFrCPDK52yNQxQjs3z8JBNlDwEFR2uDa-VRup61j2WESvyUKPMloD7gL7FsthAl6IZquYh7XujHWEcf1Lnprd6D5J6CPWM';
      setState(() {
        _isFirstLoadRunning = true;
      });
      try {
        final response = await http.get(
            Uri.parse('$_baseUrl?page=$page'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $userToken'
            });
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          setState(() {
            posts = GeneralNews
                .fromJson(jsonDecode(response.body))
                .data!
                .news!;

            cImage = GeneralNews
                .fromJson(jsonDecode(response.body))
                .data!.celImage != null?GeneralNews
                .fromJson(jsonDecode(response.body))
                .data!.celImage!: null;
          });
          print(response.body);
          setState(() {
            isReady = true;
          });
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load activity');
        }

      }catch(e){
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

  Future<http.Response> updateNews(int id, String token) async {
   final response = await http.post(
      Uri.parse(
        'https://mobile.celebrityads.net/api/celebrity/news/update/${id}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "title" : newstitle.text,
        "description" : newsdesc.text
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      print(response.body);
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }
}




class GeneralNews {
  bool? success;
  Data? data;
  Message? message;

  GeneralNews({this.success, this.data, this.message});

  GeneralNews.fromJson(Map<String, dynamic> json) {
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
  List<News>? news;
  int? status;

  String? celImage;
  Data({this.news, this.status, this.celImage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['news'] != null) {
      news = <News>[];
      json['news'].forEach((v) {
        news!.add(new News.fromJson(v));
      });
    }
    status = json['status'];
   celImage = json['celebrity_image'];
  }

//
Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['celebrity_image'] = this.celImage;
    return data;
  }
}

class News {
  int? id;
  String? title;
  String? description;

  News({this.id, this.title, this.description});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
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
