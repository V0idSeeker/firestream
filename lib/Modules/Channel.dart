import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class Channel{
late int channelId,feedId,channelValue,alertSensitivity;
late double lat,long;
String channelName="";
late VideoController channelController;
late Player channelPlayer;

Channel();
Channel.fromMap(Map<String,dynamic>map){
  channelName=map["ChannelName"].toString();
  channelId=int.parse(map["ChannelId"].toString());
  feedId=int.parse(map['FeedId'].toString());
  channelValue=int.parse(map['ChannelValue'].toString());
  alertSensitivity=int.parse(map['AlertSensitivity'].toString());
  lat=double.parse(map['Lat'].toString());
  long=double.parse(map['Long'].toString());
  channelPlayer=Player();
  channelController=VideoController(channelPlayer);
}


VideoController getChannelController(String feed){
  channelPlayer.open(Media("$feed?channel=$channelValue"));
  return channelController;
}

toMap(){
  return {
    "FeedId":feedId,
    "ChannelId":channelId,
    "ChannelName":channelName,
    "ChannelValue":channelValue ,
    "AlertSensitivity" :alertSensitivity,
    "Lat":lat,
    "Long":long,
  };
}
@override
  String toString() {

    return """{
    "ChannelId":$channelId,
    "ChannelName":$channelName,
    "ChannelValue":$channelValue ,
    "AlertSensitivity" :$alertSensitivity,
    "Lat":$lat,
    "Long":$long,
    
  }""";
  }



}