import 'package:flutter/material.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';

class BankManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BankManagePageState();
  }

}

class BankManagePageState extends State<BankManagePage>  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("管理", context),
      body: Text("管理"),
    );
  }

}