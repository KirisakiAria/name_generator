//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//model
import '../../model/skin.dart';
import '../../model/user.dart';
import '../../model/laboratory_options.dart';

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
      //context必须是Scaffold的子context，ScaffoldMessenger.of才能生效
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
                subtitle: const Text(
                  '文字下方添加罗马音，但会增大网络延迟',
                  style: TextStyle(
                    fontSize: 12,
                    height: 2,
                  ),
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
                  onChanged: (bool value) async {
                    try {
                      final bool loginState =
                          context.read<UserProvider>().loginState;
                      final LaboratoryOptionsProvider
                          laboratoryOptionsProvider =
                          context.read<LaboratoryOptionsProvider>();
                      if (!loginState) {
                        final SnackBar snackBar = SnackBar(
                          content: const Text('请先登录再使用实验室功能'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        laboratoryOptionsProvider.toggleRomaji();
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool(
                            'romaji', laboratoryOptionsProvider.romaji);
                      }
                    } catch (err) {
                      print(err);
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  '点赞模式',
                  style: TextStyle(height: 1),
                ),
                subtitle: const Text(
                  '可以对生成的网名进行点赞，需要登录',
                  style: TextStyle(
                    fontSize: 12,
                    height: 2,
                  ),
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
                  value: context.watch<LaboratoryOptionsProvider>().likeWord,
                  onChanged: (bool value) async {
                    try {
                      final bool loginState =
                          context.read<UserProvider>().loginState;
                      final LaboratoryOptionsProvider
                          laboratoryOptionsProvider =
                          context.read<LaboratoryOptionsProvider>();
                      if (!loginState) {
                        final SnackBar snackBar = SnackBar(
                          content: const Text('请先登录再使用实验室功能'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        laboratoryOptionsProvider.toggleLikeWord();
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool(
                            'likeWord', laboratoryOptionsProvider.likeWord);
                      }
                    } catch (err) {
                      print(err);
                    }
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
