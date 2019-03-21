import 'package:flutter/material.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State createState() {
    return UserInfoPageState();
  }
}

class UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("资料", context),
    );
  }
}
