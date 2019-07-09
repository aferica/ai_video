import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class LoadingDialog extends StatelessWidget {
  // 主标题
  final String title;
  //
  final String description;

  LoadingDialog({
    Key key,
    this.title = '正在加载，请稍等...',
    this.description = '由于第一次使用时需要获取视频源信息，可能会导致加载一段时间，请耐心等待'
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 300.0,
            maxHeight: 300.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(0.0),
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                  image: DecorationImage(
                    image: AssetImage('static/gifs/360429.gif'),
                  ),
                ),
              ),
              Container(
                height: 60,
                child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    height: 2.0
                  )
                ),
              ),

            ],
          ),
        ),
      ),
    );

    // TODO: implement build
//    return AssetGiffyDialog(
//      image: Image.asset('static/gifs/360429.gif', fit: BoxFit.cover,),
//      title: Text(title,
//        textAlign: TextAlign.center,
//        style: TextStyle(
//          fontSize: 22.0,
//          fontWeight: FontWeight.w600
//        )
//      ),
//      description: Text(description,
//        textAlign: TextAlign.center,
//        style: TextStyle(
//          fontSize: 14.0,
//        )
//      ),
//      onOkButtonPressed: null,
//      onlyOkButton: true,
//      buttonOkColor: Colors.black38,
////      cornerRadius: 0.0,
//      buttonOkText: Text('太慢了，老子不等了', style: TextStyle(color: Colors.white),)
//    );
  }
}

class CloseAppDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  CloseAppDialog({
    Key key,
    this.onConfirm
  }): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AssetGiffyDialog(
      image: Image.asset('static/gifs/360430.gif', fit: BoxFit.cover,),
      title: Text('确定要离开我吗？',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          height: 3.0
        )
      ),
      buttonOkText: Text('残忍离开', style: TextStyle(color: Colors.white),),
      buttonCancelText: Text('哎呀，我开玩笑的呀', style: TextStyle(color: Colors.white),),
      onOkButtonPressed: onConfirm,
    );
  }
}