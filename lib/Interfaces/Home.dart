import 'package:firestream/Controllers/GlobalController.dart';
import 'package:firestream/Interfaces/AddFeed.dart';
import 'package:firestream/Modules/Styler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';


class Home extends StatelessWidget {
  Home({super.key});
  final styler = Styler();
  @override
  Widget build(BuildContext context) {

    return GetBuilder<GlobalController>(
        init: GlobalController(),
        builder: (controller) {
          return Scaffold(
            body: Container(
              decoration: styler.orangeBlueBackground(),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.all(16.0),
                  decoration: styler.containerDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GetBuilder<GlobalController>(
                                  id: "FeedView",
                                  builder: (controller){

                                    return Card(
                                      child: FutureBuilder(
                                          future: controller.buildStream(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting)
                                              return CircularProgressIndicator();
                                            if (snapshot.hasError) return Text(snapshot.error.toString());
                                            if(controller.streams.isEmpty)
                                              return Container(
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context).size.height / 2,
                                                child: Text("No Live Feeds"),);

                                            return SizedBox(
                                                height: MediaQuery.of(context).size.height / 2,
                                                child:  Video(
                                                    pauseUponEnteringBackgroundMode: false,
                                                    controller: controller.streams[0].channels[0].channelController,
                                                    controls: (state) {
                                                      return Center();}

                                                ));
                                          }),
                                    );
                                  }),
                              Card(
                                child: Text("Logs"),
                              ),
                            ],
                          )),
                      SizedBox(width: 30),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                   Get.to(()=>AddFeed());
                                  },
                                  child: Icon(Icons.video_call_outlined)),
                              ElevatedButton(
                                  onPressed: () {}, child: Icon(Icons.settings))
                            ],
                          ),
                          Card(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width / 4,
                              child: GetBuilder<GlobalController>(
                                id: "FeedsList",
                                builder: (controller){
                                  print("list is rebuilt \n ");
                                  return ListView.separated(
                                    separatorBuilder: (context,index)=>Divider(),
                                    itemCount: controller.streams.length,
                                    itemBuilder: (context,index){
                                      print("index $index");
                                      return ListTile(
                                        title: Text("Feed ${controller.streams[index].feedId}"),
                                        subtitle: Text("Ip: ${controller.streams[index].ip}:${controller.streams[index].port}"),
                                        trailing: ElevatedButton(
                                          onPressed: (){
                                            controller.deleteFeed(controller.streams[index].feedId);
                                          },
                                          style:styler.elevatedButtonStyle() ,
                                          child: Icon(Icons.delete),
                                        ),
                                        onTap: (){
                                          controller.switchFeed(index);
                                        },
                                      );
                                    },

                                  );
                                },
                              ),
                            ),
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }





}
