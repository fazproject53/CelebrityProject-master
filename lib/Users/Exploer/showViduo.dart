import 'dart:async';
import 'dart:io';
import 'package:flutter_share/flutter_share.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Celebrity/HomeScreen/celebrity_home_page.dart';
import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';

bool isBressLike = false;

class ShowVideo extends StatefulWidget {
  final String videoURL;
  final int videoLikes;
  final String image;
  final String pageURL;
  final String thumbnail;
  final int videoId;
  final String token;
  const ShowVideo(
      {Key? key,
        required this.videoURL,
        required this.videoLikes,
        required this.image,
        required this.pageURL,
        required this.thumbnail,
        required this.videoId,
        required this.token})
      : super(key: key);

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo>
    with AutomaticKeepAliveClientMixin {
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool isPlay = true;
  bool showIcon = false;
  bool isFinish = true;
  bool isLike = false;
  bool isClicked = false;
  int likeNumber = 0;
  VideoPlayerController? _controller;
  int playTime = 0;
  int totalTime = 0;
  @override
  void initState() {
    super.initState();
    initVideo();
    likeNumber = widget.videoLikes;
    chickLike().then((value) {
      print('is user like vidue? $value');
      setState(() {
        isLike = value[0];
        likeNumber = value[1];
      });
    });
  }

  Future<void> shareLink() async {
    await FlutterShare.share(
        title: 'Share video',
        text: 'Share video',
        linkUrl:
        'https://mobile.celebrityads.net/api/vedio/show/${widget.videoId}',
        chooserTitle: 'Share video');
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(totalTime);
    // print(playTime);

    // if ( _controller?.value.isInitialized == true) {
    //   print('tttttttotal----------------$totalTime');
    //   //   increaseWatching();
    // }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: black,
          body: _controller!.value.isInitialized && _controller != null
              ? InkWell(
            onTap: () {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();

              setState(() {
                isClicked = !isClicked;
              });
            },
            child: Container(
              alignment: Alignment.topCenter,
              child: buildVideo(),
            ),
          )
              : Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.thumbnail),
                      fit: BoxFit.cover)),
              child: Container(
                margin: EdgeInsets.only(bottom: 5.h),
                alignment: Alignment.bottomCenter,
                child:  LinearProgressIndicator(
                  color: white,
                  backgroundColor: grey,
                  //value:sentByte,
                ),
              ))),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget buildVideo() {
    return Stack(
      fit: StackFit.expand,
      children: [
        buildVideoPlayer(),
        sliderWidget(),
        Visibility(
            visible: isClicked == true,
            child: Icon(playViduo, size: 80.r, color: white)),
        basicOverlayWidget(),
      ],
    );
  }

//BasicOverlayWidget
  Widget buildVideoPlayer() {
    return buildFullScreen(
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      ),
    );
  }

//----------------------------------------------------------------------
  Widget basicOverlayWidget() {
    return

      Positioned(
        bottom: 100.h,
        right: 10.w,
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          //color: red,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///profile------------------------------------------------------------
              Expanded(
                child: InkWell(
                  onTap: () {
                    _controller!.pause();
                    setState(() {
                      isClicked = true;
                    });
                    goTopagepush(
                        context,
                        CelebrityHome(
                          pageUrl: widget.pageURL,
                        ));
                  },
                  child: CircleAvatar(
                    backgroundColor: white,
                    radius: 30.r,
                    backgroundImage: NetworkImage(widget.image),
                  ),
                ),
              ),
              SizedBox(
                height: 27.h,
              ),

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
                              isBressLike = true;
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
                              isLike ? like : disLike, 35.sp, gradient()))),
                ),
              ),

              ///like number------------------------------------------------------------
              // SizedBox(
              // height: 10.h,
              // child:
              text(
                  context,
                  //'',
                  '$likeNumber',
                  17,
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
                      child:
                      Center(child: GradientIcon(share, 35.sp, gradient()))),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      );
  }

  ///slider ------------------------------------------------------------
  Widget sliderWidget() {
    return Positioned(
      bottom: 10.h,
      width: MediaQuery.of(context).size.width,
      child: VideoProgressIndicator(
        _controller!,
        allowScrubbing: false,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        colors: const VideoProgressColors(
            backgroundColor: Colors.grey,
            bufferedColor: Colors.grey,
            playedColor: Colors.white),
      ),
      // SizedBox(
      //   width: MediaQuery.of(context).size.width,
      //   child: Slider(
      //     activeColor: white,
      //     thumbColor: white,
      //     inactiveColor: Colors.grey[400],
      //     value: playTime.toDouble(),
      //     max: _controller!.value.duration.inSeconds.toDouble(),
      //     min: 0,
      //     onChanged: (time) {
      //       _controller?.seekTo(Duration(seconds: time.toInt()));
      //
      //     },
      //
      //   ),
      // ),
    );
  }

  Widget buildFullScreen({required Widget child}) {
    final size = _controller?.value.size;
    final width = size?.width;
    final height = size?.height;
    return Positioned(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding:  EdgeInsets.only(top: 50.h),
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );
  }

  void initVideo() async {
    // var f;
    _controller = VideoPlayerController.network(
      widget.videoURL,
      //videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    await _controller?.initialize().then((value) {
      setState(() {
        increaseWatching();
        _controller?.play();
        _controller?.setLooping(true);
      });
      // _controller?.addListener(f = () => setState(() {
      //       playTime = _controller!.value.position.inSeconds;
      //       totalTime = _controller!.value.duration.inSeconds;
      //       print(_controller?.value.position.inSeconds);
      //       print(_controller?.value.duration.inSeconds);
      //       if(!_controller!.value.isPlaying &&_controller!.value.isInitialized &&_controller?.value.position.inSeconds == _controller?.value.duration.inSeconds) {
      //         print('video end');
      //
      //       }
      //     }));
    });
  }

//----------------------------------------------------------------------------------------
  Future increaseWatching() async {
    String url =
        "https://mobile.celebrityads.net/api/vedio/view/${widget.videoId}";
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
  Future chickLike() async {
    String url =
        "https://mobile.celebrityads.net/api/vedio/check/${widget.videoId}";
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
    String url =
        "https://mobile.celebrityads.net/api/vedio/like/${widget.videoId}";
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
        "https://mobile.celebrityads.net/api/vedio/unlike/${widget.videoId}";
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