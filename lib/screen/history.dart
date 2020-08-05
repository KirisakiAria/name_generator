//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方包
import 'package:dio/dio.dart';
//common
import '../services/api.dart';
import '../services/request.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '查询记录',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: HistoryList(),
    );
  }
}

class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<dynamic> historyList = <dynamic>[];

  Future<void> _getData() async {
    try {
      final String path = API.history;
      final Response res = await Request.init(context).httpGet(path);
      if (res.data['code'] == '1000') {
        setState(() {
          historyList = res.data['data']['list'];
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 6),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          return ListItem(
            type: historyList[index]['type'],
            word: historyList[index]['word'],
          );
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String type, word;
  ListItem({
    @required this.type,
    @required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            IconData(
              type == '中国风' ? 0xec15 : 0xe63f,
              fontFamily: 'iconfont',
            ),
            color: type == '中国风' ? Colors.pinkAccent : Colors.blue,
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: word));
              final SnackBar snackBar = SnackBar(
                content: Text('复制成功'),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                this.word,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
