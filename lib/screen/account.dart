//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//model
import '../model/user.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          padding: EdgeInsets.symmetric(horizontal: 30),
          children: <Widget>[
            Avatar(),
            Container(
              padding: EdgeInsets.only(
                top: 5,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '用户名',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          '${context.watch<User>().username}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '性别',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          '${context.watch<User>().username}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//修改头像
class Avatar extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final ImagePicker _picker = ImagePicker();
  PickedFile _image;
  String username;

  //从相册获取图片
  Future<void> _getImage(BuildContext context) async {
    final dynamic image = await _picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      _upLoadImage(
        image: image,
        context: context,
      );
      setState(() {
        _image = image;
      });
    }
  }

  //上传图片
  Future<void> _upLoadImage({PickedFile image, BuildContext context}) async {
    final filePath = image.path;
    final String path = '${API.upload}';
    final String name =
        filePath.substring(path.lastIndexOf('/') + 1, filePath.length);
    final FormData formdata = FormData.fromMap(
        {'file': await MultipartFile.fromFile(filePath, filename: name)});
    final Response res = await Request.init(context).httpPost(
      path,
      formdata,
    );
    if (res.data['code'] == '1000') {
      print(res.data);
      _changeAvatar(
        avatar: res.data['data']['url'],
        context: context,
      );
    }
  }

  Future<void> _changeAvatar({String avatar, BuildContext context}) async {
    final String path = '${API.changeAvatar}';
    final Response res = await Request.init(context).httpPut(
      path,
      <String, dynamic>{
        'tel': context.read<User>().tel,
        'avatar': avatar,
      },
    );
    if (res.data['code'] == '1000') {
      context.read<User>().changeAvatar(avatar: avatar);
      final SnackBar snackBar = SnackBar(
        content: Text('修改头像成功'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _getImage(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '头像',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: ClipOval(
                    //透明图像占位符
                    child: FadeInImage.memoryNetwork(
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image: '${API.origin}${context.watch<User>().avatar}',
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//修改用户名
class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  String username;

  Future<void> _changeUserName(BuildContext context) async {
    final String path = '${API.changeUserName}';
    final Response res = await Request.init(context).httpPut(
      path,
      <String, dynamic>{
        'tel': context.read<User>().tel,
        'username': username,
      },
    );
    if (res.data['code'] == '1000') {
      final SnackBar snackBar = SnackBar(
        content: Text('修改用户名成功'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {}
}
