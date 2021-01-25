//核心库
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//common
import '../../common/style.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';
//组件
import '../../widgets/custom_button.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '个人中心',
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => ListTileTheme(
          iconColor: context.watch<SkinProvider>().color['subtitle'],
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
            ),
            children: <Widget>[
              Avatar(),
              Order(),
              Username(),
              Password(),
              InfoContainer(
                title: '手机号',
                value: '${context.watch<UserProvider>().tel}',
              ),
              InfoContainer(
                title: '注册日期',
                value: '${context.watch<UserProvider>().date}',
              ),
            ],
          ),
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

  //从相册获取图片
  Future<void> _getImage() async {
    try {
      final dynamic image = await _picker.getImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        _upLoadImage(
          image: image,
        );
      }
    } catch (err) {
      print(err);
    }
  }

  //上传图片
  Future<void> _upLoadImage({
    @required PickedFile image,
  }) async {
    try {
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
      final Response res = await Request(
        context: context,
      ).httpPost(
        path,
        formdata,
      );
      if (res.data['code'] == '1000') {
        _changeAvatar(
          avatar: res.data['data']['path'],
        );
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _changeAvatar({
    @required String avatar,
  }) async {
    try {
      final String path = API.changeAvatar;
      final Response res = await Request(
        context: context,
      ).httpPut(
        path,
        <String, dynamic>{
          'tel': context.read<UserProvider>().tel,
          'avatar': avatar,
        },
      );
      if (res.data['code'] == '1000') {
        context.read<UserProvider>().changeAvatar(avatar);
        final SnackBar snackBar = SnackBar(
          content: const Text('修改头像成功'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _getImage(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              '头像',
              style: TextStyle(
                height: 1,
                fontSize: 16,
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 70.w,
                  height: 70.w,
                  child: ClipOval(
                    //透明图像占位符
                    child: FadeInImage.memoryNetwork(
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image:
                          '${API.origin}${context.watch<UserProvider>().avatar}',
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
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
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        try {
          Map result = await showGeneralDialog(
            context: context,
            barrierColor: Colors.grey.withOpacity(.4),
            pageBuilder: (
              BuildContext context,
              Animation<double> anim1,
              Animation<double> anim2,
            ) {
              return EditUserNameDialog();
            },
            barrierLabel: '',
            barrierDismissible: true,
            transitionDuration: Duration(milliseconds: 300),
            transitionBuilder: (
              BuildContext context,
              Animation<double> anim1,
              Animation<double> anim2,
              Widget child,
            ) {
              return Transform.scale(
                scale: anim1.value,
                child: child,
              );
            },
          );
          if (result['success']) {
            final SnackBar snackBar = SnackBar(
              content: const Text('修改用户名成功'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } catch (err) {
          print(err);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              '用户名',
              style: TextStyle(
                height: 1,
                fontSize: 16,
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    right: 15.w,
                  ),
                  child: Text(
                    '${context.watch<UserProvider>().username}',
                    style: TextStyle(
                      height: 1,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//我的VIP
class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.pushNamed(
        context,
        '/order',
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: 10.w,
              ),
              child: Text(
                '我的订单',
                style: TextStyle(
                  height: 1.6,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    right: 15.w,
                  ),
                  child: Text(
                    '查看详情',
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
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
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.pushNamed(
        context,
        '/login',
        arguments: <String, int>{
          'index': 3,
        },
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              '修改密码',
              style: TextStyle(
                height: 1,
                fontSize: 16,
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    right: 15.w,
                  ),
                  child: const Text(
                    '点此修改',
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
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
      builder: (
        BuildContext context,
        StateSetter setState,
      ) {
        String _username;
        //定义GlobalKey为了获取到form的状态
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

        //修改用户名
        Future<void> _changeUsername() async {
          try {
            final String path = API.changeUsername;
            final Response res = await Request(
              context: context,
            ).httpPut(
              path,
              <String, dynamic>{
                'tel': context.read<UserProvider>().tel,
                'username': _username,
              },
            );
            if (res.data['code'] == '1000') {
              context.read<UserProvider>().changeUsername(_username);
              Navigator.of(context).pop(<String, bool>{'success': true});
            }
          } catch (err) {
            print(err);
          }
        }

        //表单验证
        void _formValidate() async {
          try {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              await _changeUsername();
            }
          } catch (err) {
            print(err);
          }
        }

        return Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          color: Style.grey20,
          child: Center(
            child: SizedBox(
              width: 320.w,
              height: 160,
              child: Container(
                padding: EdgeInsets.only(
                  left: 30.w,
                  right: 30.w,
                  top: 30,
                ),
                decoration: ShapeDecoration(
                  color: context.watch<SkinProvider>().color['background'],
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
                    children: <Widget>[
                      TextFormField(
                        inputFormatters: [
                          //长度限制10
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  context.watch<SkinProvider>().color['border'],
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  context.watch<SkinProvider>().color['border'],
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
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomButton(
                              text: '取消',
                              bgColor: Style.defaultColor['background'],
                              textColor: Style.defaultColor['button'],
                              borderColor: Style.defaultColor['button'],
                              fontSize: 16,
                              paddingHorizontal: 38,
                              paddingVertical: 12,
                              callback: () => Navigator.pop(
                                context,
                                <String, bool>{'success': false},
                              ),
                            ),
                            CustomButton(
                              text: '確定',
                              bgColor:
                                  context.watch<SkinProvider>().color['button'],
                              textColor: context
                                  .watch<SkinProvider>()
                                  .color['background'],
                              borderColor: Style.defaultColor['button'],
                              fontSize: 16,
                              paddingHorizontal: 38,
                              paddingVertical: 12,
                              callback: () async => _formValidate(),
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
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
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
