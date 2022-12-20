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
    String path = await _getFilePath(widget.fileName);
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
    ).then((_) {
      print(progress);
      if (progress >= 1.0) {
        Navigator.pop(context);
        //lode(context, "", "تم التنزيل بنجاح");

        ScaffoldMessenger.of(context).showSnackBar(snackBar(
            context, 'تم الحفظ في البوم ' + 'منصات المشاهير', green, done));
      }
    });
  }

//====================================================================
  Future _getFilePath(String filename) async {
    Directory? directory;

    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/$album";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$filename");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return saveFile.path;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
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
//===============================================================
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
