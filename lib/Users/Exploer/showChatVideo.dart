import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:video_player/video_player.dart';

import '../../Models/Methods/classes/GradientIcon.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
bool isBressLikeStdio = false;
class showChatVideo extends StatefulWidget {
  final VideoPlayerController? video;
  final bool? private;
  final String? thumbnail;
  showChatVideo(
      {Key? key,
        this.thumbnail,
        this.video,
        this.private,})
      : super(key: key);

  @override
  State<showChatVideo> createState() => _showChatVideoState();
}

class _showChatVideoState extends State<showChatVideo> {
  late VideoPlayerController _videoPlayerController;
  bool clicked = false;
  bool isFinish = true;
  bool isLike = false;
  bool isClicked = false;
  int likeNumber = 0;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    widget.video == null
        ? {
      _videoPlayerController =
      VideoPlayerController.asset('assets/video/don.mp4')
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.setLooping(true);
          _videoPlayerController.play();
          _videoPlayerController.setVolume(1.0);
        })
    }
        : {
      // widget.video!.initialize().then((_) {
      //   setState(() {});
      //   widget.video!.play();
      //   widget.video!.setLooping(true);
      // }),
    };
  }

  @override
  void dispose() {
   // widget.video!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: black.withOpacity(0.80),
        body: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              child:  widget.video!.value.isInitialized && widget.video != null
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(widget.video!..play())
                      // : Container(
                      // height: double.infinity,
                      // width: double.infinity,
                      // decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         image: NetworkImage(widget.thumbnail!),
                      //         fit: BoxFit.cover)),
                      // child: Center(
                      //   child: CircularProgressIndicator(
                      //     color: Colors.blue,
                      //     backgroundColor: grey,
                      //   ),
                      // ))
                      ,
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: widget.private == null ? 60.h : 10.h),
                        child: VideoProgressIndicator(
                          widget.video!,
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
              ):VideoPlayer(widget.video!..initialize()),
              onTap: () {
                setState(() {
                  ///false
                  clicked
                      ? (widget.video!..play())
                      : (widget.video!..pause());
                  clicked = clicked ? false : true;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 600.h, left: 350.w),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: white,
                onPressed: () {
                  widget.video!.pause();
                  Navigator.pop(context);
                },
              ),
            ),

            clicked
                ? Padding(
              padding: EdgeInsets.only(
                  left: 120.w,
                  bottom: widget.private == null ? 100.h : 70.h, right: 40.w),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  playViduo,
                  size: 120.r,
                  color: white,
                ),
              ),
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }




}
