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
import '../../ModelAPI/CelebrityScreenAPI.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../Pricing/ModelPricing.dart';
import 'ContinueAdvArea.dart';
import 'package:celepraty/Users/Setting/userProfile.dart' as up;


import 'dart:io';
import 'dart:typed_data';

import 'package:celepraty/Celebrity/MyRequests/myRequestsMain.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:lottie/lottie.dart';
import '../../Models/Variables/Variables.dart';
import '../../Users/UserRequests/UserReguistMainPage.dart';
import 'package:async/async.dart';
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
  ScrollController _controller = ScrollController();
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
    //_controller = ScrollController();
        pricing = fetchCelebrityPricing(widget.id!);
        print(widget.privacyPolicy);
    super.initState();
  }

  //-----------------------------------------------------------------------------
  List<Widget> terms = [];
  List<String> termsToApi=[];
  int i = -1;
  bool adding = true;
  TextEditingController termController = TextEditingController();
  // باقي كود ال كونترولر في ال initState

  //-----------------------------------------------------------------------------
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
            padding(10, 12, Container( alignment : Alignment.topRight,child:  Text(' اطلب مساحتك الاعلانية', style: TextStyle(fontSize:textSubHeadSize, color: textBlack , fontFamily: 'Cairo'), )),),

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
            paddingg(15, 15, 12,textFieldNoIcon(context, 'رابط صفحة المعلن', textFieldSize, false, link,(String? value) {if (value == null || value.isEmpty) {
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

            paddingg(15.w, 15.w, 12.h,textFieldNoIcon(context, 'ادخل كود الخصم', textFieldSize, false, copun,(String? value) { return null;},true),),

            paddingg(15, 15, 10,InkWell(
              onTap: (){
                FocusManager
                    .instance.primaryFocus
                    ?.unfocus();
                showTermsDialog(context);
                adding && terms.isEmpty?{terms.add(Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding:  EdgeInsets.only(top:15.h),
                    child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                  ),
                ),),
                  setState(() {
                    adding= false;
                  })}: null;},
              child: Container(height: 50.h,
                decoration: BoxDecoration(color: grey!.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r), border: Border.all(color: black,width: 0.5.w)),child: paddingg(15, 15,0, Align(
                  alignment:Alignment.centerLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(context,termsToApi.isEmpty ?' اضافة بنود العقد': 'معاينة وتعديل البنود', 17, newGrey),
                            GestureDetector(
                              onTap: (){

                              },
                              child: IconButton(onPressed:(){
                                FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus();
                                showTermsDialog(context);
                                adding && terms.isEmpty?{terms.add(Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding:  EdgeInsets.only(top:15.h),
                                    child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                                  ),
                                ),),
                                  setState(() {
                                    adding= false;
                                  })}: null;

                                print('when close -----------------------');
                              },icon: Icon(termsToApi.isEmpty ?add:show, color: newGrey,)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),),
            )),
            SizedBox(height: 10.h),
            paddingg(15, 15, 0, uploadImg(200, 50,text(context, image != null? 'تغيير الصورة':'قم برفع الصورة التي تريد وضعها بالاعلان', textFieldSize, black),(){  FocusManager
                .instance.primaryFocus
                ?.unfocus();getImage(context);}),),
            InkWell(
                onTap: (){
                  FocusManager
                      .instance.primaryFocus
                      ?.unfocus();
                  image != null?
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
                    text(context,warnimage && image == null ? 'الرجاء اضافة صورة': image != null? 'معاينة الصورة':'',textError,image != null?black:red!,)
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
                        textFieldSize, white,
                        fontWeight: FontWeight.bold),
                  ],
                ),height: 50),
              )
              ),
              onTap: () async {
                FocusManager
                    .instance.primaryFocus
                    ?.unfocus();
                DateTime? endDate =
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

            paddingg(15.w, 20.w, 5.h,text(context,datewarn2? 'الرجاء اختيار تاريخ النشر':dateInvalid? 'التاريخ غير صالح': '', textError,red!,)),
            paddingg(0.w, 0.w, 0.h,InkWell(
              onTap: (){setState(() {
                file2 != null? OpenFile.open('$showFile'): getFile2(context);
                datewarn3 = false;
              });},
              child: Container(child: Row(children: [IconButton(icon: Icon(Icons.upload_rounded),onPressed:(){setState(() {
                 getFile2(context);
                datewarn3 = false;
              });},color: purple,), text(context, file2 != null? Path.basename(file2!.path):'  الرجاء رفع ملف السجل التجاري pdf', textFieldSize, black)])),
            ),),
            paddingg(15.w, 20.w, 0.h,text(context,datewarn3? 'ملف السجل التجاري اجباري': '', textError,red!,)),
            paddingg(0,0,3.h, CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title:
              RichText(
                  text:  TextSpan(children: [
                    TextSpan(
                        text:
                        ' عند الطلب ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة ب ',
                        style: TextStyle(
                            color: black, fontFamily: 'Cairo', fontSize: textFieldSize)),
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
           check2 && activateIt? padding(15, 15, gradientContainerNoborder(getSize(context).width,  buttoms(context, 'متابعة للطلب', largeButtonSize, white, () async {
              _formKey.currentState!.validate()? {
                check2 && dateTime.day != DateTime.now().day && image != null && file2 != null && !dateTime.isBefore(DateTime.now())?{

                  // goTopagepush(context, ContinueAdvArea(
                  //   description: '',
                  //   advLink: link.text,
                  //   advOrAdvSpace: 'مساحة اعلانية',
                  //   platform: "",
                  //   advTitle: "",
                  //   celerityVerifiedType:
                  //   widget.cel!.verified != null ? widget.cel!.verified!.name! == 'Person'?'رخصة اعلانية':'سجل تجاري': "",
                  //   avdTime: "",
                  //   celerityCityName:
                  //   widget.cel!.city!.name!,
                  //   celerityEmail: widget.cel!.email!,
                  //   celerityIdNumber:
                  //   widget.cel!.idNumber!,
                  //   celerityName: widget.cel!.name!,
                  //   celerityNationality:
                  //   widget.cel!.nationality!.nationalityy_ar!,
                  //   celerityPhone: widget.cel!.phonenumber!,
                  //   celerityVerifiedNumber:
                  //   widget.cel!.commercialNumber!,
                  //   userCityName:ug!.city!.name!,
                  //   userEmail: ug!.email!,
                  //   userIdNumber: ug!.idNumber!,
                  //   userName: ug!.name!,
                  //   userNationality:
                  //   ug!.nationality!.nationalityy_ar!,
                  //   userPhone: ug!.phonenumber!,
                  //   userVerifiedNumber:
                  //   ug!.commercialNumber!,
                  //   userVerifiedType:
                  //   ' سجل تجاري ',
                  //   sendDate: DateTime.now(),
                  //   file: file,
                  //   token: userToken,
                  //   cel: widget.cel,
                  //   date: dateTime.day.toString() + '/' +
                  //       dateTime.month.toString() + '/' +
                  //       dateTime.year.toString(),
                  //   datetoapi: dateTime,
                  //   pagelink: link.text,
                  //   time: "",
                  //   type: 'مساحة اعلانية',
                  //   commercialrecord: file2,
                  //   copun: copun.text,
                  //   image: image,
                  //   celeritySigntion: "",
                  //
                  //
                  // ))

              setState(() {
              showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext
              context2) {
              FocusManager
                  .instance.primaryFocus
                  ?.unfocus();
              addAdAreaOrder()
                  .then((value) => {
              value.contains(
              'true')
                  ? {
              Navigator.pop(
              context2),
              currentuser == 'user' ?  gotoPageAndRemovePrevious(
              context2,
              const UserRequestMainPage(whereTo: 'area')):
              gotoPageAndRemovePrevious(context2, const MyRequestsMainPage(
              //  whereTo: 'area'
              )
              ),
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen(),), (route) => route.isFirst),
              //  Navigator.popUntil(context,  ModalRoute.withName(MainScreen().toString())),
              //  Navigator.pop(context2),
              //done
              showMassage(
              context2,
              'تم بنجاح',
              value.replaceAll('true',
              ''),
              done:
              done),
              }
                  : value ==
              'SocketException'
                  ? {
              Navigator.pop(context),
              Navigator.pop(context2),
              showMassage(
              context2,
              'خطا',
              socketException,
              )
              }
                  : {
              value == 'serverException'
                  ? {
              Navigator.pop(context),
              Navigator.pop(context2),
              showMassage(
              context2,
              'خطا',
              serverException,
              )
              }
                  : {
              value.replaceAll('false', '') == 'المستخدم محظور'
                  ? {
              Navigator.pop(context),
              Navigator.pop(context2),
              showMassage(
              context2,
              'خطا',
              'لا يمكنك اكمال رفع الطلب ',
              )
              }
                  : {
              //كود الخصم غير موجود
              Navigator.pop(context),
              Navigator.pop(context2),
              showMassage(
              context,
              'خطا',
              value.replaceAll('false', ''),
              )
              }
              }
              }
              });

              // == First dialog closed
              return AlertDialog(
              titlePadding:
              EdgeInsets.zero,
              elevation: 0,
              backgroundColor:
              Colors.transparent,
              content: Center(
              child: SizedBox(
              width: 300.w,
              height: 150.h,
              child: Align(
              alignment:
              Alignment
                  .topCenter,
              child:
              Lottie.asset(
              "assets/lottie/loding.json",
              fit: BoxFit
                  .cover,
              ),
              ),
              ),
              ),
              );
              },
              );
              })
                } : setState((){ !check2? warn2 = true: false;
                dateTime.day == DateTime.now().day? datewarn2 = true: false;
                dateTime.isBefore(DateTime.now())? dateInvalid = true: false;
                file2 == null? datewarn3 = true: false;
                image == null? warnimage =true:false;}),

              }: null;
            })),):

           padding(15, 15, Container(width: getSize(context).width,
               decoration: BoxDecoration( borderRadius: BorderRadius.circular(8.r),   color: grey,),
               child: buttoms(context,'متابعة للطلب', largeButtonSize, white, (){})
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

  //-----------------------------------------------------------------
  showTermsDialog(context){

    print(termsToApi.length.toString()+'////////////////////////////////////////');
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context2) {
          return StatefulBuilder(
            builder: (context2,sets){
              return Padding(
                padding:  EdgeInsets.only(top: 100.h, bottom: MediaQuery.of(context2).viewInsets.bottom, left: 20.w, right:20.w ),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.transparent,
                    child: Card(
                      child: Padding(
                          padding:  EdgeInsets.only(top: 30.h, bottom: 20.h, left: 10.w, right:10.w ),
                          child: paddingg(15, 15,0, Column(
                            children: [
                              Container(
                                height:425.h,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    SingleChildScrollView(
                                      child: Container(height: 425.h, width: double.infinity,child:
                                      ListView.builder(
                                        shrinkWrap:true,
                                        itemCount: terms.length,
                                        controller: _controller,
                                        itemBuilder: (context, index){
                                          return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child:
                                              Column(children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children:[
                                                      Row(
                                                        children: [
                                                          terms[index],
                                                        ],
                                                      ),

                                                      adding?
                                                      index != 0 && !adding?
                                                      i == index?
                                                      InkWell(onTap:(){sets((){ updateTerm(index);
                                                      i = -1;
                                                      });},child: Icon(done)):Row(children: [
                                                        InkWell(onTap:(){sets((){removeTerm(index);});},child: Icon(remove, color: red,)),SizedBox(width: 13.w,),
                                                        InkWell(onTap: () {
                                                          setState(() {
                                                            i = index;
                                                          });
                                                          sets(() {
                                                            i = index;
                                                            editTerm(index);
                                                            print(i.toString() + '................................');
                                                          });},child: Icon(editDiscount, color: newGrey,))],):
                                                      index != terms.length && adding?
                                                      i != index?
                                                      Row(children: [
                                                        InkWell(onTap:(){sets((){removeTerm(index);});},child: Icon(remove, color: red,)),SizedBox(width: 13.w,),
                                                        InkWell(onTap: (){
                                                          setState(() {
                                                            i = index;
                                                          });
                                                          sets(() {
                                                            i = index;
                                                            print(i.toString() + '................................');
                                                            editTerm(index);
                                                          });},child: Icon(editDiscount, color: newGrey,))],):  InkWell(onTap:(){sets((){ updateTerm(index);
                                                      i = -1;});},child: Icon(done, color: newGrey,)):SizedBox():SizedBox(),


                                                    ]),
                                                index != terms.length && adding?   SizedBox(
                                                  width: 300.w,
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(top: 10.h),
                                                    child: Divider(height: 0.75.h,),
                                                  ),
                                                ):  index != terms.length-1?
                                                SizedBox(
                                                  width: 300.w,
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(top: 10.h),
                                                    child: Divider(height: 0.75.h,),
                                                  ),
                                                )
                                                    : SizedBox()],)

                                          );
                                        },

                                      )),
                                    ),


                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    !adding? IconButton(onPressed: (){
                                      sets(() {
                                        terms.removeAt(0);
                                        termController.clear();
                                        adding = true;
                                      });
                                    },icon: Icon(cancel, color: newGrey,)):SizedBox(),
                                    SizedBox(width: 10.w,),
                                    IconButton(onPressed:  (){
                                      sets(() {
                                        print(adding.toString() +'when open -----------------------');
                                        adding?{
                                          terms.insert(0,Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:20.h),
                                              child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                                            ),
                                          ),),
                                          adding = false}:{
                                          terms.removeAt(0),
                                          termController.text.isEmpty?
                                          null:terms.add(Container(
                                            width:230.w,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:8.h),
                                              child: SizedBox(width: 230.w,child: text(context, termController.text, 16, black,align: TextAlign.start,)),
                                            ),
                                          )),


                                          termController.text.isEmpty?
                                          null:termsToApi.add(termController.text),
                                          setState(() {

                                          }),
                                          termController.clear(),
                                          adding = true,
                                        };
                                        print('when open -----------------------');
                                        !adding?_animateToIndex(0,50.0.h):_animateToIndex(terms.length,200.0.h);
                                      });
                                    },icon: Icon( !adding?Icons.done:i != -1?null:Icons.add, color: newGrey,size: 35.r,)),

                                  ],
                                ),
                              ),
                            ],
                          ))),
                    ),
                  ),
                ),
              );
            },
          );});
  }
  removeTerm(index){
    print(index.toString()+'the index count');
    setState(() {
      // termsToApi.removeAt(index);
      terms.removeAt(index);
      termsToApi.removeAt(index);
    });

  }
  updateTerm(index){
    setState(() {
      // termsToApi.removeAt(index);
      terms.removeAt(index);
      terms.insert(index, Container(width:200.w,
        child: Padding(
          padding:  EdgeInsets.only(top:8.h),
          child: SizedBox(width: 220.w,child: text(context, termController.text, 16, black,align: TextAlign.start,)),
        ),
      ));
    });
    i =-1;
    termsToApi[index] = termController.text;
    termController.clear();
  }
  editTerm(index){
    setState(() {
      termController.text = termsToApi[index];
      // termsToApi.removeAt(index);
      terms.removeAt(index);
      terms.insert(index, Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding:  EdgeInsets.only(top:20.h),
          child: Row(
            children: [
              //Icon(Icons.done),
              Container(width:270.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
            ],
          ),
        ),
      ),);
      // termsToApi.removeAt(index);
    });

  }
  void _animateToIndex(int index, double height) {
    _controller.animateTo(
      index * height,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<String> addAdAreaOrder() async {
    try {
      final directory = await getTemporaryDirectory();
      final filepath = directory.path + '/' + "signature.png";

      // File imgFile =
      // await File(filepath).writeAsBytes(png!.buffer.asUint8List());
      var stream =
      http.ByteStream(DelegatingStream.typed(image!.openRead()));
      // get file length
      var length = await image!.length();
      var stream2 = http.ByteStream(
          DelegatingStream.typed(file2!.openRead()));
      // get file length
      var length2 = await file2!.length();

      //var stream3 = http.ByteStream(DelegatingStream.typed(imgFile.openRead()));
      // get file length
    //  var length3 = await imgFile.length();

      // string to uri
      var uri =
      Uri.parse("https://mobile.celebrityads.net/api/order/ad-space/add");

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };
      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: Path.basename(image!.path));
      var multipartFile2 = http.MultipartFile(
          'commercial_record', stream2, length2,
          filename: Path.basename(file2!.path));

      // var multipartFile3 = http.MultipartFile(
      //     'user_signature', stream3, length3,
      //     filename: Path.basename(imgFile.path));
      //
      // listen for response
      request.files.add(multipartFile);
      request.files.add(multipartFile2);
     // request.files.add(multipartFile3);
      request.headers.addAll(headers);
      request.fields["celebrity_id"] = widget.cel!.id.toString();
      request.fields["date"] = dateTime.toString();
      request.fields["link"] =link.text.contains('https://') ||
          link.text.contains('http://')
          ? link.text
          : 'https://' + link.text;
      request.fields["celebrity_promo_code"] = copun.text;

      var response = await request.send();
      http.Response respo = await http.Response.fromStream(response);
      print(jsonDecode(respo.body)['message']['ar']);
      return jsonDecode(respo.body)['message']['ar'] +
          jsonDecode(respo.body)['success'].toString();
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }
}


