import 'package:flutter/material.dart';

class BlankRow extends StatelessWidget {
  // 空白行高度
  final double height;
  // 空白行背景色
  final Color color;

  BlankRow({
    Key key,
    this.height = 10.0,
    this.color = const Color(0xffeeeeee)
  }):super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: height,
      color: color,
    );
  }
}