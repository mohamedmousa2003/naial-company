import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class MyResponsive {
  /// Responsive width
  static double width({required double value}) => value.w;

  /// Responsive height
  static double height({required double value}) => value.h;

  /// Responsive font size
  static double fontSize({required double value}) => value.sp;

  /// Responsive radius (BorderRadius / Border / any square dimension)
  static double radius({required double value}) => value.r;

  /// Responsive symmetric padding (horizontal & vertical)
  static EdgeInsets paddingSymmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: (horizontal ?? 0).w,
      vertical: (vertical ?? 0).h,
    );
  }

  /// Responsive padding for each side (start, end, top, bottom)
  static EdgeInsetsDirectional paddingOnly({
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) {
    return EdgeInsetsDirectional.only(
      start: (start ?? 0).w,
      end: (end ?? 0).w,
      top: (top ?? 0).h,
      bottom: (bottom ?? 0).h,
    );
  }

  /// Responsive padding applied equally on all sides
  static EdgeInsets paddingAll({required double value}) {
    return EdgeInsets.all(value.w);
  }
}

/*
      to use it in sized box

            SizedBox(
              width: MyResponsive.width(value: 30),
              height: MyResponsive.height(value: 30),
            ),


      to use it with padding or margin

            Container(
              padding: MyResponsive.paddingSymmetric(horizontal: 20, vertical: 20),
              margin: MyResponsive.paddingSymmetric(horizontal: 20, vertical: 20),
            )
 */

// abstract class MyResponsive {
//   static double height(BuildContext context, {required double value}) =>
//       value.h; // ScreenUtil auto handles height
//
//   static double width(BuildContext context, {required double value}) =>
//       value.w; // ScreenUtil auto handles width
//
//   static double fontSize(BuildContext context, {required double value}) =>
//       value.sp; // sp for scalable fonts
//
//   static EdgeInsets paddingSymmetric(
//       BuildContext context, {
//         double? horizontal,
//         double? vertical,
//       }) {
//     return EdgeInsets.symmetric(
//       horizontal: (horizontal ?? 0).w,
//       vertical: (vertical ?? 0).h,
//     );
//   }
//
//   static EdgeInsets paddingOnly(
//       BuildContext context, {
//         double? left,
//         double? right,
//         double? top,
//         double? bottom,
//       }) {
//     return EdgeInsets.only(
//       left: (left ?? 0).w,
//       right: (right ?? 0).w,
//       top: (top ?? 0).h,
//       bottom: (bottom ?? 0).h,
//     );
//   }
//
// }
