import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiHelper {
  static double getAppBarFontSize() {
    if (ScreenUtil().orientation == Orientation.portrait) {
      return 20.sp;
    } else {
      return 13.sp;
    }
  }
}
