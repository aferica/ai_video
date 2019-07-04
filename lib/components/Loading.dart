import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
//  final String
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SpinKitCircle(
      color: Colors.deepOrange,
      size: 60.0,
    );
  }
}

class ImageLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SpinKitFadingCube(
      color: Colors.deepOrange,
      size: 60.0,
    );
  }
}