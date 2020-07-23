//核心库
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
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
            UserName(),
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
  Future<void> _upLoadImage({
    @required PickedFile image,
    @required BuildContext context,
  }) async {
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

  Future<void> _changeAvatar({
    @required String avatar,
    @required BuildContext context,
  }) async {
    final String path = '${API.changeAvatar}';
    final Response res = await Request.init(context).httpPut(
      path,
      <String, dynamic>{
        'tel': context.read<User>().tel,
        'avatar': avatar,
      },
    );
    if (res.data['code'] == '1000') {
      context.read<User>().changeAvatar(avatar);
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
class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  String username;

  //修改用户名
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
      context.read<User>().changeUsername(username);
      final SnackBar snackBar = SnackBar(
        content: Text('修改用户名成功'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class EditDialog extends Dialog {
  EditDialog({Key key}) : super(key: key);
  String _username;
  //定义GlobalKey为了获取到form的状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //表单验证
  void _formValidate(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                inputFormatters: [
                  //长度限制11
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 1),
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
              CustomButton(
                text: '提交',
              ),
            ],
          ),
        ),
      ),
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
                padding: EdgeInsets.only(right: 35),
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
