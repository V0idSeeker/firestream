
import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FeedController extends GetxController{
  final player = Player();
  late VideoController videoController ;
@override
  Future<void> onInit() async {
  super.onInit();


}

@override
  void onClose() {
  player.dispose();
    super.onClose();
  }

  Future<void> initFeed()async{
    await player.open(Media('asset:///assets/sample.mp4') ,play: true);


    //await player.open(Media('rtsp://admin:admin@192.168.1.3:1935') ,play: true);
    videoController= VideoController(player);
    Timer.periodic(Duration(seconds: 1), (timer) async{
     Uint8List?image= await videoController.player.screenshot(format: "image/jpeg");

     print(image.toString().length);

    });





  }
}