import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';

import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;

import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';
import '../../ModelAPI/CelebrityScreenAPI.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../Pricing/ModelPricing.dart';
import '../Requests/GenerateContract.dart';
import 'ContinueAdvArea.dart';
import 'package:celepraty/Users/Setting/userProfile.dart' as up;

class advArea extends StatefulWidget{
 final String? id;
 final String? privacyPolicy, name;
 final Celebrity? cel;
  const advArea({Key? key,this.cel, this.privacyPolicy, this.id, this.name}) : super(key: key);

  _advAreaState createState() => _advAreaState();
}

class _advAreaState extends State<advArea>{

  final _formKey = GlobalKey<FormState>();
  final TextEditingController link = new TextEditingController();

  String? userToken;
  Future<Pricing>? pricing;
  File? image;
   DateTime dateTime = DateTime.now();
  final TextEditingController copun = new TextEditingController();
  bool activateIt = false;
  bool datewarn2= false;
  bool datewarn3= false;
  bool dateInvalid = false;
  bool check2 = false;
  bool warn2= false;
  bool warnimage= false;
String? showFile;
var file;
up.User? ug;
  Timer? _timer;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
    });
    DatabaseHelper.getUserGlobal().then((value) {
      setState(() {
        Map<String, dynamic> m = jsonDecode(
            value)['data']['user'];
        ug = up.User.fromJson(m);
        print(ug!.name.toString()+'=====================================');
      });
    });
        pricing = fetchCelebrityPricing(widget.id!);
        print(widget.privacyPolicy);
    super.initState();
  }
