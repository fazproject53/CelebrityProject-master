import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Celebrity/Activity/studio/studio.dart';
import 'package:celepraty/Celebrity/Contracts/contract.dart';
import 'package:celepraty/Celebrity/chat/chatsList.dart';
import 'package:celepraty/Celebrity/setting/socialMedia.dart';
import 'package:celepraty/Users/Setting/userProfile.dart';
import 'package:celepraty/celebrity/setting/profileInformation.dart' as info;
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:celepraty/Celebrity/Activity/activity_screen.dart';
import 'package:celepraty/Celebrity/Balance/balance.dart';
import 'package:celepraty/Celebrity/Calendar/calendar_main.dart';
import 'package:celepraty/Celebrity/Pricing/pricing.dart';
import 'package:celepraty/Celebrity/setting/profileInformation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Setting/user_balance.dart';
import 'package:celepraty/celebrity/Brand/create_your_brand.dart';
import 'package:celepraty/celebrity/DiscountCodes/discount_codes_main.dart';
import 'package:celepraty/celebrity/PrivacyPolicy/privacy_policy.dart';
import 'package:celepraty/celebrity/Requests/ReguistMainPage.dart';
import 'package:celepraty/celebrity/TechincalSupport/contact_with_us.dart';
import 'package:celepraty/celebrity/blockList.dart';
import 'package:path/path.dart' as Path;
import 'package:celepraty/invoice/invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:celepraty/Celebrity/Activity/studio/studio.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Account/TheUser.dart';
import '../Activity/studio/studio.dart'as st;
import '../Activity/news/news.dart'as nn;
import '../Pricing/ModelPricing.dart';
import '../verifyAccount/verify.dart';
import 'MediaAccounts.dart';
bool infoDone = true, verifiedDone = true, priceDone = true, activitiesDone = true, privacyDone = true;
CelebrityInformation? thecelerbrity = CelebrityInformation();
int? cityIdfromcel;
String? catt, descc;

class celebratyProfile extends StatefulWidget {
  _celebratyProfileState createState() => _celebratyProfileState();
}

