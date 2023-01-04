import 'package:flutter/material.dart';
class MyAdvertisment extends StatefulWidget {
  const MyAdvertisment({Key? key}) : super(key: key);

  @override
  State<MyAdvertisment> createState() => _MyAdvertismentState();
}

class _MyAdvertismentState extends State<MyAdvertisment> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>  true;
}
