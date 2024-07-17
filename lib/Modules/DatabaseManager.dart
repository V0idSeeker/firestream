import 'package:firestream/Modules/Channel.dart';
import 'package:firestream/Modules/Feed.dart';
import 'package:firestream/Modules/Raport.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseManager{
  static late Uri url;
  static String ip = "192.168.1.111";
  static Database? _database;
  DatabaseManager() {
    //for local

    url = Uri.http(ip, "api/index.php");
  }
  Future<Database?> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    sqfliteFfiInit();

    final databaseFactory = databaseFactoryFfi;
    final appDocumentsDir =  await getApplicationSupportDirectory();
    final dbPath = [appDocumentsDir.path, "data.db"].join();
    print(dbPath);
    final winLinuxDB = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
    return winLinuxDB;
  }
  Future<void> _onCreate(Database database, int version) async {
    final db = database;


    await db.execute("""
            CREATE TABLE IF NOT EXISTS "Accounts"(
            AccountId INTEGER PRIMARY KEY NOT NULL,
            UserName VARCHAR(20),
            Password VARCHAR(20),
            PhoneNumber INTEGER
          );
          Create Table if not exists "Feeds"(
          FeedId INTEGER PRIMARY KEY NOT NULL ,
          UserName VARCHAR(20),
          Password VARCHAR(20),
          FeedName VARCHAR(30),
          Ip VARCHAR(18),
          Port INTEGER ,
          OwnerId INTEGER
          );
          Create Table if not exists "Channels"(
          ChannelId INTEGER PRIMARY KEY NOT NULL,
          ChannelName VARCHAR(30),
          FeedId INTEGER,
          ChannelValue INTEGER,
          AlertSensitivity INTEGER DEFAULT 80,
          Lat DOUBLE,
          Long DOUBLE,
          FOREIGN KEY (FeedId) REFERENCES Feeds(FeedId) ON DELETE CASCADE
          );

          Create Table if not exists "Logs"(
          LogId INTEGER PRIMARY KEY NOT NULL,
          FeedId INTEGER,
          ChannelValue INTEGER,
          ReportStatus VARCHAR(10) ,
          timestamp DATETIME
          );


                  """);
    await db.execute("insert into 'Accounts' (Username , Password) values ('admin','admin')");


  }

  Future<bool> connectionStatus() async {
    bool f;

    try {
      print("dcfsdfsdf $url");
      var response = await post(url, body: {
        "command": "connectionStatus",
      }).timeout(Duration(milliseconds: 500));
      print(response.statusCode);
      if (response.statusCode == 200)
        f = true;
      else
        f = false;
    } catch (e) {
      f = false;
    }

    return f;
  }

  void setIp(String newIp) {
    print("old ip is : $url");
    ip = newIp;
    url = Uri.http(ip, "api/index.php");
    print("new ip is : $url");
  }

  Future addAccount(String username, String password, int? phoneNumber) async{
    await database;
    phoneNumber==null ?
    await _database?.rawQuery("insert into 'Accounts'(Username , Password)  values (?,?) ",[username,password])
        :await _database?.rawQuery("insert into 'Accounts'(Username , Password,PhoneNumber)  values (?,?,?) ",[username,password,phoneNumber]);

  }
  Future editAccount(int id,String username, String password, int phoneNumber) async{
    await database;
    await _database?.rawUpdate("Update 'Accounts' Set Username= ? , Password=? , PhoneNumber=? , where  AccountId= ? ",[username,password,phoneNumber,id]);

  }
  Future addStream(Feed feed)async{
    await database;
    int? feedId= await _database?.rawInsert("insert into 'Feeds'(UserName , Password, FeedName , Ip , Port , OwnerId)  values (?,?,?,?,?,?) ",[feed.userName,feed.password,feed.feedName,feed.ip,feed.port,feed.ownerId]);

    for(var i=0;i<feed.channels.length;i++){
    await addChannel( feedId!,feed.channels[i]);
    }
  }
  Future editStream(Feed feed)async{
    await database;
    await _database?.rawUpdate("Update 'Feeds' Set Username= ? , Password=? , FeedName=? , Ip=? , Port=? where  FeedId= ? ",[feed.userName,feed.password,feed.feedName,feed.ip,feed.port,feed.feedId]);
  }
  Future removeStream(int streamId)async{
    await database;
    //await _database?.rawDelete("delete from 'Channels' where FeedId=?",[streamId]);
    await _database?.rawDelete("delete from 'Feeds' where FeedId=?",[streamId]);
  }

  Future<List<Feed>> getStreams(int ownerId)async{
    await database;

    List<Map<String, Object?>>? results = await _database?.rawQuery("Select * from 'Feeds' where OwnerId=? ",[ownerId]);

    if (results == null) return [];
    List<Feed> feeds=[];
    for(int i=0; i<results.length;i++){
      List<Channel> tmp=await getChannels(int.parse(results[i]["FeedId"].toString()));
      List<Map<String, dynamic>> channels=[];

      if(tmp.isNotEmpty)
      for(var e in tmp){
        channels.add(e.toMap());
      }
      Map<String,dynamic> v={};

      v.addAll(results[i]);
      v.addAll({"Channels":channels});
     feeds.add(Feed.fromMap(v));

    }




  return feeds;

  }

  //TODO:channels
  Future<List<Channel>> getChannels(int feedId)async{


    await database;

    List<Map<String, dynamic>>? results= await _database?.rawQuery("Select * from 'Channels' where FeedId=? ",[feedId]);

    if(results==null)return [];
    List<Channel> channels = results.map((e)=>Channel.fromMap(e)).toList();
    return channels ;
  }
  Future removeChannel(int channelId)async{
    await database;
    await _database?.rawDelete("delete from 'Channels' where ChannelId=?",[channelId]);
  }
  Future addChannel(int  feedId, Channel channel)async{
    await database;
    await _database?.rawInsert("""insert into 'Channels'(FeedId ,ChannelName, ChannelValue , AlertSensitivity , Lat , Long)  values (?,?,?,?,?,?) """,
        [ feedId,channel.channelName,channel.channelValue,channel.alertSensitivity,channel.lat,channel.long]);
  }
  Future updateChannel(Channel channel)async{
    await database;
    await _database?.rawUpdate("""Update 'Channels' Set ChannelValue=? , ChannelName=?, AlertSensitivity=? , Lat=? , Long=?  where  ChannelId= ? """,
        [channel.channelValue,channel.channelName,channel.alertSensitivity,channel.lat,channel.long,channel.channelId]);
  }






  Future<bool> sendReport(Report report) async {
    var request = MultipartRequest('POST', url);
    //attaching data to the request
    report.toMap().forEach((key, value) async {
      request.fields["command"] = "addReport";
      //if its a file
      if (key == "resourcePath" || key == "audioPath") {
        if (value != null)
          request.files.add(
            await MultipartFile.fromPath(
              key,
              value,
            ),
          );
      }
      //if its normal data

      else
        request.fields[key] = value.toString();
    });
    // Add the image file to the request

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await Response.fromStream(streamedResponse);

      // Check if the upload was successful
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }

    return true;
  }

}