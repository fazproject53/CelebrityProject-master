import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Users/verifyAccount/checkVerificationUser.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Celebrity/verifyAccount/VerificationModel.dart';
import '../../Models/Methods/method.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:async/async.dart';

class continueVerifyUser extends StatefulWidget {
  String? accountType;
  Future<Verification>? verifyInfo;
  continueVerifyUser({Key? key, this.accountType, this.verifyInfo  }) : super(key: key);
  _continueVerifyUserState createState() => _continueVerifyUserState();

}

class _continueVerifyUserState extends State<continueVerifyUser> {

  File? file;
  String? userToken;
  bool? emptyFile;
  String? tempPath;
  @override
  void initState() {
    print(widget.accountType.toString() + '===========================');
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar(widget.accountType == 'شركة او مؤسسة'? 'توثيق حساب شركة':'توثيق حساب افراد', context),
          body:FutureBuilder<Verification>(
              future: widget.verifyInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ) {
                  return Center(child: mainLoad(context));
                } else if (snapshot.connectionState ==
                    ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return  Center(
                        child: checkServerException(context));
                  }
                  //---------------------------------------------------------------------------
                  else if (snapshot.hasData) {

                    return padding( 30, 30 ,Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 50.h,),
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    getFile(context);
                                  });
                                },
                                child: Image.asset('assets/image/addfile2.png', height: 120.h)),
                            SizedBox(height: 35.h,),
                            file != null?Container(
                                alignment: Alignment.center,
                                child: text(context, Path.basename(file!.path), 20, greyBlack, align: TextAlign.center)):
                            Padding(
                              padding: EdgeInsets.only(right: 0.w),
                              child:text(context,widget.accountType == 'شركة او مؤسسة'? snapshot.data!.data!.comments![1].value!: snapshot.data!.data!.comments![0].value!, textHeadSize, greyBlack, align: TextAlign.center),
                            ),
                            emptyFile != null && file ==null?
                            Column(
                              children: [
                                SizedBox(height: 20.h,),
                                text(context, emptyFile!?widget.accountType == 'شركة او مؤسسة'?'* يجب رفع ملف السجل التجاري':'* يجب رفع ملف الترخيص الاعلاني':'', textError, emptyFile!? red! :white, align: TextAlign.center)
                              ],
                            )
                                :SizedBox(),
                            SizedBox(height: emptyFile != null && file == null? 250.h: 290.h,),
                            file != null?InkWell(
                              onTap: () async {
                                // final extDir = await getApplicationDocumentsDirectory();
                                // final String dirPath = "${extDir.path}"+ Path.basename(file!.path);
                                //
                                // Directory dd=  await Directory(dirPath).create(recursive: true);
                                final Directory? directory = await getApplicationDocumentsDirectory();
                                final path = directory!.path;
                                final folderName = "$path/downloads/${Path.basename(file!.path)}";
                                final path2 = Directory(folderName);
                                // if ((await path2.exists())) {
                                //   // TODO:
                                //   print("exist");
                                // } else {
                                //   // TODO:
                                //   print("does not exist");
                                //   path2.create(recursive: true);
                                //   print("does not exist");
                                // }
                                OpenFile.open('$tempPath');

                              },
                              child: Container(margin:EdgeInsets.only(right: 25.w),alignment: Alignment.centerRight,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(attach,size: 20.h, color: purple,),
                                          text(context,Path.basename(file!.path).length > 30? Path.basename(file!.path).substring(0,30): Path.basename(file!.path), 15, greyBlack, align: TextAlign.right),
                                        ],
                                      ),
                                      SizedBox(height: 10.h,)
                                    ],
                                  )),
                            ):SizedBox(),
                            SizedBox(height: file == null?(widget.accountType == 'شركة او مؤسسة'?50.h:0.h):20.h),
                            Container(
                              child: gradientContainerNoborder(200, InkWell(
                                onTap: (){
                                  file == null? setState((){
                                    emptyFile = true;
                                  }):
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context2) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      addVerifyUser().then((value) => {
                                        value.contains('true')
                                            ? {
                                         gotoPageAndRemovePrevious(context2,  checkVerificationUser(accountType: widget.accountType,file: file,)),
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
                                  ;},
                                child: Padding(
                                  padding:  EdgeInsets.only(top:8.h, bottom: 8.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/image/send.png', height: 25.h),
                                      text(context, 'ارسال ', 18, white, align: TextAlign.center, fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                            SizedBox(height: file == null? 20.h: 20.h)
                          ],),
                      ),
                    ),
                    );
                  }else {
                    return const Center(child: Text('Empty data'));
                  }
                } else {
                  return Center(
                      child: Text('State: ${snapshot.connectionState}'));
                }
              }
          ), ));}

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
        print( path +'/'+fileName.toString()+ '===============================================');
        file = newImage;
        tempPath = path +'/'+fileName;
      });
    }else{  showMassage(context, 'عذرا', 'pdf صيغة الملف غير مسموح بها, الرجاء رفع ملف بصيغة ');}
  }
  Future<String> addVerifyUser() async {
    try {
      var stream = new http.ByteStream(
          DelegatingStream.typed(file!.openRead()));
      // get file length
      var length = await file!.length();

      // string to uri
      var uri = Uri.parse(
          "https://mobile.celebrityads.net/api/user/profile/verified");

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };
      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = http.MultipartFile('verified_file', stream, length,
          filename: Path.basename(file!.path));

      request.files.add(multipartFile);
      request.headers.addAll(headers);
      request.fields["user_type"] = widget.accountType == 'فرد' ||  widget.accountType == 'person'? 'person': 'company';

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

}