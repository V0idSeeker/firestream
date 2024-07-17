import 'dart:async';

import 'package:firestream/Modules/Channel.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class Feed{

  Player player=Player();
  late VideoController mainController;

  late int feedId,port,ownerId;
  late String userName,password,ip,feedName="";
  List<Channel> channels=[];

  Feed();
  Feed.fromMap(Map<String , dynamic>map){
    feedName=map["FeedName"].toString();
    feedId=int.parse(map["FeedId"].toString());
    port=int.parse(map["Port"].toString());
    ownerId=int.parse(map["OwnerId"].toString());
    userName=map["UserName"].toString();
    password=map["Password"].toString();
    ip=map["Ip"].toString();
    channels=(map["Channels"] as List<dynamic>).map((e)=>Channel.fromMap(e)).toList();
    mainController=VideoController(getFeedPlayer());



  }
  String feedUrl()=>"rtsp://$userName:$password@$ip:$port";
  Player getFeedPlayer(){
    player.open(Media(feedUrl()));
    return player;
  }
  void dispose(){
    player.dispose();

  }



  @override
  String toString() {

    return """{
    FeedId :$feedId,UserName :$userName, Password :$password, FeedName : $feedName,Ip :$ip ,Port:$port , Channels:{${channels.length}
    }""";
  }




}