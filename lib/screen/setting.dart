//核心库
import 'dart:io';
import 'package:flutter/material.dart';
//第三方包
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _cacheSizeStr;

  //载入缓存
  Future<Null> _loadCache() async {
    try {
      //获取缓存文件夹
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());
      setState(() {
        _cacheSizeStr = _renderSize(value);
        print(_cacheSizeStr);
      });
    } catch (err) {
      print(err);
    }
  }

  //递归的方式得到缓存文件夹内所有文件大小的总数（直至找到文件才计算大小）
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
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
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  //清除缓存
  void _clearCache(BuildContext context) async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await _loadCache();
    final snackBar = SnackBar(content: Text('清除缓存成功'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  ///递归方式删除目录（直至找到文件才删除）
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
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
          title: Text(
            '设置',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        //context必须是Scaffold的子context，Scaffold.of才能生效
        body: Builder(
            builder: (context) => ListView(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        _clearCache(context);
                      },
                      leading: Icon(IconData(0xe677, fontFamily: 'iconfont')),
                      title: Text('清除缓存'),
                      subtitle: Text('缓存大小：$_cacheSizeStr'),
                    ),
                  ],
                )));
  }
}
