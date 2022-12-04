import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';

import '../../Models/Variables/Variables.dart';

//    <string>هل تريد السماح لتطبيق منصة المشاهير بالوصول الي الصور والوسائط والملفات الأخرى الموجودة على جهازك؟</string>
class ImageData extends StatefulWidget {
  final String? image;
  const ImageData({Key? key, this.image}) : super(key: key);

  @override
  _ImageDataState createState() => _ImageDataState();
}

class _ImageDataState extends State<ImageData> {
  bool clicked = false;
  //String album = 'الطلبات';
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: black,
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 45.h, left: 350.w),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      height: 600.h,
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: widget.image!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                // color: red,
                // width: double.infinity,
                // height: MediaQuery.of(context).size.height,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //   image: NetworkImage(
                //     widget.image!,
                //   ),
                //   fit: BoxFit.contain,
                // )),
              ),
            )));
  }
}
