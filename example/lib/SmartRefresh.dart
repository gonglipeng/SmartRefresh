import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

extension SmartRefresh on EasyRefresh {
  static bool _isFooter = true; //控制footer是否显示
  static bool _isLoad = false; //防止load多次加载
  static bool _isMove = false; //防止load多次加载
  static bool _isAutoClose = false; //是否是一秒后自动关闭footer

  Listener buildSmartRefresh(State state) {
    return Listener(
      onPointerDown: (p) {
        state.setState(() {
          _isLoad = true;
          _isFooter = true;
          print("onPointerDown$_isLoad");
        });
      },
      onPointerMove: (p) {
        state.setState(() {
          _isMove = true;
        });
      },
      onPointerUp: (p) {
        _isMove = false;
        if (!_isAutoClose) {
          state.setState(() {
            _isAutoClose = true;
            _isFooter = false;
          });
        }
      },
      child: this,
    );
  }

  Function onSmartRefreshCallback(onRefresh,EasyRefreshController controller) {
    return () async {
      await Future.delayed(Duration(seconds: 0), () {
        onRefresh();
        controller.resetLoadState();
      });
    };
  }

  Function onSmartLoadCallback(onLoad,state,EasyRefreshController controller) {
    return _isFooter
        ? () async {
      await Future.delayed(Duration(seconds: 0), () {
        print('onLoad');
        print("onLoad$_isLoad");
        if (_isLoad) {
          _isLoad = false;
          onLoad();
          loadingBottomControl(state);
        } else {
          controller.finishLoad();
        }
      });
    }
        : null;
  }

  void loadingBottomControl(State state) {
    Future.delayed(Duration(milliseconds: 1000), () {
      state.setState(() {
        if(_isMove) {
          _isAutoClose = false;
        } else {
          _isAutoClose = true;
          _isFooter = false;
        }

      });
    });
  }
}
