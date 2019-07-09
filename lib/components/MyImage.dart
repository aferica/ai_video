import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyNetWorkImage extends StatelessWidget {
  final String src;

  MyNetWorkImage({
    Key key,
    @required this.src
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CachedNetworkImage(
      imageUrl: src,
      placeholder: (context, url) => new Container(
        child: Center(
          child: SpinKitWave(
            color: Colors.deepOrange,
            size: 20.0,
          ),
        ),
      ),
      errorWidget: (context, url, error) => new Container(
        child: new Image.asset('static/images/404.jpg', fit: BoxFit.fitHeight,),
      ),
    );
  }
}