File? file2;
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: drowAppBar('مساحة اعلانية', context),
          body: SingleChildScrollView(
          child: Container(
          child: Form(
          key: _formKey,
          child: paddingg(12, 12, 5, Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          SizedBox(height: 50.h,),
            padding(10, 12, Container( alignment : Alignment.topRight,child:  Text(' اطلب مساحتك الاعلانية', style: TextStyle(fontSize: 18.sp, color: textBlack , fontFamily: 'Cairo'), )),),

            SizedBox(height: 20.h,),
            FutureBuilder(
                future: pricing,
                builder: ((context, AsyncSnapshot<Pricing> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center();
                  } else if (snapshot.connectionState ==
                      ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                      //---------------------------------------------------------------------------
                    } else if (snapshot.hasData) {
                      snapshot.data!.data != null && snapshot.data!.data!.price!.adSpacePrice != null  ?  activateIt = true :null;
                      return snapshot.data!.data == null?
                      SizedBox(): paddingg(15, 15, 12, Container(height: 55.h,decoration: BoxDecoration(color: deepPink, borderRadius: BorderRadius.circular(8)),
                        child:   Padding(
                          padding: EdgeInsets.all(10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text('سعر الاعلان ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: white , fontFamily: 'Cairo'), ),
                              ),
                              Text( snapshot.data!.data!.price!.adSpacePrice.toString() + ' ر.س ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: white , fontFamily: 'Cairo'), ),
                            ],
                          ),),),
                      );
                    } else {
                      return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
                    }
                  } else {
                    return Center(
                        child: Text('State: ${snapshot.connectionState}'));
                  }
                })),
            paddingg(15, 15, 12,textFieldNoIcon(context, 'رابط صفحة المعلن', 14, false, link,(String? value) {if (value == null || value.isEmpty) {
                return 'حقل اجباري';

              }else{
              bool _validURL;
              if(value.contains('https://') || value.contains('http://') ){
                _validURL = Uri.parse(value).isAbsolute;
              }else{
                 _validURL = Uri.parse('https://' +value).isAbsolute;
              }

             return  _validURL? null: 'رابط الفحة غير صحيح';
            }},false),),

            paddingg(15.w, 15.w, 12.h,textFieldNoIcon(context, 'ادخل كود الخصم', 14.sp, false, copun,(String? value) { return null;},true),),

             SizedBox(height: 10.h),
            paddingg(15, 15, 0, uploadImg(200, 50,text(context, image != null? 'تغيير الصورة':'قم برفع الصورة التي تريد وضعها بالاعلان', 12, black),(){getImage(context);}),),
            InkWell(
                onTap: (){image != null?
                showDialog(
                  useSafeArea: true,
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    _timer = Timer(Duration(seconds: 2), () {
                      Navigator.of(context).pop();    // == First dialog closed
                    });
                    return
                      Container(
                          height: double.infinity,
                          child: Image.file(image!));},
                )
                    :null;},
                child: paddingg(10.w, 20.w, image != null?10.h: 0.h,Row(
                  children: [
                    image != null? Icon(Icons.image, color: newGrey,): SizedBox(),
                    SizedBox(width: image != null?5.w: 0.w),
                    text(context,warnimage && image == null ? 'الرجاء اضافة صورة': image != null? 'معاينة الصورة':'',12,image != null?black:red!,)
                  ],
                ))),
            SizedBox(height: warnimage? 5.h:5.h),
            InkWell(
              child: padding(15, 15,SizedBox(
                height: 45.h,
                child: gradientContainerNoborder(97, Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(scheduale, color: white,),
                    SizedBox(width: 15.w,),
                    text(context, dateTime.day != DateTime
                        .now()
                        .day ? dateTime.year.toString() + '/' +
                        dateTime.month.toString() + '/' +
                        dateTime.day.toString() : 'تاريخ الاعلان',
                        15.sp, white,
                        fontWeight: FontWeight.bold),
                  ],
                ),height: 50),
              )
              ),
              onTap: () async { DateTime? endDate =
                  await showDatePicker(
                  builder: (context, child) {
                    return Theme(
                        data: ThemeData.light().copyWith(
                            colorScheme:
                            const ColorScheme.light(primary: purple, onPrimary: white)),
                        child: child!);}
                  context:
                  context,
                  initialDate:
                  dateTime,
                  firstDate:
                  DateTime(
                      2000),
                  lastDate:
                  DateTime(
                      2100));
              if (endDate == null)
                return;
              setState(() {
                dateTime= endDate;
                datewarn2 =false;
                dateTime.isBefore(DateTime.now()) ?{ dateTime.day != DateTime.now().day?dateInvalid= true: dateInvalid= false}:
                dateInvalid= false;
              });},
            ),

            paddingg(15.w, 20.w, 0.h,text(context,datewarn2? 'الرجاء اختيار تاريخ النشر':dateInvalid? 'التاريخ غير صالح': '', 12,red!,)),
            paddingg(0.w, 0.w, 0.h,InkWell(
              onTap: (){setState(() {
                file2 != null? OpenFile.open('$showFile'): getFile2(context);
                datewarn3 = false;
              });},
              child: Container(child: Row(children: [IconButton(icon: Icon(Icons.upload_rounded),onPressed:(){setState(() {
                file2 != null? OpenFile.open('$showFile'): getFile2(context);
                datewarn3 = false;
              });},color: purple,), text(context, file2 != null? Path.basename(file2!.path):'الرجاء رفع ملف السجل التجاري', 12, black)])),
            ),),
            paddingg(15.w, 20.w, 0.h,text(context,datewarn3? 'ملف السجل التجاري اجباري': '', 12,red!,)),
            paddingg(0,0,3.h, CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title:
              RichText(
                  text:  TextSpan(children: [
                    TextSpan(
                        text:
                        ' عند الطلب ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة ب ',
                        style: TextStyle(
                            color: black, fontFamily: 'Cairo', fontSize: 12)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = () async {
                          showDialogFunc(context, '', widget.privacyPolicy);
                        },
                        text: widget.name.toString() ,
                        style: TextStyle(
                            color: blue, fontFamily: 'Cairo', fontSize: 12))
                  ])),
              value: check2,
              selectedTileColor: warn2 == true? red: black,
              subtitle: Text(warn2 == true?'حتى تتمكن من الطلب  يجب الموافقة على الشروط والاحكام':'' ,style: TextStyle(color: red),),
              onChanged: (value) {
                setState(() {
                  setState(() {
                    check2 = value!;
                  });
                });
              },)

              ,),
             SizedBox(height: 30.h,),
           check2 && activateIt? padding(15, 15, gradientContainerNoborder(getSize(context).width,  buttoms(context, 'متابعة للطلب', 15, white, () async {
              _formKey.currentState!.validate()? {
                check2 && dateTime.day != DateTime.now().day && image != null && file2 != null && !dateTime.isBefore(DateTime.now())?{

                  goTopagepush(context, ContinueAdvArea(
                    description: '',
                    advLink: link.text,
                    advOrAdvSpace: 'مساحة اعلانية',
                    platform: "",
                    advTitle: "",
                    celerityVerifiedType:
                    widget.cel!.verified != null ? widget.cel!.verified!.name! == 'Person'?'رخصة اعلانية':'سجل تجاري': "",
                    avdTime: "",
                    celerityCityName:
                    widget.cel!.city!.name!,
                    celerityEmail: widget.cel!.email!,
                    celerityIdNumber:
                    widget.cel!.idNumber!,
                    celerityName: widget.cel!.name!,
                    celerityNationality:
                    widget.cel!.nationality!.nationalityy_ar!,
                    celerityPhone: widget.cel!.phonenumber!,
                    celerityVerifiedNumber:
                    widget.cel!.commercialNumber!,
                    userCityName:ug!.city!.name!,
                    userEmail: ug!.email!,
                    userIdNumber: ug!.idNumber!,
                    userName: ug!.name!,
                    userNationality:
                    ug!.nationality!.nationalityy_ar!,
                    userPhone: ug!.phonenumber!,
                    userVerifiedNumber:
                    ug!.commercialNumber!,
                    userVerifiedType:
                    ' سجل تجاري ',
                    file: file,
                    token: userToken,
                    cel: widget.cel,
                    date: dateTime.day.toString() + '/' +
                        dateTime.month.toString() + '/' +
                        dateTime.year.toString(),
                    datetoapi: dateTime,
                    pagelink: link.text,
                    time: "",
                    type: 'مساحة اعلانية',
                    commercialrecord: file2,
                    copun: copun.text,
                    image: image,
                      celeritySigntion: "",
                  ))


                } : setState((){ !check2? warn2 = true: false;
                dateTime.day == DateTime.now().day? datewarn2 = true: false;
                dateTime.isBefore(DateTime.now())? dateInvalid = true: false;
                file2 == null? datewarn3 = true: false;
                image == null? warnimage =true:false;}),

              }: null;
            })),):

           padding(15, 15, Container(width: getSize(context).width,
               decoration: BoxDecoration( borderRadius: BorderRadius.circular(8.r),   color: grey,),
               child: buttoms(context,'متابعة للطلب', 15, white, (){})
           ),),
            SizedBox(height: 80.h,),
          ]),
          ),

          )))),
    );}


  Future<File?> getFile2(context) async {
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
    if(  fileExtension == ".pdf") {
      setState(() {
        file2 = newImage;
        showFile= path + '/' +fileName;
      });
    }else{
      showMassage(context, 'عذرا', 'pdf صيغة الملف غير مسموح بها, الرجاء رفع ملف بصيغة ');
     }
  }
  Future<File?> getImage(context) async {
    PickedFile? pickedFile =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
    final String fileExtension = Path.extension(fileName);
    File newImage = await file.copy('$path/$fileName');
    if(fileExtension == ".png" || fileExtension == ".jpg"){
      setState(() {
        image = newImage;
      });
    }else{ showMassage(context, 'عذرا', 'png او jpg صيغة الصورة غير مسموح بها, الرجاء رفع الصورة بصيغة ');}

  }
  Future<Pricing> fetchCelebrityPricing(String id ) async {
    String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDAzNzUwY2MyNjFjNDY1NjY2YjcwODJlYjgzYmFmYzA0ZjQzMGRlYzEyMzAwYTY5NTE1ZDNlZTYwYWYzYjc0Y2IxMmJiYzA3ZTYzODAwMWYiLCJpYXQiOjE2NTMxMTY4MjcuMTk0MDc3OTY4NTk3NDEyMTA5Mzc1LCJuYmYiOjE2NTMxMTY4MjcuMTk0MDg0ODgyNzM2MjA2MDU0Njg3NSwiZXhwIjoxNjg0NjUyODI3LjE5MDA0ODkzMzAyOTE3NDgwNDY4NzUsInN1YiI6IjExIiwic2NvcGVzIjpbXX0.GUQgvMFS-0VA9wOAhHf7UaX41lo7m8hRm0y4mI70eeAZ0Y9p2CB5613svXrrYJX74SfdUM4y2q48DD-IeT67uydUP3QS9inIyRVTDcEqNPd3i54YplpfP8uSyOCGehmtl5aKKEVAvZLOZS8C-aLIEgEWC2ixwRKwr89K0G70eQ7wHYYHQ3NOruxrpc_izZ5awskVSKwbDVnn9L9-HbE86uP4Y8B5Cjy9tZBGJ-6gJtj3KYP89-YiDlWj6GWs52ShPwXlbMNFVDzPa3oz44eKZ5wNnJJBiky7paAb1hUNq9Q012vJrtazHq5ENGrkQ23LL0n61ITCZ8da1RhUx_g6BYJBvc_10nMuwWxRKCr9l5wygmIItHAGXxB8f8ypQ0vLfTeDUAZa_Wrc_BJwiZU8jSdvPZuoUH937_KcwFQScKoL7VuwbbmskFHrkGZMxMnbDrEedl0TefFQpqUAs9jK4ngiaJgerJJ9qpoCCn4xMSGl_ZJmeQTQzMwcLYdjI0txbSFIieSl6M2muHedWhWscXpzzBhdMOM87cCZYuAP4Gml80jywHCUeyN9ORVkG_hji588pvW5Ur8ZzRitlqJoYtztU3Gq2n6sOn0sRShjTHQGPWWyj5fluqsok3gxpeux5esjG_uLCpJaekrfK3ji2DYp-wB-OBjTGPUqlG9W_fs';
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/price/$id'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return Pricing.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }


  showDialogFunc(context, title, areaDes) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: white,
              ),
              padding: EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
              height: 400.h,
              width: 380.w,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: TextDirection.rtl,
                  children: [
                    ///Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///text
                        text(context, 'تفاصيل سياسة التعامل', 14, grey!),
                      ],
                    ),

                    SizedBox(
                      height: 30.h,
                    ),

                    ///---------------------

                    ///Area Title
                    text(context, 'سياسة المساحة الاعلانية', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Area Details
                    text(
                      context,
                      areaDes,
                      14,
                      ligthtBlack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


