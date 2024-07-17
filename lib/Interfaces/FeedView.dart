import 'package:firestream/Controllers/FeedController.dart';
import 'package:firestream/Modules/Styler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FeedView extends StatelessWidget {
  FeedView({super.key});
  final styler = Styler();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(
        init: FeedController(),
        id: "FeedView",
        builder: (controller) {
          return Scaffold(
            body: Container(
              decoration: styler.orangeBlueBackground(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: controller.initFeed(),
                      builder: (context,snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting)return CircularProgressIndicator();
                        if(snapshot.hasError) return Text(snapshot.error.toString());
                        return GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Video(controller: controller.videoController,
                                pauseUponEnteringBackgroundMode: false,

                              )
                          ),
                        );
                      }
                  )
                ],
              ),
            ),
          );
        });
  }
}
