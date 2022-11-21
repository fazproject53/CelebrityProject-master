import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Celebrity/verifyAccount/verify.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Models/Methods/method.dart';
import 'VerificationModel.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:async/async.dart';
class checkVerification extends StatefulWidget {

  File? file;
  String? accountType;
  checkVerification({Key? key, this.accountType, this.file,}) : super(key: key);
  _checkVerificationState createState() => _checkVerificationState();
}

class _checkVerificationState extends State<checkVerification> {
  bool isValue1 = false;
  int? _value;
  bool edit = false;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  Future<Verification>? verifyInfo;
  String? userToken, tempPath;
  String? name;
  Future<File>? file;
  File? file2;
  void initState() {

    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        verifyInfo = getVerification(userToken!);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar('التحقق من التوثيق', context),
          body:FutureBuilder<Verification>(
              future: verifyInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ) {
                  return Center(child: mainLoad(context));
                } else if (snapshot.connectionState ==
                    ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    if (!isConnectSection) {
                      return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.h),
                            child: SizedBox(
                                height: 300.h,
                                width: 250.w,
                                child: internetConnection(
                                    context, reload: () {
                                  setState(() {
                                    verifyInfo =
                                        getVerification(userToken!);
                                    isConnectSection = true;
                                  });
                                })),
                          ));
                    } else {
                      if (!serverExceptions) {
                        return Container(
                          height: getSize(context).height / 1.5,
                          child: Center(
                              child: checkServerException(context)
                          ),
                        );
                      } else {
                        if (!timeoutException) {
                          return Center(
                            child: checkTimeOutException(
                                context, reload: () {
                              setState(() {
                                verifyInfo =
                                    getVerification(userToken!);
                              });
                            }),
                          );
                        }
                      }
                      return  Center(
                          child: checkServerException(context));
                    }
                    //---------------------------------------------------------------------------
                  } else if (snapshot.hasData) {
                    snapshot.data!.data!.celebrity!.verifiedFile == null? null:{

                      name =snapshot.data!.data!.celebrity!.verifiedFile!.split('/').last,

                      file =  downloadFile(snapshot.data!.data!.celebrity!.verifiedFile!, name!)};
                    widget.accountType == null? widget.accountType = snapshot.data!.data!.celebrity!.celebrityType!: null;
                    print('================================================' + widget.accountType!);

                    return
             padding( 10, 20 ,SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h,),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.asset('assets/image/verifycheck.png', height: 100.h),
                      snapshot.data!.data!.celebrity!.verifiedRejectReson == ''?Image.asset('assets/image/check.png', height: 30.h): SizedBox(),
                    ],
                  ),
                  SizedBox(height: 35.h,),
                  text(context,snapshot.data!.data!.celebrity!.verified!.name! , textHeadSize, greyBlack, align: TextAlign.center),
                  //+
                  snapshot.data!.data!.celebrity!.verifiedRejectReson ==  ''?
                  text(context,'' , 0, greyBlack, align: TextAlign.center)
                      :text(context,' بسبب '+ snapshot.data!.data!.celebrity!.verifiedRejectReson! , textHeadSize, greyBlack, align: TextAlign.center),
                  SizedBox(height: edit? 85.h :135.h,),
               SizedBox(height: file2 == null && snapshot.data!.data!.celebrity!.verifiedRejectReson ==  ''?50.h:0.h),
               SizedBox(height: file2 != null?50.h : snapshot.data!.data!.celebrity!.verifiedRejectReson ==  ''?130.h:110,),
                  file2 != null?InkWell(
                    onTap: () async {

                      OpenFile.open('$tempPath');
                    },
                    child: Container(margin:EdgeInsets.only(right: 25.w),alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(attach,size: 20.h, color: purple,),
                                text(context, Path.basename(file2!.path), 15, greyBlack, align: TextAlign.right),
                              ],
                            ),
                            SizedBox(height: 20.h,)
                          ],
                        )),
                  ):Container(margin:EdgeInsets.only(right: 25.w),alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await launch(snapshot.data!.data!.celebrity!.verifiedFile!);
                            },
                            child: Row(
                              children: [
                                Icon(attach,size: 20.h, color: purple,),
                                text(context, Path.basename(snapshot.data!.data!.celebrity!.verifiedFile!.length > 21?snapshot.data!.data!.celebrity!.verifiedFile!.substring(80):snapshot.data!.data!.celebrity!.verifiedFile!), textSubHeadSize, greyBlack, align: TextAlign.right),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h,)
                        ],
                      )),
                  snapshot.data!.data!.celebrity!.verifiedRejectReson ==  ''? SizedBox() :
                  InkWell(
                    onTap: (){
                      file2 == null? getFile(context):null;
                    setState(() {
                      file2 != null?setState((){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context2) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            updateVerify().then((value) => {
                              value.contains('true')
                                  ? {
                                gotoPageAndRemovePrevious(context2,  checkVerification(accountType: widget.accountType,file: file2,)),
                                //done
                                showMassage(context, 'تم بنجاح',
                                    value.replaceAll('true', ''),
                                    done: done),
                              }
                                  :  value == 'SocketException'?
                              { Navigator.pop(context),
                                Navigator.pop(context2),
                                showMassage(
                                  context2,
                                  'خطا',
                                  socketException,
                                )}
                                  :{
                                value == 'serverException'? {
                                  Navigator.pop(context),
                                  Navigator.pop(context2),
                                  showMassage(
                                    context2,
                                    'خطا',
                                    serverException,
                                  )
                                }:{
                                  value.replaceAll('false', '') ==  'المستخدم محظور'? {
                                    Navigator.pop(context),
                                    Navigator.pop(context2),
                                    showMassage(
                                      context2,
                                      'خطا',
                                      'لا يمكنك اكمال رفع الطلب ',
                                    )
                                  } :{
                                    //كود الخصم غير موجود
                                    Navigator.pop(context),
                                    Navigator.pop(context2),
                                    showMassage(
                                      context,
                                      'خطا',
                                      value.replaceAll('false', ''),
                                    )}
                                }
                              }
                            });

                            // == First dialog closed
                            return Align(
                              alignment: Alignment.center,
                              child: Lottie.asset(
                                "assets/lottie/loding.json",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }):null;
                    });},
                    child: Container( width: 350.w, height: 45.h,decoration: BoxDecoration( borderRadius: BorderRadius.circular(8.r), color: white, border: Border.all(color: black, width:0.5)),
                    child: file2 != null? Center(child: text(context, 'تاكيد', textSubHeadSize, black, align: TextAlign.center)):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/upload.png', height: 30.h,),
                        SizedBox(width: 10.w,),
                        text(context, 'اعادة رفع الملف', textSubHeadSize, black, align: TextAlign.center),
                      ],
                    ),),
                  ),

               SizedBox(height: 10.h,),
               InkWell(
                   onTap: (){Navigator.pop(context);},
                   child: gradientContainerNoborder(350,Container(alignment: Alignment.center,height: 45.h,child: text(context, 'انهاء', largeButtonSize, white, fontWeight: FontWeight.bold, align: TextAlign.center)))),
       SizedBox(height: 10.h,)
         ] ), ));
    } else {
  return const Center(child: Text('Empty data'));
  }
} else {
return Center(
child: Text(''));
}
}
          )),);}

  Future<Verification> getVerification(String tokenn) async {
    try{
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/celebrity/verified-account'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenn'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        return Verification.fromJson(jsonDecode(response.body));
      } else {
        // print(userToken);
        return Future.error('fetchCelebrities error ${response.statusCode}');
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
  }
  Future<File?> getFile(context) async {
    FilePickerResult? pickedFile =
    await FilePicker.platform.pickFiles(type: FileType.any);
    if (pickedFile == null) {
      return null;
    }
    final File f = File(pickedFile.paths[0]!);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.paths[0]!);
    final String fileExtension = Path.extension(fileName);
    File newImage = await f.copy('$path/$fileName');
    if( fileExtension == ".pdf") {
      setState(() {
        file2 = newImage;
        tempPath= path +'/'+fileName;
      });
    }else{  showMassage(context, 'عذرا', 'pdf صيغة الملف غير مسموح بها, الرجاء رفع ملف بصيغة ');}
  }
  Future<String> updateVerify() async {
    try {
      var stream = new http.ByteStream(
          DelegatingStream.typed(file2!.openRead()));
      // get file length
      var length = await file2!.length();

      // string to uri
      var uri = Uri.parse(
          "https://mobile.celebrityads.net/api/celebrity/profile/verified");

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };
      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = http.MultipartFile('verified_file', stream, length,
          filename: Path.basename(file2!.path));

      request.files.add(multipartFile);
      request.headers.addAll(headers);
      request.fields["celebrity_type"] = widget.accountType == 'فرد' ||  widget.accountType == 'person'? 'person': 'company';

      var response = await request.send();
      http.Response respo = await http.Response.fromStream(response);
      print(jsonDecode(respo.body)['message']['ar']);
      return jsonDecode(respo.body)['message']['ar'] +jsonDecode(respo.body)['success'].toString();
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
}