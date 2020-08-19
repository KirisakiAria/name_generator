//核心库
import 'dart:io';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
//model
import '../model/user.dart';
//common
import '../common/custom_icon_data.dart';

class LaboratoryPage extends StatefulWidget {
  @override
  _LaboratoryPageState createState() => _LaboratoryPageState();
}

class _LaboratoryPageState extends State<LaboratoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '实验室',
        ),
      ),
      //context必须是Scaffold的子context，Scaffold.of才能生效
      body: Container(),
    );
  }
}
