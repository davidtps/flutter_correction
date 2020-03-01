import 'package:flutter/material.dart';

enum Type {
  RIGHT_TO_LEFT,
  LEFT_TO_RIGHT,
  BOTTOM_TO_TOP,
  TOP_TO_BOTTOM,
}

class RouteManager {
  static jumpPageWithAnim(
    BuildContext context,
    Widget widget, {
    Type type,
    int duration = 100,
    bool showAnim = true,
  }) {
    if (showAnim) {
      //default right to left
      double startX = 1.0;
      double startY = 0;
      double endX = 0;
      double endY = 0;

      switch (type) {
        case Type.LEFT_TO_RIGHT:
          startX = -1;
          startY = 0;
          endX = 0;
          endY = 0;
          break;
        case Type.RIGHT_TO_LEFT:
          startX = 1.0;
          startY = 0;
          endX = 0;
          endY = 0;
          break;
        case Type.BOTTOM_TO_TOP:
          startX = 0;
          startY = 1;
          endX = 0;
          endY = 0;
          break;
        case Type.TOP_TO_BOTTOM:
          startX = 0;
          startY = -1;
          endX = 0;
          endY = 0;
          break;
        default:
          startX = 1;
          startY = 0;
          endX = 0;
          endY = 0;
          break;
      }

      Navigator.of(context).push(
        PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                position: Tween(
                  begin: Offset(startX, startY),
                  end: Offset(endX, endY),
                ).animate(animation),
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: duration)),
      );
    } else {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (_, __, ___) => widget));
    }
  }

  //  Navigator.of(context).pushNamed("/hot");
  static jumpPageWithName(BuildContext context, String name) {
    Navigator.of(context).pushNamed(name);
  }

  static jumpPageCommon(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