class _celebratyProfileState extends State<celebratyProfile> with AutomaticKeepAliveClientMixin{
  String userToken = '';
  Future<CelebrityInformation>? celebrity;
  Future<Media>? mediaAccounts;
  Future<Pricing>? pricing;
  bool infoDone = true, verifiedDone = true, priceDone = true, activitiesDone = true, privacyDone = true;
  bool down = false;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool ActiveConnection = false;
  String T = "";
  File? imagefile;
  String? imageurl;
  final labels = [
    'المعلومات الشخصية',
    'توثيق الحساب',
    'العقود',
    'صفحات التواصل',
    'الفوترة',
    'الرصيد',
    'التسعير',
    'الطلبات',
    'علامتك التجارية',
    'اكواد الخصم',
    'جدول المواعيد',
    'التفاعلات',
    'الشروط والاحكام',
    'قائمة الحظر',
    'طلب مساعدة',
    'تسجيل الخروج'
  ];
  final List<IconData> icons = [
    nameIcon,
    verifyIcon,
    Icons.receipt_long,
    share,
    invoice,
    money,
    price,
    orders,
    store,
    copun,
    scheduale,
    studio,
    pagesIcon,
    block,
    support,
    logout
  ];
  final List<Widget> page = [
    profileInformaion(),
    verify(),
    contract(),
    socialMedia(),
    invoiceScreen(),
    BalanceMain(),
    PricingMain(),
    RequestMainPage(),
    YourBrandHome(),
    DiscountCodes(),
    CelebrityCalenderMain(),
    ActivityScreen(),
    PrivacyPolicyMain(),
    blockList(),
    ContactWithUsHome(),
    Logging()
  ];
  @override
  void initState() {
    super.initState();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        celebrity = fetchCelebrities(userToken);
        mediaAccounts = getAccounts();
        pricing = fetchCelebrityPricing(userToken);
        fetchStudio();
        fetchNews(userToken);
      });
    });
  }
  @override
  void dispose() {
   // setState(() {
      socialMedia.face= null; socialMedia.insta= null;socialMedia.snap= null;socialMedia.linked= null;socialMedia.you= null;socialMedia.twit= null; socialMedia.tik = null;
      socialMedia.faceid= null; socialMedia.instaid= null;socialMedia.snapid= null;socialMedia.linkedid= null;socialMedia.youid= null;socialMedia.twitid= null;socialMedia.tikid= null;
      socialMedia.facenum= null; socialMedia.instanum= null;socialMedia.snapnum= null;socialMedia.linkednum= null;socialMedia.younum= null;socialMedia.twitnum= null; socialMedia.tiknum= null;
  //  });

    super.dispose();
  }
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (mounted) {
          setState(() {
            ActiveConnection = true;
            T = "Turn off the data and repress again";
          });
        }
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  Future<CelebrityInformation> fetchCelebrities(String tokenn) async {
    try{
    String token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNmNiMTQxN2NlMWY1NmQ5NDYwYWZlNmFiODkxN2YxZjUzNmU5NDFkYTFhZjkzZThkZTRhODg0MDhjY2NmODU5MTk1N2FlZDIyZmNiOTNlYWYiLCJpYXQiOjE2NTQ0MjY5NzguODI0OTc0MDYwMDU4NTkzNzUsIm5iZiI6MTY1NDQyNjk3OC44MjQ5NzgxMTMxNzQ0Mzg0NzY1NjI1LCJleHAiOjE2ODU5NjI5NzguODE2NTA0MDAxNjE3NDMxNjQwNjI1LCJzdWIiOiI3NyIsInNjb3BlcyI6W119.gi37nJk06pb4_27W45l8oItE3JkLa_gxyzUmYxJDQjFTMCHBllDU3GKXpJNWq_qEXTDUQB66QeP0mFCSmZZYdOczNSqu-0RfqQyzpOTUCp2uyXZGPehl7IhQ9T9cceKBzoz71kcHinYJLv-O0666XrEQMS7w6aRhi69TPRqew2RehPHgMmZuiXcF9uET2WYOGGZl3OIzDRrIP2PSt0GvgSWsWDLlOEgOwgJqBHeuBa7tVyoK2K1ZVQdJPRT0T2PPO9jc5w9nG82aXYUPqku-GqzYeGijdXukIjkStJJvBAiSvYeD1lQNXpLdy6dScN_SUyOEMgbwWnS8rDoD97QY59MY7GG3KYhOdTMpAzfO4h8tEoUT20olshRSPkfZZCAPAvVm158cA6_GEDRlCrHSBMfuDK7Em3xiUtOjbZaEtKuBfLLCws8IYLiJxXkEYCmOUNAmHP0Ml-xJN_jkv8ZYqy2CzAmHodvSGkw2z9XBSqMUi7MVKibH0yr486OmCEPmSwtT84qDE03XgwYaX4qCXB5RAhy3YoV_35hOgeoA51ONFdYawejMeQQa-CjiDLfLLdYzDS-cXRbz-wTFaem0qDOtL0VOi_Tn0Dhlx8oNuxVdbMA-E42vbSm76G9nL4WCd67JA9fE-K37e8DOrNVg2FNRsVACW';
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenn'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      Logging.theUser = new TheUser();

      descc =jsonDecode(response.body)["data"]?["celebrity"]['description'];
      catt= jsonDecode(response.body)["data"]?["celebrity"]['category']['name'];
      Logging.theUser!.name =
          jsonDecode(response.body)["data"]?["celebrity"]['name'] == null
              ? ''
              : jsonDecode(response.body)["data"]?["celebrity"]['name'];
      Logging.theUser!.email =
          jsonDecode(response.body)["data"]?["celebrity"]['email'];
      Logging.theUser!.id =
          jsonDecode(response.body)["data"]?["celebrity"]['id'].toString();
      Logging.theUser!.phone = jsonDecode(response.body)["data"]?["celebrity"]
              ['phonenumber']
          .toString();
      Logging.theUser!.image =
          jsonDecode(response.body)["data"]?["celebrity"]['image'];
      Logging.theUser!.country =
          jsonDecode(response.body)["data"]?["celebrity"]['country']['name'];

      setState(() {
        isConnectSection = true;
        timeoutException = true;
        serverExceptions = true;
        ActiveConnection = false;
        down = false;
      });
      return CelebrityInformation.fromJson(jsonDecode(response.body));
    } else {
     // print(userToken);
      return Future.error('fetchCelebrities error ${response.statusCode}');
    }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
          down = true;
        });
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
        setState(() {
          timeoutException = false;
          down = true;
        });
        return Future.error('TimeoutException');
      } else {
        setState(() {
          serverExceptions = false;
          down = true;
        });
        return Future.error('serverExceptions');
      }
    }
  }

  Future<Media> getAccounts() async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/social-media'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        return Media.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Future.error('getAccounts error ${response.statusCode}');
      }
    } catch (e) {
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
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarNoIcon("حسابي"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<CelebrityInformation>(
                future: celebrity,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:  mainLoad(context)
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                     // return Center(child: Text(snapshot.error.toString()));
                      if (snapshot.error.toString() ==
                          'SocketException') {
                        //
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4.h),
                              child: Center(
                                child: SizedBox(
                                    height: 300.h,
                                    width: 250.w,
                                    child: internetConnection(context, reload: () {
                                      setState(() {
                                        celebrity = fetchCelebrities(userToken);
                                        mediaAccounts = getAccounts();
                                        pricing = fetchCelebrityPricing(userToken);
                                        fetchStudio();
                                        fetchNews(userToken);
                                      });
                                    })),
                              ),
                            ),
                          ],
                        );
                      } else {
                        if (!serverExceptions) {
                          return SizedBox(
                            height: getSize(context).height/1.5,
                            child: Center(
                                child: checkServerException(context,reload: (){setState(() {
                                  celebrity = fetchCelebrities(userToken);
                                });})
                            ),
                          );}else{
                          if (!timeoutException) {
                            return Center(
                              child: checkTimeOutException(context, reload: (){ setState(() {
                                celebrity = fetchCelebrities(userToken);});}),
                            );}
                        }
                        return  SizedBox(
                          height: getSize(context).height/1.5,
                          child: Center(
                              child: checkServerException(context)
                          ),
                        );
                      }
                      //---------------------------------------------------------------------------
                    } else if (snapshot.hasData) {
                      cityIdfromcel = snapshot.data!.data!.celebrity!.area == null
                          ? null
                          : snapshot.data!.data!.celebrity!.area!.id;
                      socialMedia.tik = snapshot
                          .data!.data!.celebrity!.tiktok!
                          .toString().replaceAll('https://www.tiktok.com/', '');
                  socialMedia.snap = snapshot
                      .data!.data!.celebrity!.snapchat!
                      .toString().replaceAll('https://www.snapchat.com/add/', '');
                  socialMedia.you = snapshot
                      .data!.data!.celebrity!.youtube!
                      .toString().replaceAll('https://youtube.com/', '');
                  socialMedia.insta = snapshot
                      .data!.data!.celebrity!.instagram!
                      .toString().replaceAll('https://www.instagram.com/', '');
                  socialMedia.face = snapshot
                      .data!.data!.celebrity!.facebook!
                      .toString().replaceAll('https://www.facebook.com/', '');
                  socialMedia.twit = snapshot
                      .data!.data!.celebrity!.twitter!
                      .toString().replaceAll('https://twitter.com/', '');

                  //----------------------------------------
                      snapshot
                          .data!.data!.celebrity!.tiktoknum == null? null:{socialMedia.tiknum = snapshot
                      .data!.data!.celebrity!.tiktoknum!.from
                      .toString(),
                        socialMedia.tikid = snapshot
                            .data!.data!.celebrity!.tiktoknum!.id };
                      snapshot
                          .data!.data!.celebrity!.facebooknum == null? null:{socialMedia.facenum = snapshot
                          .data!.data!.celebrity!.facebooknum!.from
                          .toString(),
                        socialMedia.faceid = snapshot
                            .data!.data!.celebrity!.facebooknum!.id
                      } ;
                      snapshot
                          .data!.data!.celebrity!.snapchatnum == null? null:{socialMedia.snapnum = snapshot
                          .data!.data!.celebrity!.snapchatnum!.from
                          .toString(),
                        socialMedia.snapid = snapshot
                            .data!.data!.celebrity!.snapchatnum!.id
                      } ;
                      snapshot
                          .data!.data!.celebrity!.twitternum == null? null:{socialMedia.twitnum = snapshot
                          .data!.data!.celebrity!.twitternum!.from
                          .toString(),
                        socialMedia.twitid = snapshot
                            .data!.data!.celebrity!.twitternum!.id
                      };
                      snapshot
                          .data!.data!.celebrity!.instagramnum == null? null:{socialMedia.instanum = snapshot
                          .data!.data!.celebrity!.instagramnum!.from
                          .toString() ,
                        socialMedia.instaid = snapshot
                            .data!.data!.celebrity!.instagramnum!.id
                      };
                      snapshot
                          .data!.data!.celebrity!.youtubenum == null? null:{socialMedia.younum = snapshot
                          .data!.data!.celebrity!.youtubenum!.from
                          .toString(),
                        socialMedia.youid = snapshot
                            .data!.data!.celebrity!.youtubenum!.id
                      };

                      snapshot.data!.data!.celebrity!.adSpacePolicy =='' || snapshot.data!.data!.celebrity!.advertisingPolicy == '' ||
                          snapshot.data!.data!.celebrity!.giftingPolicy ==''? privacyDone = false: null;
                      snapshot.data!.data!.celebrity!.verified == null? verifiedDone = false:null;

                      snapshot.data!.data!.celebrity!.name == null || snapshot.data!.data!.celebrity!.area == null || snapshot.data!.data!.celebrity!.city == null
                          || snapshot.data!.data!.celebrity!.nationality == null || snapshot.data!.data!.celebrity!.phonenumber == null
                          || snapshot.data!.data!.celebrity!.gender == null || snapshot.data!.data!.celebrity!.category == null? infoDone = false: null;
                      return Column(children: [
                        //======================== profile header ===============================

                        Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            InkWell(
                              child: padding(
                                8,
                                8,
                                CircleAvatar(
                                  backgroundColor: lightGrey.withOpacity(0.10),
                                  child:  snapshot.data!.data!.celebrity!
                      .image != null?  Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(70.r),
                                        child: imagefile != null
                                            ? Image.file(
                                                imagefile!,
                                                fit: BoxFit.fill,
                                                height: double.infinity,
                                                width: double.infinity,
                                              )
                                            : snapshot.data!.data!.celebrity!
                                                        .image ==
                                                    null
                                                ? Container(
                                                    color:
                                                        lightGrey.withOpacity(0.30),
                                                  )
                                                :   !isConnectSection?  CircleAvatar(
                  backgroundColor: lightGrey.withOpacity(0.30),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Icon(Icons.error, size: 30.h, color: red,),
                  ),
                  radius: 55.r,
                  ): CachedNetworkImage(imageUrl: snapshot.data!.data!.celebrity!
                                                        .image!,
                                                    fit: BoxFit.cover,
                                                    height: double.infinity,
                                                    width: double.infinity,
                                          placeholder: (context,
                                                        loadingProgress) {
                                                      return Container(color: lightGrey.withOpacity(0.10),);
                                                    },
                                          errorWidget: (context, exception, stackTrace) {
                                            return Icon(Icons.error, size: 30.h, color: red,);},
                                                  ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(top:55.h, right: 70.w),
                                        child: Icon(Icons.add_circle, color: pink, size: 40.r),
                                      )
                                    ],
                                  ):Container(
                                    color:
                                    lightGrey.withOpacity(0.30),
                                  ),
                                  radius: 55.r,
                                ),
                              ),
                              onTap: () {
                                getImage().whenComplete(() => {
                                      if (imagefile != null)
                                        {
                                          updateImage(),
                                          showMassage(context, 'تم بنجاح',
                                              "تم تغيير الصورة بنجاح",
                                              done: done)
                                        }
                                    });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            padding(
                              8,
                              8,
                              text(
                                  context,
                                  snapshot.data!.data!.celebrity!.name!,
                                  textHeadSize,
                                  black,
                                  fontWeight: FontWeight.bold,
                                  family: 'Cairo'),
                            ),
                            padding(
                              8,
                              8,
                              text(
                                  context,
                                  'التصنيف : ' +
                                      snapshot.data!.data!.celebrity!.category!
                                          .name!,
                                  textTitleSize,
                                  textBlack,
                                  family: 'Cairo'),
                            ),
                            snapshot.data!.data!.celebrity!.description == ''?
                            SizedBox():
                            paddingg(
                              20,
                              20,
                              3,
                              text(
                                  context,
                                  snapshot.data!.data!.celebrity!.description!,
                                  textTitleSize,
                                  textBlack,
                                  family: 'Cairo',
                                  align: TextAlign.center),
                            ),
                          ],
                        ), //profile image

                        //=========================== buttons listView =============================

                        SingleChildScrollView(
                          child: Container(
                            child: paddingg(
                              8,
                              0,
                              30,
                              ListView.separated(
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return MaterialButton(
                                      onPressed: index == labels.length - 1
                                          ? () {
                                              singOut(context, userToken);
                                            }
                                          : () {
                                              goToPagePushRefresh(
                                                  context, page[index],
                                                  then: (value) {
                                                    print(changed2.toString()+"::::::::::::::::::::");
                                                changed2 || index == 11?setState(() {
                                                  celebrity = fetchCelebrities(userToken);
                                                  mediaAccounts = getAccounts();
                                                  pricing = fetchCelebrityPricing(userToken);
                                                  fetchStudio();
                                                  fetchNews(userToken);
                                                  changed2= false;
                                                }):null;
                                              });
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           page[index]),
                                              // ).then((value) => null);
                                            },
                                      child: index == 11?addListViewButton(
                                        labels[index],
                                        icons[index],
                                        index,
                                        done: privacyDone
                                      ):
                                      index == 1?addListViewButton(
                                          labels[index],
                                          icons[index],
                                          index,
                                          done: verifiedDone
                                      ) :index == 0?addListViewButton(
                                          labels[index],
                                          icons[index],
                                          index,
                                          done: infoDone
                                      ):index == 11?addListViewButton(
                                          labels[index],
                                          icons[index],
                                          index,
                                          done: activitiesDone
                                      ):index == 6?addListViewButton(
                                          labels[index],
                                          icons[index],
                                          index,
                                          done: priceDone
                                      ):
                                      addListViewButton(
                                          labels[index],
                                          icons[index],
                                          index,
                                      )
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: labels.length,
                              ),
                            ),
                          ),
                        ),

                        //========================== social media icons row =======================================

                      ]);
                    } else {
                      return const Center(child: Text('Empty data'));
                    }
                  } else {
                    return Center(
                        child: Text(''));
                  }
                },
              ),
              down? SizedBox():  FutureBuilder<Media>(
                  future: mediaAccounts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center();
                    } else if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {

                        return  Center(
                            child: Column(
                              children: [
                                Center(child: text(context, 'تسعدنا متابعتك على حسابات التواصل الخاصة بمنصتنا', textTitleSize, black)),
                                SizedBox(height: 10.h,),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                        },
                                        child: padding(
                                          8,
                                          8,
                                          Container(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                'assets/image/icon- faceboock.png',
                                              )),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {

                                        },
                                        child: padding(
                                          8,
                                          8,
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                              'assets/image/icon- insta.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {

                                        },
                                        child: padding(
                                          8,
                                          8,
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                              'assets/image/icon- snapchat.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {

                                        },
                                        child: padding(
                                          8,
                                          8,
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                              'assets/image/icon- twitter.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {

                                        },
                                        child: padding(
                                          8,
                                          8,
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: SvgPicture.asset('assets/Svg/ttt.svg',width: 30,
                                              height: 30,),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {

                                        },
                                        child: padding(
                                          8,
                                          8,
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child:  SvgPicture.asset(
                                              'assets/Svg/icon-21-youtube.svg',

                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                        },
                                        child: padding(
                                          8,
                                          8,
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: SvgPicture.asset(
                                              'assets/Svg/icon-24-linkedin.svg',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),

                                paddingg(
                                  8,
                                  8,
                                  12,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        copyRight,
                                        size: 14,
                                      ),
                                      text(
                                          context, 'حقوق الطبع والنشر محفوظة', textTitleSize, black),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 55.h,
                                ),],
                            ));
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        return Column(
                        children: [
                          Center(child: text(context, 'تسعدنا متابعتك على حسابات التواصل الخاصة بمنصتنا', textTitleSize, black)),
                          SizedBox(height: 10.h,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var url = snapshot.data!.data!.facebook;
                                    await launch(url!, forceWebView: true);
                                  },
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          'assets/image/icon- faceboock.png',
                                        )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var url = snapshot.data!.data!.instagram;
                                    await launch(url!, forceWebView: true);
                                  },
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                        'assets/image/icon- insta.png',
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var url = snapshot.data!.data!.snapchat;
                                    await launch(url!, forceWebView: true);
                                  },
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                        'assets/image/icon- snapchat.png',
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var url = snapshot.data!.data!.twitter;
                                    await launch(url!, forceWebView: true);
                                  },
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                        'assets/image/icon- twitter.png',
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var url = snapshot.data!.data!.tiktok;
                                    await launch(url!);
                                  },
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset('assets/Svg/ttt.svg',width: 30,
                                        height: 30,),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var url = snapshot.data!.data!.youtube;
                                    await launch(url!);
                                  },
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child:  SvgPicture.asset(
                                        'assets/Svg/icon-21-youtube.svg',

                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var url = snapshot.data!.data!.linkedin;
                                    await launch(url!,
                                        forceWebView: true);
                                  },
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset(
                                        'assets/Svg/icon-24-linkedin.svg',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),

                          paddingg(
                            8,
                            8,
                            12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  copyRight,
                                  size: 14,
                                ),
                                text(
                                    context, 'حقوق الطبع والنشر محفوظة', textTitleSize, black),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 55.h,
                          ),],
                      );
                      } else {
                        return const Center(child: Text('Empty data'));
                      }
                    } else {
                      return Center(
                          child: Text(''));
                    }
                  },
                ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  updateImage() async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imagefile!.openRead()));
    // get file length
    var length = await imagefile!.length();

    // string to uri
    var uri =
        Uri.parse("https://mobile.celebrityads.net/api/celebrity/image/update");

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $userToken"
    };
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(imagefile!.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<File?> getImage() async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
// final String fileExtension = extension(image.path);
    File newImage = await file.copy('$path/$fileName');
    setState(() {
      imagefile = newImage;
      imageurl = imagefile!.path;
    });
  }

  Future<Pricing> fetchCelebrityPricing(String token) async {
    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/celebrity/price'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        //print(response.body);
        jsonDecode(response.body)['data']['price'] == null ?
            priceDone = false : null;
        return Pricing.fromJson(jsonDecode(response.body));
      } else {
        jsonDecode(response.body)['data']['price']== null?  priceDone = false : null;
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (error) {
      if (error is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (error is TimeoutException) {
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
  void fetchNews(String tokenn) async {

    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/celebrity/news'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List a = jsonDecode(response.body)['data']['news'];
        a.isEmpty?
        activitiesDone = false: null;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
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
  void fetchStudio() async {
    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/celebrity/studio'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        List a = jsonDecode(response.body)['data']['studio'];
        a.isEmpty?
            activitiesDone = false: null;
      } else {

        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
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

//--------------------------------------------------------------------------

  void singOut(context, String token) async {
    loadingDialogue(context);
    const url = 'https://mobile.celebrityads.net/api/logout';
    final respons = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (respons.statusCode == 200) {
      descc = null;
      catt = null;
     setState(() {
       Logging.theUser!.clear();
       postsstudio.clear();
       pagestudio = 1;
       st.thumbImage.clear() ;
       nn.posts.clear();
       nn.cImage == null;
       nn.page = 1;
     });
      Navigator.pop(context);
      print(Logging.theUser!.name == null );
      String massage = jsonDecode(respons.body)['message']['ar'];
      DatabaseHelper.removeRememberToken();
      DatabaseHelper.removeFacebookUserEmail();
      DatabaseHelper. removeGoogleUserEmail();
      DatabaseHelper. removeUser();
      DatabaseHelper.removeDeviceToken();
      goTopageReplacement(context, Logging());
    } else {
      Navigator.pop(context);
    }
  }


}
