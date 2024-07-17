import 'package:firestream/Modules/DatabaseManager.dart';
import 'package:firestream/Modules/Feed.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';


class GlobalController extends GetxController {
  late DatabaseManager databaseManager=DatabaseManager();
  int ownerId=1;
  List<Feed>streams=[];
  late VideoController videoController;
  List<int> media=[1,2,3];

  @override
  Future<void> onInit() async {

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> buildStream() async {

   streams=await  databaseManager.getStreams(ownerId);
   print("streams are : $streams");
   update(["FeedsList"]);


  }

  void switchFeed(int index){
    //player.jump(index);
  }
  Future<bool> addFeed(Feed feed)async {
    feed.ownerId=ownerId;

    await databaseManager.addStream(feed);
    update(["FeedsList","FeedView"]);
    return true;
  }
  Future deleteFeed(int feedId)async {
    await databaseManager.removeStream(feedId);
    update(["FeedsList","FeedView"]);

  }

}
