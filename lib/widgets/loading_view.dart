//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//model
import '../model/skin.dart';
//common
import '../common/loading_status.dart';
import '../common/custom_icon_data.dart';

class LoadingView extends StatelessWidget {
  final LoadingStatus loadingStatus;
  LoadingView(this.loadingStatus);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            const IconData(
              CustomIconData.cat,
              fontFamily: 'iconfont',
            ),
            color: context.watch<SkinProvider>().color['text'],
          ),
          Container(
            padding: EdgeInsets.only(
              left: 12.w,
            ),
            child: Builder(
              builder: (BuildContext conext) {
                if (loadingStatus == LoadingStatus.STATUS_IDEL) {
                  return const Text('上拉加载更多');
                } else if (loadingStatus == LoadingStatus.STATUS_LOADING) {
                  return const Text('加载中');
                }
                return const Text('加载完成');
              },
            ),
          ),
        ],
      ),
    );
  }
}
