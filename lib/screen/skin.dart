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

class SkinPage extends StatefulWidget {
  @override
  _SkinPageState createState() => _SkinPageState();
}

class _SkinPageState extends State<SkinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '切换皮肤',
        ),
      ),
      body: Builder(
        builder: (contenxt) => ListView(),
      ),
    );
  }
}
