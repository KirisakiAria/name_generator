//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';
import '../common/optionsData.dart';
//model
import '../model/word_options.dart';

class GeneratePage extends StatefulWidget {
  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  String _word = '彼岸自在';

  Future<void> _getData(BuildContext context) async {
    try {
      final String path = API.word;
      final Response res = await Request.init(context).httpPost(
        path,
        <String, dynamic>{
          'type': context.read<WordOptions>().type,
          'number': context.read<WordOptions>().number,
        },
      );
      if (res.data['code'] == '1000') {
        setState(() {
          _word = res.data['data']['word'];
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Display(word: _word),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomButton(
                  text: '生成',
                  callback: () {
                    _getData(context);
                  },
                ),
                CustomButton(
                  text: '選項',
                  textColor: Colors.black,
                  bgColor: Colors.white,
                  callback: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, anim1, anim2) {
                        return OptionsDialog();
                      },
                      barrierColor: Colors.grey.withOpacity(.4),
                      barrierDismissible: false,
                      barrierLabel: '',
                      transitionDuration: Duration(milliseconds: 400),
                      transitionBuilder: (context, anim1, anim2, child) {
                        final double curvedValue =
                            Curves.easeInOutBack.transform(anim1.value) - 1;
                        return Transform(
                          transform: Matrix4.translationValues(
                            0,
                            curvedValue * -320,
                            0,
                          ),
                          child: OptionsDialog(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//图片/文字显示区域
class Display extends StatelessWidget {
  final String word;
  Display({@required this.word});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 110),
          child: Image(
            image: AssetImage('assets/images/pluto-payment-processed.png'),
            width: 200,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            word,
            style: TextStyle(
              fontFamily: 'NijimiMincho',
              fontSize: 46,
              letterSpacing: 5,
            ),
          ),
        ),
      ],
    );
  }
}

//自定义的select
class InheritedSelect extends InheritedWidget {
  //options列表
  final List<String> list;
  //选择之后回调
  final void Function(BuildContext context, String newValue) callback;
  //当前值
  final dynamic currentValue;

  InheritedSelect({
    Key key,
    @required this.list,
    @required this.callback,
    @required this.currentValue,
    @required Widget child,
  }) : super(key: key, child: child);

  static InheritedSelect of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedSelect>();
  }

  //是否重建widget就取决于数据是否相同
  @override
  bool updateShouldNotify(InheritedSelect oldWidget) {
    return list != oldWidget.list;
  }
}

class SelectBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedSelect.of(context);
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Color(Style.mainColor),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      child: Select(inheritedContext.currentValue),
    );
  }
}

class Select extends StatefulWidget {
  final String dropdownValue;

  Select(this.dropdownValue);

  @override
  _SelectState createState() => _SelectState(dropdownValue);
}

class _SelectState extends State<Select> {
  String dropdownValue;

  _SelectState(this.dropdownValue);

  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedSelect.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isDense: true,
        value: dropdownValue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Color(Style.mainColor),
        ),
        iconSize: 18,
        elevation: 0,
        isExpanded: true,
        style: TextStyle(
          color: Color(Style.mainColor),
          fontSize: 20,
          height: 1.1,
        ),
        onChanged: (dynamic newValue) {
          setState(() {
            dropdownValue = newValue;
            inheritedContext.callback(context, newValue);
          });
        },
        items:
            inheritedContext.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class OptionsDialog extends Dialog {
  OptionsDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 320,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Text(
                    '选项',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InheritedSelect(
                  list: OptionsData.typeList,
                  callback: (context, newValue) {
                    context.read<WordOptions>().changeType(type: newValue);
                  },
                  currentValue: context.watch<WordOptions>().type,
                  child: SelectBox(),
                ),
                InheritedSelect(
                  list: OptionsData.numberList,
                  callback: (context, newValue) {
                    context.read<WordOptions>().changeNumber(number: newValue);
                  },
                  currentValue: context.watch<WordOptions>().number,
                  child: SelectBox(),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: CustomButton(
                    text: '確定',
                    callback: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
