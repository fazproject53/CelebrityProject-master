
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../Account/LoggingSingUpAPI.dart';
import '../../MainScreen/main_screen_navigation.dart';
import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';
import '../../Users/CreateOrder/buildAdvOrder.dart';
import 'celebratyProfile.dart';

class socialMedia extends StatefulWidget {
 static String? face, insta,snap,linked, you,twit, tik;
 static int? faceid, instaid,snapid,linkedid, youid,twitid, tikid;
 static String? facenum, instanum,snapnum,linkednum, younum,twitnum, tiknum;
  socialMedia({Key? key}) : super(key: key);
  _socialMediaState createState() => _socialMediaState();
}

class _socialMediaState extends State<socialMedia>{

  final TextEditingController snapchat = TextEditingController();
  final TextEditingController tiktok = TextEditingController();
  final TextEditingController youtube = TextEditingController();
  final TextEditingController instagram = TextEditingController();
  final TextEditingController facebook = TextEditingController();
  final TextEditingController twitter = TextEditingController();
  final TextEditingController linkedin = TextEditingController();

  bool sn = false, ti= false, yo= false, ins= false,tw= false,fac= false;

  String facebookChoose = 'عدد متابعين الفيسبوك';
  String instaChoose = 'عدد متابعين الانستجرام';
  String snapChoose = 'عدد متابعين السناب شات';
  String linkedChoose = 'عدد متابعين لينكد ان';
  String youtubeChoose = 'عدد متابعين اليوتيوب';
  String twitterChoose = 'عدد متابعين التويتر';
  String tiktokChoose = 'عدد متابعين التيك توك';
  String? userToken;

