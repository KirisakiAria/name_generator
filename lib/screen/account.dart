//核心库
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//common
import '../common/style.dart';
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
          '账号资料',
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
            Username(),
            Password(),
            InfoContainer(
              title: '手机号',
              value: '${context.watch<User>().tel}',
            ),
            InfoContainer(
              title: '注册日期',
              value: '${context.watch<User>().date}',
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

  //从相册获取图片
  Future<void> _getImage(BuildContext context) async {
    final dynamic image = await _picker.getImage(
      source: ImageSource.gallery,
    );
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
  Future<void> _upLoadImage({
    @required PickedFile image,
    @required BuildContext context,
  }) async {
    final filePath = image.path;
    final String path = API.upload;
    final String name =
        filePath.substring(path.lastIndexOf('/') + 1, filePath.length);
    final FormData formdata = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: name,
      ),
    });
    final Response res = await Request.init(context).httpPost(
      path,
      formdata,
    );
    if (res.data['code'] == '1000') {
      _changeAvatar(
        avatar: res.data['data']['url'],
        context: context,
      );
    }
  }

  Future<void> _changeAvatar({
    @required String avatar,
    @required BuildContext context,
  }) async {
    final String path = API.changeAvatar;
    final Response res = await Request.init(context).httpPut(
      path,
      <String, dynamic>{
        'tel': context.read<User>().tel,
        'avatar': avatar,
      },
    );
    if (res.data['code'] == '1000') {
      context.read<User>().changeAvatar(avatar);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('avatar', avatar);
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
                  height: 80,
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
class Username extends StatefulWidget {
  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Map result = await showGeneralDialog(
          context: context,
          barrierColor: Colors.grey.withOpacity(.4),
          pageBuilder: (context, anim1, anim2) {
            return EditUserNameDialog();
          },
          barrierDismissible: false,
          barrierLabel: '',
          transitionDuration: Duration(milliseconds: 300),
          transitionBuilder: (context, anim1, anim2, child) {
            return Transform.scale(
              scale: anim1.value,
              child: child,
            );
          },
        );
        if (result['success']) {
          final SnackBar snackBar = SnackBar(
            content: Text('修改用户名成功'),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 25,
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
                      height: 1,
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
    );
  }
}

//修改密码
class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/login',
          arguments: <String, int>{
            'index': 3,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 25,
          bottom: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '修改密码',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 15),
                  child: Text(
                    '点此修改',
                    style: TextStyle(
                      height: 1,
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
    );
  }
}

class EditUserNameDialog extends Dialog {
  EditUserNameDialog({Key key}) : super(key: key);

  @override //Dialog本身无状态，需要用StatefulBuilder构造出一个有状态的控件
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        String _username;
        //定义GlobalKey为了获取到form的状态
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

        //修改用户名
        Future<void> _changeUsername(BuildContext context) async {
          final String path = API.changeUsername;
          final Response res = await Request.init(context).httpPut(
            path,
            <String, dynamic>{
              'tel': context.read<User>().tel,
              'username': _username,
            },
          );
          if (res.data['code'] == '1000') {
            context.read<User>().changeUsername(_username);
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString('username', _username);
            Navigator.of(context).pop(<String, bool>{'success': true});
          }
        }

        //表单验证
        void _formValidate(BuildContext context) async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            await _changeUsername(context);
          }
        }

        return Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          color: Color(Style.grey20),
          child: Center(
            child: SizedBox(
              width: 300,
              height: 140,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  shadows: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black12, //阴影颜色
                      blurRadius: 14, //阴影大小
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        inputFormatters: [
                          //长度限制10
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(Style.borderColor),
                            ),
                          ),
                          hintText: '请输入新用户名（最长十位）',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return '请输入用户名';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _username = value;
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              child: Text(
                                '取消',
                                style: TextStyle(
                                  color: Color(Style.mainColor),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(
                                    context, <String, bool>{'success': false});
                              },
                            ),
                            FlatButton(
                              child: Text(
                                '确认',
                                style: TextStyle(
                                  color: Color(Style.mainColor),
                                ),
                              ),
                              onPressed: () async {
                                _formValidate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String title;
  final String value;
  InfoContainer({
    @required this.title,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
