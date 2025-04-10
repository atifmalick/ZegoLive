import 'package:flutter/material.dart';

enum PageTransitionType {
  fadeIn,
  rightToLeftWithSlide,
  leftToRightWithSlide,
  upToDownWithSlide,
  downToUpWithSlide,
}

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  Future<dynamic> navigateToTransitionWithSlide<T>(
      Widget widget, PageTransitionType transitionType,
      [T? arguments]) {
    return _navigationKey.currentState!.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => widget,
        settings: RouteSettings(arguments: arguments),
        transitionsBuilder: (_, animation, __, child) {
          final begin = _getOffsetByPageTypeTransition(transitionType);

          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<dynamic> navigateToTransitionWithFade<T>(Widget widget,
      [T? arguments]) {
    return _navigationKey.currentState!.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => widget,
        settings: RouteSettings(arguments: arguments),
        transitionsBuilder: (_, animation, __, child) {
          const curve = Curves.ease;
          var tween =
              Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: curve));
          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<dynamic> navigateTo<T>(String routeName, [T? arguments]) {
    return _navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndReplace<T>(String routeName, [T? arguments]) {
    return _navigationKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndRemove<T>(String routeName, [T? arguments]) {
    return _navigationKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  Future<dynamic> navigateToAndRemoveUntil<T>(String routeName,
      [T? arguments]) {
    return _navigationKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  void pop<T>([T? arguments]) => _navigationKey.currentState!.pop(arguments);

  Offset _getOffsetByPageTypeTransition(PageTransitionType transitionType) {
    switch (transitionType) {
      case PageTransitionType.fadeIn:
        return const Offset(0, 0);
      case PageTransitionType.rightToLeftWithSlide:
        return const Offset(1.0, 0.0);
      case PageTransitionType.leftToRightWithSlide:
        return const Offset(-1.0, 0.0);
      case PageTransitionType.upToDownWithSlide:
        return const Offset(0.0, 1.0);
      case PageTransitionType.downToUpWithSlide:
        return const Offset(0.0, -1.0);
    }
  }
}
