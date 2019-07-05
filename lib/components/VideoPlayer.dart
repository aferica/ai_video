import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class VideoPlayer extends StatelessWidget {
  // 视频源地址
  final String videoSrc;
  // 视频宽高比
  final double ratio;

  final IjkMediaController controller = IjkMediaController();

  VideoPlayer({
    Key key,
    @required this.videoSrc,
    this.ratio = 16.0 * 9.0
  }): super(key: key);


  @override
  Widget build(BuildContext context) {
    controller.setNetworkDataSource(
      videoSrc,
      autoPlay: true
    );
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.width / ratio,
      child: IjkPlayer(mediaController: controller),
    );
  }

  @override
  void dispose() {
    controller.dispose();
  }
}