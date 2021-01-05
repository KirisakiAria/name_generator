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
              body: _list[index]['body'],
              price: _list[index]['price'].toString(),
              time: _list[index]['convertedTime'],
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
  final String orderNo, body, price, time, paymentMethod;
  final bool status;

  ListItem({
    @required this.orderNo,
    @required this.body,
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
          title: const Text('订单详情'),
          scrollable: true,
          content: SizedBox(
            width: 340.w,
            height: 470.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.h,
                    ),
                    child: Text(
                      '订单号：$orderNo',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.watch<SkinProvider>().color['order'],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.h,
                    ),
                    child: Text(
                      '订单描述：$body',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.watch<SkinProvider>().color['order'],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.h,
                    ),
                    child: Text(
                      '订单金额：$price',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.watch<SkinProvider>().color['order'],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.h,
                    ),
                    child: Text(
                      '订单时间：$time',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.watch<SkinProvider>().color['order'],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.h,
                    ),
                    child: Text(
                      '支付方式：${paymentMethod == '1' ? '支付宝' : '微信'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.watch<SkinProvider>().color['order'],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.h,
                    ),
                    child: Text(
                      '订单状态：${status ? '已完成' : '失败'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.watch<SkinProvider>().color['order'],
                      ),
                    ),
                  ),
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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    bottom: 15.h,
                  ),
                  child: Text(
                    body,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '金额：${price.toString()}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 12,
                      color: context.watch<SkinProvider>().color['subtitle'],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: 20.w,
                  ),
                  child: Text(
                    '支付类型：${paymentMethod == '1' ? '支付宝' : '微信'}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.watch<SkinProvider>().color['subtitle'],
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '创建时间：$time',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.watch<SkinProvider>().color['subtitle'],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
