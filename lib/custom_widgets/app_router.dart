import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Route sharedAxisRoute(Widget page, {Object? arguments}) {
  return PageRouteBuilder(
    settings: RouteSettings(arguments: arguments),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}