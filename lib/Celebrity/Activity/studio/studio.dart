import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Celebrity/Activity/ExpandableFab%20.dart';
import 'package:celepraty/Celebrity/Activity/studio/addVideo.dart';
import 'package:celepraty/Celebrity/Activity/studio/addphoto.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import '../../../Account/LoggingSingUpAPI.dart';
import '../../../Models/Methods/classes/GradientIcon.dart';
import '../../../Users/Exploer/viewData.dart';
import '../../../Users/Exploer/viewDataImage.dart';

List postsstudio = [];
int pagestudio = 1;
Map<int,String> thumbImage = HashMap();
bool update = false;
class Studio extends StatefulWidget {
  _StudioState createState() => _StudioState();
}

class _StudioState extends State<Studio> with AutomaticKeepAliveClientMixin{

  final _baseUrl ='https://mobile.celebrityads.net/api/celebrity/studio';


  bool ActiveConnection = false;
  String T = "";
  // There is next page or not
  bool _hasNextPage = true;
  File? studioimage;
  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
   ScrollController _controller = ScrollController();

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  late VideoPlayerController _videoPlayerController;
  bool addp = false;
  bool addv = false;
  bool isReady = false;
  String? userToken;





  void _loadMore() async {

    print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false && _controller.position.maxScrollExtent ==
        _controller.offset ) {

        setState(() {
          _isLoadMoreRunning = true;
          pagestudio += 1;
          // Display a progress indicator at the bottom
        });

        try {
          final res =
          await http.get(Uri.parse("$_baseUrl?page=$pagestudio"), headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken'
          });

          if (TheStudio
              .fromJson(jsonDecode(res.body))
              .data!
              .studio!
              .isNotEmpty) {
            setState(() {
              List _posts2 = [];

              int ll= postsstudio.length ;
              print(postsstudio.length.toString() + '=========================================================================');
              _posts2 =TheStudio
                  .fromJson(jsonDecode(res.body))
                  .data!
                  .studio!;
              postsstudio.addAll(_posts2);

              for(int i = 0; i <= postsstudio.length; i++) {
                if (postsstudio[i].studio!.type == 'vedio') {
                  thumbImage.putIfAbsent(i, () => postsstudio[i].thumbnail!);
                  ll= ll+1;
                }
              }

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
    super.initState();
    CheckUserConnection();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        postsstudio.isEmpty? fetchStudio():null;
      });

    });
    _controller.addListener(_loadMore);
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    postsstudio.isEmpty? fetchStudio():null;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: addv || addp
            ? null
            : ExpandableFab(
          distance: 80.0,
          children: [
            ActionButton(
              onPressed: () =>
              {
                setState(() {
                  addv = true;
                })
              },
              icon: Icon(
                videoIcon,
                color: white,
              ),
              color: pink,
            ),
            ActionButton(
              onPressed: () =>
              {
                setState(() {
                 addp = true;

                })
              },
              icon: Icon(
                imageIcon,
                color: white,
              ),
              color: pink,
            ),
          ],
        ),
        body:!isConnectSection?Center(
            child: Padding(
              padding:  EdgeInsets.only(top: 0.h),
              child: SizedBox(
                  height: 300.h,
                  width: 250.w,
                  child: internetConnection(
                      context, reload: () {
                    setState(() {
                      fetchStudio();
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
            fetchStudio();
          });}),
        ): addp
            ? addphoto()
            : addv
            ? addVideo()
            : SingleChildScrollView(
          controller: _controller,
          child: _isFirstLoadRunning
              ?  Container(
            height: getSize(context).height/1.5,
                child: Center(
            child: mainLoad(context),
          ),
              )
              : postsstudio.isEmpty ? Padding(
            padding: EdgeInsets.only(top: getSize(context).height / 7),
            child: Center(child: Column(
              children: [
                Image.asset(
                  'assets/image/studio.png', height: 150.h, width: 150.w,),
                text(context, 'لا توجد وسائط حاليا', 23, black),
              ],
            )),
          ) : Column(
            children: [
              paddingg(
                10,
                10,
                0,
                 ListView.builder(
                    itemCount: postsstudio.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (_, index) {
                      return paddingg(
                        5,
                        5,
                        5,
                        SizedBox(
                          height: 145.h,
                          width: 270.w,
                          child: Card(
                            elevation: 5,
                            color: white,
                            child: paddingg(
                              0,
                              0,
                              0,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      paddingg(
                                        5,
                                        2,
                                        0,
                                        Container(
                                          width: 125.w ,
                                          color: lightGrey.withOpacity(0.30),
                                          margin: EdgeInsets.only(
                                              bottom: 2.h, top: 2.h),
                                          alignment: Alignment
                                              .centerRight,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                2.0),
                                            child: postsstudio[index].type == 'image' ? InkWell(
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                            ImageData(
                                                              image:
                                                              postsstudio[index].image!,
                                                            )));
                                              },
                                                    child: CachedNetworkImage(
                                                    imageUrl: postsstudio[index].image!,
                                                      placeholder: (context, url) => Container(),
                                              fit: BoxFit
                                                    .fill,
                                              height: double.infinity.h,
                                              width: 125.w,
                                            ),
                                                  ) : Container(
                                                height: double.infinity.h,
                                                width: double.infinity.w,
                                                child: InkWell(
                                                  onTap: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                               viewData(
                                                                  video:postsstudio[index].image!,
                                                                 private: true,
                                                                 token: userToken!,
                                                                 videoLikes: 0,
                                                                 thumbnail: postsstudio[index].thumbnail!,
                                                                )));},
                                                        child: Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                          CachedNetworkImage(  imageUrl: postsstudio[index].thumbnail!, height: double.infinity, width:  double.infinity,fit: BoxFit.cover,),
                                                            Center(
                                                              child: GradientIcon(
                                                                  playVideo,
                                                                  55.sp,
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
                                                          ],
                                                        ),
                                                      )),

                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.w,),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          SingleChildScrollView(
                                            child: Container(
                                              width: 180.w,
                                              height: 105.h,
                                              child: text(
                                                  context,
                                                  postsstudio[index].description == null?' ': postsstudio[index].description,
                                                  textTitleSize,
                                                  black),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.only(
                                        bottom: 20.h,
                                        left: 15.w),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 30.h,
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
                                          onTap: () {
                                            failureDialog(
                                              context,
                                              'حذف المشور',
                                              'هل انت متأكد من حذف المنشور ؟',
                                              "assets/lottie/Failuer.json",
                                              'حذف',
                                                  () {
                                                ///delete the discount code
                                                ///Alert dialog to conform
                                                deleteStudio(postsstudio[index].id!);
                                                Navigator.pop(
                                                    context,
                                                    'حذف');

                                              },
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
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
              SizedBox(height: 30.h,),
              if (_isLoadMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // When nothing else to load

            ],
          ),


        )


      ),

    );

  }

void fetchStudio() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    // try {
      final response = await http.get(
          Uri.parse('$_baseUrl?page=$pagestudio'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        setState(() {
          postsstudio = TheStudio
              .fromJson(jsonDecode(response.body))
              .data!
              .studio!;

          for(int i = 0; i< postsstudio.length; i++) {
            if (TheStudio
                .fromJson(jsonDecode(response.body))
                .data!
                .studio![i].type == 'vedio') {
              thumbImage.putIfAbsent(i, () => TheStudio
                  .fromJson(jsonDecode(response.body))
                  .data!
                  .studio![i].thumbnail!);
            }
          }
        });
        setState(() {
          isReady = true;
        });
        
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
  //   }catch(e){
  // if (e is SocketException) {
  // setState(() {
  // isConnectSection = false;
  // });
  // return Future.error('SocketException');
  // } else if (e is TimeoutException) {
  // setState(() {
  // timeoutException = false;
  // });
  // return Future.error('TimeoutException');
  // } else {
  // setState(() {
  // serverExceptions = false;
  // });
  // return Future.error('serverExceptions');
  // }
  // }
    setState(() {
      _isFirstLoadRunning = false;
      print(_isFirstLoadRunning.toString()+'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    });

  }

  Future<String>  addPhoto(String token) async {

    try {
      var stream = new http.ByteStream(
          DelegatingStream.typed(studioimage!.openRead()));
      // get file length
      var length = await studioimage!.length();

      // string to uri
      var uri =
      Uri.parse("https://mobile.celebrityads.net/api/celebrity/studio/add");

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      };
      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(studioimage!.path));

      // add file to multipart
      request.files.add(multipartFile);
      request.headers.addAll(headers);
      request.fields["title"] = '';
      request.fields["type"] = "image";
      // send
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      return '';
    }catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if(e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';

      }
    }
  }



  Future<http.Response> deleteStudio(int id) async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';

    final http.Response response = await http.delete(
      Uri.parse('https://mobile.celebrityads.net/api/celebrity/studio/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken'
      },
    );

    setState(() {
      postsstudio.clear();
      pagestudio = 1;
      // There is next page or not
      _hasNextPage = true;

      // Used to display loading indicators when _firstLoad function is running
       _isFirstLoadRunning = false;

      // Used to display loading indicators when _loadMore function is running
       _isLoadMoreRunning = false;
      fetchStudio();
    });
    return response;
  }

}


class TheStudio {
  bool? success;
  Data? data;
  Message? message;

  TheStudio({this.success, this.data, this.message});

  TheStudio.fromJson(Map<String, dynamic> json) {
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
  List<Studioo>? studio;
  int? pageCount;
  int? status;

  Data({this.studio, this.pageCount, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['studio'] != null) {
      studio = <Studioo>[];
      json['studio'].forEach((v) {
        studio!.add(new Studioo.fromJson(v));
      });
    }
    pageCount = json['page_count'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studio != null) {
      data['studio'] = this.studio!.map((v) => v.toJson()).toList();
    }
    data['page_count'] = this.pageCount;
    data['status'] = this.status;
    return data;
  }
}

class Studioo {
  int? id;
  String? title;
  String? description;
  String? image;
  String? thumbnail;
  String? type;
  int? likes;
  int? views;

  Studioo(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.thumbnail,
        this.type,
        this.likes,
        this.views});

  Studioo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    type = json['type'];
    likes = json['likes'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['thumbnail'] = this.thumbnail;
    data['type'] = this.type;
    data['likes'] = this.likes;
    data['views'] = this.views;
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