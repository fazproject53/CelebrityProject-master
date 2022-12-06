import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:celepraty/Celebrity/Activity/studio/studio.dart';
import 'package:celepraty/Celebrity/orders/gifttingForm.dart';
import 'package:celepraty/Users/Exploer/showViduo.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import '../../../Account/LoggingSingUpAPI.dart';
import '../activity_screen.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
typedef void OnUploadProgressCallback(double sentBytes, double totalBytes);
class addVideo extends StatefulWidget {
  _addVideoState createState() => _addVideoState();
}

class _addVideoState extends State<addVideo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controlvideotitle = new TextEditingController();
  TextEditingController controlvideodesc = new TextEditingController();

  bool isUploading = false;
  double sentByte = 0.0;
  double totalByte=0;
  File? studioVideo;
  String? userToken;
bool isEmptyFile= false;
  List temp = [];
  MediaInfo? mediaInfo;
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
   isUploading= false;
    super.dispose();
  }
  void update(){
    isUploading?Timer.periodic(Duration(milliseconds: 700), (timer) {
      setState(() {
        sentByte = sentByte + 0.01;
      });
    }):null;
  }
  @override
  Widget build(BuildContext context) {
    // isUploading?{
    //   sentByte = 0.3,
    //   sentByte = 0.6,
    //   sentByte = 0.10,
    // }:null;
    //   isUploading? {
    //     for(int i =0; i < 6; i++)
    //       update()
    //   }:null;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    child: Form(
          key: _formKey,
          child: paddingg(
            12,
            12,
            5,
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              paddingg(
                10,
                12,
                20.h,
                Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      ' اضافة فيديو جديد',
                      style: TextStyle(
                          fontSize: textSubHeadSize.sp,
                          color: textBlack,
                          fontFamily: 'Cairo'),
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              // paddingg(
              //   15,
              //   15,
              //   12,
              //   textFieldNoIcon(
              //       context, 'عنوان الفيديو', 14, false, controlvideotitle,
              //       (String? value) {
              //     if (value == null || value.isEmpty) {
              //       return 'حقل اجباري';
              //     }
              //   }, false),
              // ),
              paddingg(
                15,
                15,
                12,
                textFieldDesc(
                    context, 'وصف الفيديو', textTitleSize, false, controlvideodesc,
                        (String? value) {if (
                    value == null || value.isEmpty) {
                      return null;}
                        if(value.length > 80){

                          return 'الحد لاقصى للوصف 80 حرف';
                        };
                    }),
              ),
              SizedBox(height: 20.h),

              paddingg(
                15,
                15,
                12,
                uploadImg(200, 54, text(context, 'قم برفع فيديو ', textFieldSize, black),
                    () {
                  getVideo(context);
                  setState(() {
                    isEmptyFile = false;
                  });
                }),
              ),
              paddingg(
                  15,
                  25,
                  5, text(context, '* ملاحظة : يجب ان يكون امتداد الفيديو mp4.', textError, darkWhite)),
              !isEmptyFile? SizedBox():paddingg(
                  15,
                  25,
                  5, text(context, ' قم برفع فيديو', textError, red!)),
             isUploading || sentByte> 0.0?
              paddingg(
                15,
                15,
                12, Directionality(
                textDirection: TextDirection.ltr,
                  child: LinearProgressIndicator(
                  //value:sentByte,
              ),
                ),
              ):SizedBox(),

              isUploading?
              paddingg(
                15,
                15,
                12, text(
             context, 'جاري تحميل الفيديو .....', 12, black
              ),
              ):SizedBox(),

              SizedBox(height: 20.h),

              padding(
                15,
                15,
                gradientContainerNoborder(
                    getSize(context).width,
                    buttoms(context, 'اضافة ', 15, white, () {
                      if(_formKey.currentState!.validate()){
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (BuildContext context) {
                        if(studioVideo != null){
                          FocusManager.instance.primaryFocus
                              ?.unfocus();
                          addvideo(userToken!, (double sentBytes, double totalBytes){
                            setState(() {
                              // sentByte = sentByte;
                              print(sentBytes.toString() + 'nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
                            });
                          } ).then((value) =>{
                            setState((){isUploading = false;}),
                            value == ''?
                            {
                              goToPagePushRefresh(context, ActivityScreen(),then: (value){Navigator.pop(context);}),
                              showMassage(context, 'تم بنجاح',
                                  'تمت الاضافة بنجاح', done: done),}:
                            {
                              value == 'SocketException' ? {
                                Navigator.pop(context),
                                showMassage(
                                    context, 'فشل الاتصال بالانترنت',
                                    socketException)
                              } :
                              value == 'serverException' ? {
                                Navigator.pop(context),
                                showMassage(
                                  context, 'خطا', serverException,)
                              } :
                              value == 'TimeoutException' ? {
                                Navigator.pop(context),
                                showMassage(
                                    context, 'خطا', timeoutException)
                              } :
                              showMassage(context, 'خطا', value.replaceAll('حدث خطا ما الرجاء المحاولة لاحقا', ''),),
                            }
                          }
                          );
                        }else{setState(() {
                          isEmptyFile = true;
                        });}



                        //     // == First dialog closed
                        //     return
                        //       Align(
                        //         alignment: Alignment.center,
                        //         child: Lottie.asset(
                        //           "assets/lottie/loding.json",
                        //           fit: BoxFit.cover,
                        //         ),
                        //       );},
                        //
                        // );


                      }
                    })),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        )))),
      ),
    );
  }

  Future<String> addvideo(String token, OnUploadProgressCallback onUploadProgress) async {
    setState(() {
      isUploading= true;
    });
    var completer = new Completer<String>();
    var contents = new StringBuffer();
   var stream =
   new http.ByteStream(DelegatingStream.typed(studioVideo!.openRead()));
   // get file length
   var length = await studioVideo!.length();

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
       filename: basename(studioVideo!.path));

   // add file to multipart
   request.files.add(multipartFile);
   request.headers.addAll(headers);
   request.fields["title"] = '';
    request.fields["description"] = controlvideodesc.text;
   request.fields["type"] = "vedio";
   // send
   var response = await request.send();
   print(response.statusCode);
   // listen for response
    postsstudio.clear();
    setState(() {
      isUploading= false;
    });
   if (response.statusCode != 200) {
     throw Exception('Error uploading file');
   } else {
     setState(() {
       isUploading= false;
     });
     return  '';
   }

 }


   Future<String> readResponseAsString( response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
  Future<File?> getVideo(context) async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
    final String fileExtension = Path.extension(fileName);
    File newVideo = await file.copy('$path/$fileName');

      if (fileExtension == ".mp4") {
        setState(()  {
        studioVideo = newVideo;
      });
        // mediaInfo = await VideoCompress.compressVideo(
        //   studioVideo!.path,
        //   quality: VideoQuality.MediumQuality,
        //   deleteOrigin: false, // It's false by default
        // );
      } else {
        showMassage(context, 'عذرا', 'mp4 صيغة الفيديو غير مسموح بها, الرجاء رفع الفيديو بصيغة ');
      }


  }
}
