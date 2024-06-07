import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String text;

  const ScreenTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      builder: (BuildContext context, double _val, Widget? child) {
        return Opacity(
          opacity: _val,
          child: child,
        );
      },
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ),
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeIn,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
