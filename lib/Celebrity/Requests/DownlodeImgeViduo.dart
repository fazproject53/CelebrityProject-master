import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

        ScaffoldMessenger.of(context).showSnackBar(snackBar(context,
            'تم الحفظ في البوم ' + 'منصات المشاهير', green, done));
      }
    });
  }
//====================================================================
  Future<String> _getFilePath(String filename) async {
    Directory? directory;
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
      return '';
    }
    File saveFile = File(directory.path + "/${widget.fileName}");
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return saveFile.path;
  }
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
      //backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           const CircularProgressIndicator.adaptive(
            backgroundColor: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "%" "$downloadingProgress" + " جاري التنزيل ",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
