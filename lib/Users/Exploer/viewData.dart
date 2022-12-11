import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../Models/Methods/classes/GradientIcon.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
bool isBressLikeStdio = false;
Map<String, File> downloadedVideos = HashMap();
 VideoPlayerController? _videoPlayerController;
class viewData extends StatefulWidget {
  final String? video;
  final bool? private;
  final String? thumbnail;
  final int? id;
  String token;
  final int videoLikes;
  viewData(
      {Key? key,
      this.id,
      this.thumbnail,
      this.video,
      this.private,
      required this.token,
      required this.videoLikes})
      : super(key: key);

  @override
  State<viewData> createState() => _viewDataState();
}

class _viewDataState extends State<viewData> {

  bool clicked = false;
  bool isFinish = true;
  bool isLike = false;
  bool isClicked = false;
  int likeNumber = 0;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool loading = true;

  Future<File>? downloadFile(String url, String name) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try{
      final response = await Dio().get(
          url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0
          )
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    }catch(e){
      return file;

    }
  }

  String? name;
  File? file;
  @override
  void initState() {
    super.initState();
    likeNumber = widget.videoLikes;
    chickLike().then((value) {
      print('is user like vidue? $value');
      setState(() {
        isLike = value[0];
        likeNumber = value[1];
      });
    });
    widget.video == null
        ? {
            _videoPlayerController =
                VideoPlayerController.asset('assets/video/don.mp4')
                  ..initialize().then((_) {
                    setState(() {});
                    _videoPlayerController!.setLooping(true);
                    _videoPlayerController!.play();
                    _videoPlayerController!.setVolume(1.0);
                  })
          }
        : {
        _videoPlayerController = VideoPlayerController.network(widget.video!),
        _videoPlayerController!.initialize().then((_) {
          setState(() {});
          _videoPlayerController!.play();
          _videoPlayerController!.setLooping(true);
        }),
            print(widget.id.toString() +
                '-----------------------------------------')
          };
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _videoPlayerController = null;
    vp = null;
    cx =null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for(int i = 0; i <1 ; i++){
      vp != null?cx = context: null;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: black.withOpacity(0.80),
        body: _videoPlayerController!.value.isInitialized && _videoPlayerController != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_videoPlayerController!),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: widget.private == null ? 60.h : 10.h),
                              child: VideoProgressIndicator(
                                _videoPlayerController!,
                                allowScrubbing: false,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 5.h),
                                colors: const VideoProgressColors(
                                    backgroundColor: Colors.grey,
                                    bufferedColor: Colors.grey,
                                    playedColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        ///false
                        clicked
                            ? (_videoPlayerController!..play())
                            : (_videoPlayerController!..pause());
                        clicked = clicked ? false : true;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 600.h, left: 340.w),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: white,
                      onPressed: () {
                        Navigator.pop(context);
                        dispose();
                      },
                    ),
                  ),
                  widget.private != null
                      ? const SizedBox()
                      : Positioned(
                        bottom: 100.h,
                        right: 10.w,

                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                          //color: red,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
///like bottom------------------------------------------------------------
                              Expanded(
                                child: CircleAvatar(
                                  backgroundColor: white,
                                  radius: 30.r,
                                  child: Center(
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isLike = !isLike;
                                              isBressLikeStdio = true;
                                              if (isLike) {
                                                likeNumber = likeNumber + 1;
                                                addLikeApi();
                                              } else {
                                                likeNumber = likeNumber - 1;
                                                addUnLikeApi();
                                              }
                                            });
                                          },
                                          child: GradientIcon(
                                              isLike ? like : disLike,
                                              35.sp,
                                              gradient()))),
                                ),
                              ),

///like number------------------------------------------------------------

                              text(
                                  context,
                                  //'',
                                  '$likeNumber',
                                  15,
                                  white,
                                  fontWeight: FontWeight.bold),
                              // ),
                              SizedBox(
                                height: 5.h,
                              ),

///share bottom------------------------------------------------------------
                              Expanded(
                                child: CircleAvatar(
                                  backgroundColor: white,
                                  radius: 30.r,
                                  child: InkWell(
                                      onTap: () {
                                        shareLink();
                                      },
                                      child: Center(
                                          child: GradientIcon(
                                              share, 35.sp, gradient()))),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],

                          ),
                        ),
                      ),
                  clicked
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: 100.w,
                              bottom: widget.private == null ? 100.h : 70.h, right: 40.w),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              playViduo,
                              size: 80.r,
                              color: white,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              )
            : widget.thumbnail ==null? SizedBox( child:Container(
          alignment: Alignment.bottomCenter,
          child: CircularProgressIndicator(
              color: Colors.blue,
              backgroundColor: grey,
            ),
        )):Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider( widget.thumbnail!),
                        fit: BoxFit.cover)),
                child: Container(
                  margin: EdgeInsets.only(bottom: widget.private == null ?65.h:5.h),
                  alignment: Alignment.bottomCenter,
                  child:  LinearProgressIndicator(
                    color: white,
                    backgroundColor: grey,
                    //value:sentByte,
                  ),
                  // CircularProgressIndicator(
                  //   color: Colors.blue,
                  //   backgroundColor: grey,
                  // ),
                )),
      ),
    );
  }

  Future<void> shareLink() async {
    await FlutterShare.share(
        title: 'Share video',
        text: 'Share video',
        linkUrl: 'https://mobile.celebrityads.net/api/vedio/show/${widget.id}',
        chooserTitle: 'Share video');
  }

//--------------------------------------------------------------------------------------
  Future chickLike() async {
    String url = "https://mobile.celebrityads.net/api/vedio/check/${widget.id}";
    try {
      final respons = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (respons.statusCode == 200) {
        print(respons.body);
        var status = jsonDecode(respons.body)["data"]["status"];
        var like = jsonDecode(respons.body)["data"]["likes"];
        print('------------------------------------');
        print(status);
        print(like);
        print('------------------------------------');

        if (status == true) {

          return [true, like];
        } else {
          return false;
        }
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

//--------------------------------------------------------------------------------------
  Future addLikeApi() async {
    String url = "https://mobile.celebrityads.net/api/vedio/like/${widget.id}";
    try {
      final respons = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (respons.statusCode == 200) {
        print(respons.body);
        var status = jsonDecode(respons.body)["success"];
        print('------------------------------------');
        print(status);
        print('------------------------------------');

        if (status == true) {
          return true;
        } else {
          return false;
        }
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

//--------------------------------------------------------------------------------------
  Future addUnLikeApi() async {
    String url =
        "https://mobile.celebrityads.net/api/vedio/unlike/${widget.id}";
    try {
      final respons = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (respons.statusCode == 200) {
        print(respons.body);
        var status = jsonDecode(respons.body)["success"];
        print('------------------------------------');
        print(status);
        print('------------------------------------');

        if (status == true) {
          return true;
        } else {
          return false;
        }
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
}
