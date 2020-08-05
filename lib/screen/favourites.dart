//核心库
import 'package:flutter/material.dart';
//第三方包
import 'package:dio/dio.dart';
//common
import '../services/api.dart';
import '../services/request.dart';

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '收藏',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FavouritesList(),
    );
  }
}

class FavouritesList extends StatefulWidget {
  @override
  _FavouritesListState createState() => _FavouritesListState();
}

class _FavouritesListState extends State<FavouritesList> {
  List<dynamic> favouritesList = <dynamic>[];

  Future<void> _getData() async {
    try {
      final String path = API.favourite;
      final Response res = await Request.init(context).httpGet(path);
      if (res.data['code'] == '1000') {
        setState(() {
          favouritesList = res.data['data']['list'];
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
        itemCount: favouritesList.length,
        itemBuilder: (context, index) {
          return ListItem(
            type: favouritesList[index]['type'],
            word: favouritesList[index]['word'],
            callback: _getData,
          );
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String type, word;
  final void Function() callback;
  ListItem({
    @required this.type,
    @required this.word,
    @required this.callback,
  });

  Future<void> _cancel({
    @required String word,
    @required BuildContext context,
  }) async {
    try {
      final String path = API.favourite;
      final Response res =
          await Request.init(context).httpDelete('$path/$word');
      if (res.data['code'] == '1000') {
        callback();
      }
    } catch (err) {
      print(err);
    }
  }

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
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              this.word,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: FlatButton(
                  child: Text(
                    '取消收藏',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                  ),
                  onPressed: () {
                    _cancel(
                      word: word,
                      context: context,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
