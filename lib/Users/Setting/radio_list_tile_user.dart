
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';
import '../BalanceModels/get_card.dart';
import '../BalanceModels/get_card.dart' as cardModel;
import 'package:http/http.dart' as http;


cardModel.Card? selectedUser;
final TextEditingController cvvCode1 = TextEditingController();

class RadioWidgetUser extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const RadioWidgetUser() : super();



  @override
  _RadioWidgetUserState createState() => _RadioWidgetUserState();
}

class _RadioWidgetUserState extends State<RadioWidgetUser> {
  Future<GetCard>? getCards;
  String? userToken;
  // List<User>? users;
  List<cardModel.Card>? cards;

  // User? selectedUser;
  int? selectedRadio;
  int? selectedRadioTile;

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
    //users = User.getUsers();

    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getCards = getAllCardInfo(userToken!);
      });
    });
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  setSelectedUser(cardModel.Card user) {
    setState(() {
      selectedUser = user;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<GetCard>(
          future: getCards,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: mainLoad(context));
            }else if(snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done){
              if (snapshot.hasError) {
                if (snapshot.error.toString() == 'SocketException') {
                  return Center(
                      child: SizedBox(
                          height: 500.h,
                          width: 250.w,
                          child: internetConnection(context, reload: () {
                            setState(() {
                              getCards = getAllCardInfo(userToken!);
                              isConnectSection = true;
                            });
                          })));
                } else {
                  return const Center(
                      child: Text('حدث خطا ما اثناء استرجاع البيانات'));
                }
                //---------------------------------------------------------------------------
              }else if(snapshot.hasData){
                ///store all the cards into list
                for(int i = 0; i < cards!.length; i++ ){

                  print('card numbers is ${cards![i].name}');

                }
                return Column(
                  children: createRadioListUsers(),
                );
              }else{
                return const Center(child: Text('Empty data'));
              }
            }else {
              return Center(
                  child: Text('State: ${snapshot.connectionState}'));
            }
          },
        ),
      ],
    );
  }
  List<Widget> createRadioListUsers() {
    List<Widget> widgets = [];
    for (cardModel.Card user in cards!) {
      widgets.add(
        RadioListTile(
          value: user,
          groupValue: selectedUser,
          title: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Directionality(
                      textDirection: TextDirection.ltr,
                      child: text(context, user.number!.toString(), 14, black)),

                  ///Text Filed
                  Visibility(
                    visible: selectedUser == user,
                    child: Column(
                      children: [
                        textFieldSmall(
                          context,
                          'رمز التحقق ' 'CVV',
                          12,
                          false,
                          cvvCode1,
                              (String? value) {
                            /// Validation text field
                            if (value == null || value.isEmpty) {
                              return 'حقل اجباري';
                            }
                            if (value.startsWith('0')) {
                              return 'يجب ان لا يبدا بصفر';
                            }
                            if (value.length > 3) {
                              return 'no';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          onChanged: (cardModel.Card? currentUser) {
            print("Current User ${''}");
            setSelectedUser(currentUser!);
          },
          selected:  true,
          activeColor: purple,
        ),
      );
    }
    return widgets;
  }

  ///Api Section
  ///Get (get all credit card)
  Future<GetCard> getAllCardInfo(String token) async {
    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/user/cards'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        //print(response.body);
        cards = GetCard.fromJson(jsonDecode(response.body)).data!.card;
        return GetCard.fromJson(jsonDecode(response.body));
      } else {
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
}

///user class
// class User {
//   int? userId;
//   String firstName;
//
//   User({
//     this.userId,
//     required this.firstName,
//   });
//
//   static List<User> getUsers() {
//     return <User>[
//       User(userId: 1, firstName: "**** **** **** 4958"),
//       User(userId: 2, firstName: "**** **** **** 4323"),
//     ];
//   }
// }


