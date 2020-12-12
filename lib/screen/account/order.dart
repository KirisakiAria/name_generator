//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求相关
import '../../services/api.dart';
import '../../services/request.dart';
//组件
import '../../widgets/loading_view.dart';
import '../../widgets/custom_button.dart';
//model
import '../../model/skin.dart';
//common
import '../../common/loading_status.dart';
import '../../common/style.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '订单查询',
        ),
      ),
      body: OrderList(),
    );
  }
}

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _list = <dynamic>[];
  LoadingStatus _loadingStatus = LoadingStatus.STATUS_IDEL;
  int _page = 0;

  Future<void> _getData({bool refresh = true}) async {
    try {
      if (refresh) {
        _page = 0;
        _list.clear();
      }
      _loadingStatus = LoadingStatus.STATUS_LOADING;
      final String path = API.order;
      final Response res = await Request(
        context: context,
      ).httpGet('$path?page=$_page');
      if (res.data['code'] == '1000') {
        setState(() {
          final int length = res.data['data']['list'].length;
          if (length == 0) {
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
          } else if (length < 15) {
            _list.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
          } else {
            _list.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_IDEL;
            _page++;
          }
        });
      } else {
        _loadingStatus = LoadingStatus.STATUS_COMPLETED;
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadingStatus == LoadingStatus.STATUS_IDEL) {
          _getData(refresh: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Style.grey20,
      backgroundColor: Colors.white,
      onRefresh: _getData,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        controller: _scrollController,
        itemCount: _list.length + 1,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          if (index == _list.length) {
            return LoadingView(_loadingStatus);
          } else {
            return ListItem(
              orderNo: _list[index]['orderNo'],
              desc: _list[index]['desc'],
              price: _list[index]['price'],
              time: _list[index]['time'],
              paymentMethod: _list[index]['paymentMethod'],
              status: _list[index]['status'],
            );
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String orderNo, desc, price, time, paymentMethod, status;

  ListItem({
    @required this.orderNo,
    @required this.desc,
    @required this.price,
    @required this.time,
    @required this.paymentMethod,
    @required this.status,
  });

  //查看订单详情弹窗
  void _checkDetails(BuildContext context) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('订单详情'),
          scrollable: true,
          content: SizedBox(
            width: 340.w,
            height: 470.h,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.only(
                  //     bottom: 25.h,
                  //   ),
                  //   child: Text(
                  //     date.substring(0, 10),
                  //     style: TextStyle(
                  //       color: context.watch<SkinProvider>().color['subtitle'],
                  //     ),
                  //   ),
                  // ),
                  // Text(content),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CustomButton(
              text: '確認',
              bgColor: context.watch<SkinProvider>().color['button'],
              textColor: context.watch<SkinProvider>().color['background'],
              borderColor: Style.defaultColor['button'],
              paddingVertical: 14.h,
              callback: () => Navigator.pop(context),
            ),
          ],
          actionsPadding: EdgeInsets.only(
            right: 12.h,
            bottom: 12.h,
          ),
        );
      },
      barrierColor: Color.fromRGBO(0, 0, 0, .4),
      transitionDuration: Duration(milliseconds: 200),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _checkDetails(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                desc,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: context.watch<SkinProvider>().color['subtitle'],
                ),
              ),
            ),
            Container(
              child: Text(
                time,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: context.watch<SkinProvider>().color['subtitle'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
