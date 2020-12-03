//核心库
import 'dart:io';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';
//common
import '../../common/custom_icon_data.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _cacheSizeStr;

  //载入缓存
  Future<void> _loadCache() async {
    try {
      //获取缓存目录
      final Directory tempDir = await getTemporaryDirectory();
      final double value = await _getTotalSizeOfFilesInDir(tempDir);
      setState(() {
        _cacheSizeStr = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }

  //递归的方式得到缓存文件夹内所有文件大小的总数（直至找到文件才计算大小）
  //FileSystemEntity是File、Directory的超类
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        final int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  //格式化缓存数据
  String _renderSize(double value) {
    if (null == value) {
      return '0.00MB';
    }
    //级联运算符 (..) 可以实现对同一个对像进行一系列的操作
    final List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    final String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  //清除缓存 这里传入context是为了让context找到Scaffold
  void _clearCache(BuildContext context) async {
    final Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await _delDir(tempDir);
    await _loadCache();
    final SnackBar snackBar = SnackBar(
      content: const Text('清除缓存成功'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///递归方式删除目录（直至找到文件才删除）
  Future<void> _delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }
    await file.delete();
  }

  @override
  void initState() {
    super.initState();
    _loadCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '设置',
        ),
      ),
      //context对象必须是Scaffold的子context，ScaffoldMessenger.of才能生效。所以这里使用了Builder包装了一层，向下传递了context对象。
      body: Builder(
        builder: (BuildContext context) => ListTileTheme(
          iconColor: context.watch<SkinProvider>().color['subtitle'],
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  final bool loginState =
                      context.read<UserProvider>().loginState;
                  if (loginState) {
                    Navigator.pushNamed(
                      context,
                      '/account',
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      '/login',
                    );
                  }
                },
                leading: const Icon(
                  const IconData(
                    CustomIconData.account,
                    fontFamily: 'iconfont',
                  ),
                  color: Color(0xff70a1ff),
                ),
                title: const Text(
                  '账号资料',
                  style: TextStyle(height: 1),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/change_skin',
                ),
                leading: const Icon(
                  const IconData(
                    CustomIconData.theme,
                    fontFamily: 'iconfont',
                  ),
                  color: Color(0xfffeca57),
                ),
                title: const Text(
                  '主题风格',
                  style: TextStyle(height: 1),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () => _clearCache(context),
                leading: const Icon(
                  const IconData(
                    CustomIconData.clearCache,
                    fontFamily: 'iconfont',
                  ),
                  color: Color(0xffff7f50),
                ),
                title: const Text('清除缓存'),
                subtitle: Text('缓存大小：$_cacheSizeStr'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
