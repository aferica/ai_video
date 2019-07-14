import 'package:flutter/material.dart';

import 'package:ai_video/components/ExceptionMessage.dart';

class ErrorPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: ExceptionMessage(
        type: 'net',
      ),
    );
  }
}