  String? thefacebook,  theinstagram, theyoutube, thetiktok, thetwitter, thesnapchat;
  var folowers = [];

  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  final _formKeyy = GlobalKey<FormState>();
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        fetchFolowers();
      });
    });

    socialMedia.face != null? facebook.text =  socialMedia.face!.replaceAll('https://www.facebook.com/', ''): null;
    socialMedia.insta != null? instagram.text =  socialMedia.insta!.replaceAll('https://www.instagram.com/', ''): null;
    socialMedia.snap != null? snapchat.text = socialMedia.snap!.replaceAll('https://www.snapchat.com/add/', ''): null;
    socialMedia.linked != null? linkedin.text =  socialMedia.linked!: null;
    socialMedia.you != null? youtube.text = socialMedia.you!.replaceAll('https://www.youtube.com/', ''): null;
    socialMedia.twit != null? twitter.text =  socialMedia.twit!.replaceAll('https://www.twitter.com/', ''): null;
    socialMedia.tik != null? tiktok.text = socialMedia.tik!.replaceAll('https://www.tiktok.com/', ''): null;

    thefacebook = facebook.text;
    theinstagram = instagram.text;
    theyoutube = youtube.text;
    thetiktok = tiktok.text;
    thetwitter = twitter.text;
    thesnapchat = snapchat.text;
    _dropdownTestItems = buildDropdownTestItems(folowers);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar('صفحات التواصل', context),
          body: SingleChildScrollView(
            child:    paddingg(
              15,
              15,
              12, Column(children: [
                SizedBox(
                  height: 30.h,
                ),
                padding(
                  10,
                  12,
                  Container(
                      alignment: Alignment.topRight,
                      child:  Text(
                        'فضلا ادخل البيانات الصحيحة',
                        style: TextStyle(
                            fontSize: textSubHeadSize,
                            color: textBlack,
                            fontFamily: 'Cairo'),
                      )),
                ),
                SizedBox(
                  height: 50.h,
                ),

              //   //------------------------------------------------- روابط الصفحات ---------------------------------------------------------
                Form(
                  key: _formKeyy,
                  child: Column(
                    children: [
                      textFeildWithButton(
                        context,
                        textFieldNoIcon2(
                            context,
                            'مثال: userName@ او userName',
                          textTitleSize-1,
                            false,
                            snapchat,
                                (String? value) {if (value == null || value.isEmpty) {
                            }else{
                              return value.length < 4? 'يجب ان يكون اسم المستخدم اكتر من 4 حروف':null;
                            }},
                                (value){setState(() {
                                  sn = true;

                                });},
                            labelText: 'اسم المستخدم لحساب السناب شات',
                            onTap: (){
                              if(socialMedia.snapnum == null){
                                setState(() {
                                  sn = true;
                                });
                              }
                            }
                          ,
                          inputf: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                          ],
                        ),
                        padding(
                          8,
                          8,
                          Container(
                            width: 50.h,
                            height: 40.h,
                            margin: EdgeInsets.only(top:socialMedia.snapnum != null? 10.h:0),
                            child: SvgPicture.asset('assets/Svg/icon- snapchat.svg',width: 30,
                              height: 40.h,),
                          ),
                        ),
                        child3: socialMedia.snapnum != null? Container(
                            height: 15.h,
                            alignment: Alignment.center,
                            child: text(context,'+'+ (socialMedia.snapnum!.length > 6?socialMedia.snapnum.toString().substring(0,socialMedia.snapnum!.length - 6):
                            (socialMedia.snapnum!.length > 3?socialMedia.snapnum!.toString().substring(0,socialMedia.snapnum!.length - 3): socialMedia.snapnum.toString() ))+
                                (socialMedia.snapnum!.length > 6?'M':socialMedia.snapnum!.length > 4?'k':''), 13, black)):null,
                      ),

                      Visibility(
                        visible: socialMedia.snapnum == null && snapchat.text.isNotEmpty && sn,
                        child:
                      paddingg(
                        15,
                        15,
                        socialMedia.snapnum == null && !sn?10.w : 0,
                        Container(
                          alignment: Alignment.topRight,
                          child: DropdownBelow(
                            dropdownColor: white,
                            itemWidth: 290.w,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding: EdgeInsets.fromLTRB(
                                13.w, 12.h, 13.w, 12.h),
                            boxWidth: 280.w,
                            boxHeight: 45.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius:
                                BorderRadius.circular(8.r)),

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              snapChoose,
                              textDirection: TextDirection.rtl,
                            ),
                            value: _selectedTest3,
                            items: _dropdownTestItems,
                            onChanged: onChangeDropdownTests3,
                          ),
                        ),
                      ),
                      ),
                      textFeildWithButton(
                        context,
                        textFieldNoIcon2(
                            context,
                            'مثال: userName@ او userName',
                          textTitleSize-1,
                            false,
                            tiktok,
                                (String? value) {if (value == null || value.isEmpty) {
                            }else{
                              return value.length < 4? 'يجب ان يكون اسم المستخدم اكتر من 4 حروف':null;
                            }},
                                (value){
                                  setState(() {
                                    ti = true;

                                  });
                                },
                            labelText: 'اسم المستخدم لحساب التيك توك',
                          onTap: (){
                              if( socialMedia.tiknum == null){
                                setState(() {
                                  ti = true;

                                });
                              }
                          }
                          ,
                          inputf: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                          ],
                        ),
                          padding(
                            8,
                            8,
                            Container(
                              width: 50.h,
                              height: 40.h,
                              margin: EdgeInsets.only(top: socialMedia.tiknum != null? 10.h:0),
                              child: SvgPicture.asset('assets/Svg/icon-tiktok.svg',width: 30,
                                height: 35.h,),
                            ),
                          ),
                        child3: socialMedia.tiknum != null?
                           Container(
                             height: 15.h,
                              alignment: Alignment.center,
                              child: text(context,'+'+ (socialMedia.tiknum!.length > 6?socialMedia.tiknum!.toString().substring(0,socialMedia.tiknum!.length - 6):
                              (socialMedia.tiknum!.length > 3?socialMedia.tiknum!.toString().substring(0,socialMedia.tiknum!.length - 3): socialMedia.tiknum!.toString() ))+
                                  (socialMedia.tiknum!.length > 6?'M':socialMedia.tiknum!.length > 4?'k':''), 13, black))
                        :null,
                      ),

                      Visibility(
                        visible:  socialMedia.tiknum == null && tiktok.text.isNotEmpty && ti,
                        child:
                        Container(
                          alignment: Alignment.topRight,
                          child: paddingg(
                            15,
                            15,
                            socialMedia.tiknum == null && !ti?  12.h :0,
                            DropdownBelow(
                              dropdownColor: white,
                              itemWidth: 290.w,

                              ///text style inside the menu
                              itemTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo',
                              ),

                              ///hint style
                              boxTextstyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: black,
                                  fontFamily: 'Cairo'),

                              ///box style
                              boxPadding: EdgeInsets.fromLTRB(
                                  13.w, 12.h, 13.w, 12.h),
                              boxWidth: 280.w,
                              boxHeight: 45.h,
                              boxDecoration: BoxDecoration(
                                  border:  Border.all(color: newGrey, width: 0.5),
                                  color: lightGrey.withOpacity(0.10),
                                  borderRadius:
                                  BorderRadius.circular(8.r)),

                              ///Icons
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              hint: Text(
                                tiktokChoose,
                                textDirection: TextDirection.rtl,
                              ),
                              value: _selectedTest7,
                              items: _dropdownTestItems,
                              onChanged: onChangeDropdownTests7,
                            ),
                          ),
                        ),
                      ),
                      textFeildWithButton(
                        context,
                        textFieldNoIcon2(
                            context,
                            'مثال: userName@ او userName',
                          textTitleSize-1,
                            false,
                            youtube,
                                (String? value) {if (value == null || value.isEmpty) {
                            }else{
                              return value.length < 4? 'يجب ان يكون اسم المستخدم اكتر من 4 حروف':null;
                            }},
                                (value){setState(() {
                                  yo = true;

                                });},
                            labelText: 'اسم المستخدم لحساب اليوتيوب',
                            onTap: (){
                              if( socialMedia.younum == null){
                                setState(() {
                                  yo = true;

                                });
                              }
                            }
                          ,
                          inputf: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                          ],
                        ),
                        padding(
                          8,
                          8,
                          Container(
                            width: 50.h,
                            height: 40.h,
                            margin: EdgeInsets.only(top: socialMedia.younum != null? 10.h : 0),
                            child: SvgPicture.asset('assets/Svg/icon-21-youtube.svg',width: 30,
                              height: 50,),
                          ),
                        ),
                         child3: socialMedia.younum != null? Container(
                             height: 15.h,
                             alignment: Alignment.center,
                             child: text(context, '+'+ (socialMedia.younum!.length > 6?socialMedia.younum!.toString().substring(0,socialMedia.younum!.length - 6): (socialMedia.younum!.length > 3?socialMedia.younum!.toString().substring(0,socialMedia.younum!.length - 3): socialMedia.younum!.toString() ))+ (socialMedia.younum!.length > 6?'M':socialMedia.younum!.length > 4?'k':''), 13, black)):null,
                        //socialMedia.younum!.length!.isOdd? '+'+socialMedia.younum!.toString().substring(0,1)+ (socialMedia.younum!.length! > 6?'M':'k'):
                      ),

                      Visibility(
                        visible: yo && socialMedia.younum == null && youtube.text.isNotEmpty,
                        child:
                      paddingg(
                        15,
                        15,
                        socialMedia.younum == null && !yo?  12.h :0,
                        Container(
                          alignment: Alignment.topRight,
                          child: DropdownBelow(
                            dropdownColor: white,
                            itemWidth: 290.w,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding: EdgeInsets.fromLTRB(
                                13.w, 12.h, 13.w, 12.h),
                            boxWidth: 280.w,
                            boxHeight: 45.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius:
                                BorderRadius.circular(8.r)),

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              youtubeChoose,
                              textDirection: TextDirection.rtl,
                            ),
                            value: _selectedTest5,
                            items: _dropdownTestItems,
                            onChanged: onChangeDropdownTests5,
                          ),
                        ),
                      ),
                      ),
                      textFeildWithButton(
                        context,
                        textFieldNoIcon2(
                            context,
                            'مثال: userName@ او userName',
                          textTitleSize-1,
                            false,
                            instagram,
                                (String? value) {if (value == null || value.isEmpty) {
                            }else{
                              return value.length < 4? 'يجب ان يكون اسم المستخدم اكتر من 4 حروف':null;
                            }},
                                (value){setState(() {
                                  ins = true;

                                });},
                            labelText: 'اسم المستخدم لحساب الانستجرام',
                            onTap: (){
                              if(socialMedia.instanum == null){
                                setState(() {
                                  ins = true;
                                });
                              }
                            }
                          ,
                          inputf: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                          ],
                        ),
                        padding(
                          8,
                          8,
                          Container(
                            width: 50.w,
                            height: 40.h,
                            margin: EdgeInsets.only(top: socialMedia.instanum != null? 10.h: 0),
                            child: SvgPicture.asset('assets/Svg/icon- insta.svg',width: 30,
                              height: 40.h,),
                          ),
                          
                        ),
                        child3: socialMedia.instanum != null? Container(
                              height: 15.h,
                              alignment: Alignment.center,
                              child: text(context,'+'+ (socialMedia.instanum!.length > 6?socialMedia.instanum!.toString().substring(0,socialMedia.instanum!.length - 6):
                              (socialMedia.instanum!.length > 3?socialMedia.instanum!.toString().substring(0,socialMedia.instanum!.length - 3): socialMedia.instanum!.toString() ))+
                                  (socialMedia.instanum!.length > 6?'M':socialMedia.instanum!.length > 4?'k':''), 13, black)):null,
                      ),

                      Visibility(
                        visible: ins && socialMedia.instanum == null && instagram.text.isNotEmpty ,
                        child:
                        paddingg(
                          15,
                          15,
                          socialMedia.instanum == null && !ins?  12.h :0,
                          Container(
                            alignment: Alignment.topRight,
                            child: DropdownBelow(
                              dropdownColor: white,
                              itemWidth: 290.w,

                              ///text style inside the menu
                              itemTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo',
                              ),

                              ///hint style
                              boxTextstyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: black,
                                  fontFamily: 'Cairo'),

                              ///box style
                              boxPadding: EdgeInsets.fromLTRB(
                                  13.w, 12.h, 13.w, 12.h),
                              boxWidth: 280.w,
                              boxHeight: 45.h,
                              boxDecoration: BoxDecoration(
                                  border:  Border.all(color: newGrey, width: 0.5),
                                  color: lightGrey.withOpacity(0.10),
                                  borderRadius:
                                  BorderRadius.circular(8.r)),

                              ///Icons
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              hint: Text(
                                instaChoose,
                                textDirection: TextDirection.rtl,
                              ),
                              value: _selectedTest2,
                              items: _dropdownTestItems,
                              onChanged: onChangeDropdownTests2,
                            ),
                          ),
                        ),
                      ),
                      textFeildWithButton(
                        context,
                        textFieldNoIcon2(
                            context,
                            'مثال: userName@ او userName',
                          textTitleSize-1,
                            false,
                            twitter,
                                (String? value) {if (value == null || value.isEmpty) {
                            }else{
                              return value.length < 4? 'يجب ان يكون اسم المستخدم اكتر من 4 حروف':null;
                            }},
                                (value){setState(() {
                                  tw = true;

                                });},
                            labelText: 'اسم المستخدم لحساب التويتر',
                            onTap: (){
                              if( socialMedia.twitnum == null){
                                setState(() {
                                  tw = true;

                                });
                              }
                            },
                          inputf: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                          ],
                        ),
                        padding(
                          8,
                          8,
                          Container(
                            width: 50.h,
                            height: 40.h,
                            margin: EdgeInsets.only(top: socialMedia.twitnum != null?10.h:0),
                            child: SvgPicture.asset('assets/Svg/icon- twitter.svg',width: 30,
                              height: 50,),
                          ),
                        ),
                        child3: socialMedia.twitnum != null? Container(
                            height: 15.h,
                            margin: EdgeInsets.only(left: 0.w),
                            alignment: Alignment.center,
                            child: text(context,'+'+ (socialMedia.twitnum!.length > 6?socialMedia.twitnum!.toString().substring(0,socialMedia.twitnum!.length - 6):
                            (socialMedia.twitnum!.length > 3?socialMedia.twitnum!.toString().substring(0,socialMedia.twitnum!.length - 3): socialMedia.twitnum!.toString() ))+
                                (socialMedia.twitnum!.length > 6?'M':socialMedia.twitnum!.length > 4?'k':''), 13, black)):null,
                      ),


                      Visibility(
                        visible: tw && socialMedia.twitnum == null && twitter.text.isNotEmpty,
                        child:
                        paddingg(
                          15,
                          15,
                          socialMedia.twitnum == null && !tw?  12.h :0,
                          Container(
                            alignment: Alignment.topRight,
                            child: DropdownBelow(
                              dropdownColor: white,
                              itemWidth: 290.w,

                              ///text style inside the menu
                              itemTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo',
                              ),

                              ///hint style
                              boxTextstyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: black,
                                  fontFamily: 'Cairo'),

                              ///box style
                              boxPadding: EdgeInsets.fromLTRB(
                                  13.w, 12.h, 13.w, 12.h),
                              boxWidth: 280.w,
                              boxHeight: 45.h,
                              boxDecoration: BoxDecoration(
                                  border:  Border.all(color: newGrey, width: 0.5),
                                  color: lightGrey.withOpacity(0.10),
                                  borderRadius:
                                  BorderRadius.circular(8.r)),

                              ///Icons
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              hint: Text(
                                twitterChoose,
                                textDirection: TextDirection.rtl,
                              ),
                              value: _selectedTest6,
                              items: _dropdownTestItems,
                              onChanged: onChangeDropdownTests6,
                            ),
                          ),
                        ),
                      ),
                      textFeildWithButton(
                        context,
                        textFieldNoIcon2(
                            context,
                            'مثال: userName@ او userName',
                          textTitleSize-1,
                            false,
                            facebook,
                                (String? value) {if (value == null || value.isEmpty) {
                            }else{
                              return value.length < 4? 'يجب ان يكون اسم المستخدم اكتر من 4 حروف':null;
                            }},
                                (value){setState(() {
                                  fac = true;
                                });},
                            labelText: 'اسم المستخدم لحساب الفيسبوك',
                            onTap: (){
                              if(socialMedia.facenum== null){
                                setState(() {
                                  fac = true;

                                });
                              }
                            },
                          inputf: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                          ],
                        ),
                        padding(
                          8,
                          8,
                          Container(
                            width: 50.w,
                            height: 40.h,
                            margin: EdgeInsets.only(top:  socialMedia.facenum != null?10.h:0),
                            child: SvgPicture.asset('assets/Svg/icon- faceboock.svg',width: 30,
                              height: 50,),
                          ),
                        ),
                          child3: socialMedia.facenum != null? Container(
                              height: 15.h,
                              alignment: Alignment.center,
                              child: text(context,'+'+ (socialMedia.facenum!.length > 6?socialMedia.facenum!.toString().substring(0,socialMedia.facenum!.length - 6):
                              (socialMedia.facenum!.length > 3?socialMedia.facenum!.toString().substring(0,socialMedia.facenum!.length - 3): socialMedia.facenum!.toString() ))+
                                  (socialMedia.facenum!.length > 6?'M':socialMedia.facenum!.length > 4?'k':''), 13, black)):null,
                      ),

                      Visibility(
                        visible: fac && socialMedia.facenum == null && facebook.text.isNotEmpty,
                        child:

                                      _dropdownTestItems.isEmpty?SizedBox():paddingg(
                                      15,
                                      15,
                                        socialMedia.facenum == null && !fac?  12.h :0,
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: DropdownBelow(
                                          dropdownColor: white,
                                          itemWidth: 290.w,

                                          ///text style inside the menu
                                          itemTextstyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: black,
                                            fontFamily: 'Cairo',
                                          ),

                                          ///hint style
                                          boxTextstyle: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: black,
                                              fontFamily: 'Cairo'),

                                          ///box style
                                          boxPadding: EdgeInsets.fromLTRB(
                                              13.w, 12.h, 13.w, 12.h),
                                          boxWidth: 280.w,
                                          boxHeight: 45.h,
                                          boxDecoration: BoxDecoration(
                                              border:  Border.all(color: newGrey, width: 0.5),
                                              color: lightGrey.withOpacity(0.10),
                                              borderRadius:
                                              BorderRadius.circular(8.r)),

                                          ///Icons
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey,
                                          ),
                                          hint: Text(
                                            facebookChoose,
                                            textDirection: TextDirection.rtl,
                                          ),
                                          value: _selectedTest,
                                          items: _dropdownTestItems,
                                          onChanged: onChangeDropdownTests,
                                        ),
                                      ),
                                    ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),

                padding(
                    15,
                    15,
                    gradientContainerNoborder(
                        getSize(context).width,
                        buttoms(context, 'حفظ', largeButtonSize, white, () {
                            setState(() {
                              _formKeyy.currentState!.validate()?{

                                  loadingDialogue(context),
                                  updateSocialMedia().then((value) => {
                                    Navigator.pop(context),
                                    value.contains('true')?{
                                      Navigator.pop(context),(() {
                                        fetchFolowers();
                                      }),
                                      showMassage(
                                          context, 'تم ', value.replaceAll('true', ''),
                                          done: done)
                                    }:{
                                      value == 'SocketException'?{
                                        Navigator.pop(context),
                                        showMassage(context,'فشل الاتصال بالانترنت', socketException)
                                      }: {

                                        value == 'serverException'? {
                                          Navigator.pop(context),
                                          showMassage(
                                            context, 'خطا', serverException,)

                                        }:{
                                          Navigator.pop(context),
                                          if(value.contains('The selected city id is invalid.')){
                                            showMassage(
                                              context, 'خطا', 'الرجاء اختيار المدينة ',)
                                          }else
                                            {
                                              showMassage(
                                                context,
                                                'خطا',
                                                'حدث خطأ ما الرجاء المحاولة لاحقا',
                                              )
                                            }
                                        }


                                      }
                                    }
                                  }),

                            }:null;});

                        }))),
              SizedBox(
                height: 40.h,
              ),
              ],),
            ),
          ),
        ));}

  var _selectedTest;
  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      facebookChoose = selectedTest['keyword'];
      _selectedTest = selectedTest;
    });
  }

  var _selectedTest2;
  onChangeDropdownTests2(selectedTest) {
    print(selectedTest);
    setState(() {
      instaChoose = selectedTest['keyword'];
      _selectedTest2 = selectedTest;
    });
  }

  var _selectedTest3;
  onChangeDropdownTests3(selectedTest) {
    print(selectedTest);
    setState(() {
    _selectedTest3 = selectedTest;
    snapChoose = selectedTest['keyword'];
    });
  }

  var _selectedTest4;
  onChangeDropdownTests4(selectedTest) {
    print(selectedTest);

    setState(() {
      linkedChoose = selectedTest['keyword'];
      _selectedTest4 = selectedTest;
    });
  }

  var _selectedTest5;
  onChangeDropdownTests5(selectedTest) {
    print(selectedTest);
    setState(() {
      youtubeChoose = selectedTest['keyword'];
      _selectedTest5 = selectedTest;
    });
  }


  var _selectedTest6;
  onChangeDropdownTests6(selectedTest) {
    print(selectedTest);

    setState(() {
      twitterChoose = selectedTest['keyword'];
      _selectedTest6 = selectedTest;
    });
  }

  var _selectedTest7;
  onChangeDropdownTests7(selectedTest) {
    print(selectedTest);
    setState(() {
      tiktokChoose = selectedTest['keyword'];
      _selectedTest7 = selectedTest;
    });
  }
  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          alignment: Alignment.centerRight,
          value: i,
          child: Directionality(
              textDirection: TextDirection.rtl,child: Container( alignment: Alignment.centerRight,child:
          text(context, i['keyword'],14,black, direction: TextDirection.rtl,))),

        ),
      );
    }
    return items;
  }
  Future<Budget> fetchFolowers() async {

      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/follower-number'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        _dropdownTestItems.isEmpty
            ? {
          setState(() {
            folowers
                .add({'no': 0, 'keyword': 'عدد المتابعين'});
            for (int i = 0; i < jsonDecode(response.body)['data'].length;
            i++)
            {
            folowers.add({
            'no': i+1,
            'keyword':
            jsonDecode(response.body)['data'][i]['from_to'].toString()
            });
            };
            _dropdownTestItems = buildDropdownTestItems(folowers);
          }),

        }
            : null;
        return Budget.fromJson(jsonDecode(response.body));

      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }



  }

  Future<String> updateSocialMedia() async {
    print(thefacebook!.isNotEmpty.toString() +'===================================================');
    try{
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/social-links/update',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
        body: jsonEncode(<String, dynamic>{
         'snapchat': snapchat.text.replaceAll('@', '').isNotEmpty?'https://www.snapchat.com/add/'+snapchat.text.replaceAll('@', ''): null,
          'tiktok': tiktok.text.replaceAll('@', '').isNotEmpty? 'https://www.tiktok.com/' +tiktok.text.replaceAll('@', ''): null,
          'youtube': youtube.text.replaceAll('@', '').isNotEmpty?'https://www.youtube.com/'+youtube.text.replaceAll('@', ''):null,
          'instagram':instagram.text.replaceAll('@', '').isNotEmpty?'https://www.instagram.com/'+instagram.text.replaceAll('@', ''):null,
          'twitter': twitter.text.replaceAll('@', '').isNotEmpty?'https://www.twitter.com/'+twitter.text.replaceAll('@', ''): null,
          'facebook': facebook.text.replaceAll('@', '').isNotEmpty?'https://www.facebook.com/'+facebook.text.replaceAll('@', ''):null,
          'facebook_number':socialMedia.faceid != null ? 0: (_selectedTest == null || _selectedTest['no'] == 0)? 0:_selectedTest['no'] ,
          'snapchat_number':socialMedia.snapid != null ? 0: (_selectedTest3 == null || _selectedTest3['no'] == 0)?0:_selectedTest3['no'] ,
          'youtube_number':socialMedia.youid != null ? 0: (_selectedTest5 == null || _selectedTest5['no'] == 0)?0: _selectedTest5['no'],
          'tiktok_number':socialMedia.tikid != null ?0: (_selectedTest7 == null || _selectedTest7['no'] == 0)? 0 :_selectedTest7['no'] ,
          'twitter_number':socialMedia.twitid != null? 0: (_selectedTest6 == null || _selectedTest6['no'] ==0)?0:_selectedTest6['no'] ,
          'instagram_number':socialMedia.instaid != null ?0: (_selectedTest2 == null || _selectedTest2['no'] == 0)?0: _selectedTest2['no'],
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        return jsonDecode(response.body)['message']['ar'].toString() +jsonDecode(response.body)['success'].toString();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
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