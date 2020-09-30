//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
//model
import '../model/user.dart';
//common
import '../common/custom_icon_data.dart';
//model
import '../model/skin.dart';
import '../model/laboratory_options.dart';

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
      body: Builder(
        builder: (BuildContext context) => ListTileTheme(
          iconColor: context.watch<SkinProvider>().color['subtitle'],
          child: ListView(
            children: <Widget>[
              ListTile(
                title: const Text(
                  '日文罗马注音',
                  style: TextStyle(height: 1),
                ),
                trailing: Switch(
                  activeColor:
                      context.watch<SkinProvider>().color['switchThumb'],
                  activeTrackColor:
                      context.watch<SkinProvider>().color['activeSwitchTrack'],
                  inactiveThumbColor:
                      context.watch<SkinProvider>().color['switchThumb'],
                  inactiveTrackColor: context
                      .watch<SkinProvider>()
                      .color['inactiveSwitchTrack'],
                  value: context.watch<LaboratoryOptionsProvider>().romaji,
                  onChanged: (bool value) {
                    context.read<LaboratoryOptionsProvider>().toggleRomaji();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
