import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';

class DownloadingDialog extends StatefulWidget {
  final String url;
  final String fileName;

  const DownloadingDialog({Key? key, required this.url, required this.fileName})
      : super(key: key);

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;
  String album = 'منصات المشاهير';
  void startDownloading() async {
    var path = await _getFilePath(widget.fileName);
    if (path == false) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(snack(context, 'لم يتم التحميل حاول لاحقا'));
    } else {
      await dio.download(
        widget.url,
        path,
        onReceiveProgress: (recivedBytes, totalBytes) {
          setState(() {
            progress = recivedBytes / totalBytes;
          });
          // print(progress);
        },
        deleteOnError: true,
      ).then((_) async {
        if (progress >= 1.0) {
          await ImageGallerySaver.saveFile(path, isReturnPathOfIOS: true);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snack(context, 'تم حفظ الملف بنجاح'));
        }
      });
    }
  }

//====================================================================
  Future _getFilePath(String filename) async {
    Directory? directory;
    String newPath = "";
    bool? photos, storage;
    try {
      if (Platform.isAndroid) {
        storage = await _requestPermission(Permission.storage);
        print('isAndroid');
        if (storage) {
          directory = await getExternalStorageDirectory();
          //add directory in Android folder
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Download" || folder != "download") {
              newPath = newPath + "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + '/' + album;
          directory = Directory(newPath);
        } else {
          return false;
        }
      }
//IOS=======================================================
      else {
        print('IOS');
        photos = await _requestPermission(Permission.storage);
        print('IOS Permeation: $photos');
        if (photos) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          return false;
        }
      }
      print('11111111111111111111111111111111111111111111111111111111111');
      print('IOS Permeation: $photos');
      print('Android Permeation: $storage');
      print('newPath: $newPath');
      print('directory: ${directory.path}');
      print('is directory exist?  ${await directory.exists()}');
      print('11111111111111111111111111111111111111111111111111111111111');
//IOS======================================================================

      if (!await directory.exists()) {
        print('++++++++++++++++++++++++++++++++++++++++++++++++');
        print('directory not exists');
        print('++++++++++++++++++++++++++++++++++++++++++++++++');
        await directory.create();
      }
      if (await directory.exists()) {
        print('++++++++++++++++++++++++++++++++++++++++++++++++');
        print('directory exists');
        print('++++++++++++++++++++++++++++++++++++++++++++++++');
        File saveFile = File(directory.path + "/$filename");
        print('saveFile:${saveFile.path}');
        return saveFile.path;
      }
      return false;
    } catch (e) {
      return e.toString();
    }
  }

  //
  //   if (await _requestPermission(Permission.storage)) {
  //     directory = await getExternalStorageDirectory();
  //     String newPath = "";
  //     print(directory);
  //     List<String> paths = directory!.path.split("/");
  //     for (int x = 1; x < paths.length; x++) {
  //       String folder = paths[x];
  //       if (folder != "Android") {
  //         newPath += "/" + folder;
  //       } else {
  //         break;
  //       }
  //     }
  //     newPath = newPath + "/$album";
  //     directory = Directory(newPath);
  //   } else {
  //     return '';
  //   }
  //   File saveFile = File(directory.path + "/${widget.fileName}");
  //   if (!await directory.exists()) {
  //     await directory.create(recursive: true);
  //   }
  //   return saveFile.path;
  // }

  //requestPermission===============================================================
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

//=================================================================
  @override
  void initState() {
    super.initState();
    startDownloading();
  }

//===================================================================
  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: LiquidCircularProgressIndicator(
              value:
                  double.parse(downloadingProgress) / 100, // Defaults to 0.5.
              valueColor: const AlwaysStoppedAnimation(
                  Colors.pink), // Defaults to the current Theme's accentColor.
              backgroundColor: Colors
                  .white, // Defaults to the current Theme's backgroundColor.
              // borderColor: Colors.white,
              // borderWidth: 0.50,
              direction: Axis
                  .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
              center: Text("$downloadingProgress %"),
            ),
          ),
          //  const CircularProgressIndicator.adaptive(
          //   backgroundColor: Colors.grey,
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // Text(
          //   "%" "$downloadingProgress" + " جاري التنزيل ",
          //   style: const TextStyle(
          //     color: Colors.black,
          //     fontSize: 17,
          //   ),
          // ),
        ],
      ),
    );
  }
}
