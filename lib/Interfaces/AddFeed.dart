import 'package:firestream/Controllers/GlobalController.dart';
import 'package:firestream/Modules/Channel.dart';
import 'package:firestream/Modules/Feed.dart';
import 'package:firestream/Modules/Styler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_location_picker/open_location_picker.dart';

class AddFeed extends StatelessWidget {
  AddFeed({super.key});
  final styler = Styler();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
        id: "AddFeedForm",
        builder: (controller) {
          final formKey = GlobalKey<FormState>();
          TextEditingController channelsCount =
              TextEditingController(text: "1");
          Feed feed = Feed();

          return Scaffold(
            body: Container(
              decoration: styler.orangeBlueBackground(),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: styler.containerDecoration(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration:
                              styler.inputFormTextFieldDecoration("Feed Name"),
                          validator: (value) {
                            if (value == null) return "Must fill this field";
                            feed.feedName = value.toString();
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  decoration:
                                      styler.inputFormTextFieldDecoration(
                                          "Feed Username:"),
                                  validator: (value) {
                                    if (value.toString().contains(" "))
                                      return "Invalid username";

                                    feed.userName = value.toString();
                                    return null;
                                  },
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                decoration: styler.inputFormTextFieldDecoration(
                                    "Feed Password:"),
                                validator: (value) {
                                  if (value == null)
                                    return "Must fill this field";
                                  if (value.toString().contains(" "))
                                    return "Invalid password";
                                  feed.password = value.toString();
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: TextFormField(
                                  decoration:
                                      styler.inputFormTextFieldDecoration(
                                          "Ip Address:"),
                                  validator: (value) {
                                    if (!RegExp(
                                            r'\b((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\b')
                                        .hasMatch(value.toString()))
                                      return "Invalid ip address";
                                    feed.ip = value.toString();
                                    return null;
                                  },
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: TextFormField(
                                  decoration: styler
                                      .inputFormTextFieldDecoration("Port:"),
                                  validator: (value) {
                                    if (value == null ||
                                        int.tryParse(value) == null)
                                      return "Invalid Port";
                                    feed.port = int.parse(value.toString());
                                    return null;
                                  },
                                ))
                          ],
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              controller: channelsCount,
                              decoration: styler.inputFormTextFieldDecoration(
                                  "Channels Count:"),
                              onEditingComplete: () {
                                if (int.tryParse(channelsCount.text) == null)
                                  channelsCount.text = "0";
                                controller.update(["Channels List"]);
                              },
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: styler.containerDecoration(),
                            child: GetBuilder<GlobalController>(
                                id: "Channels List",
                                builder: (controller) {
                                  feed.channels = [];
                                  return ListView.separated(
                                    itemCount: int.parse(channelsCount.text),
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey.shade900,
                                    ),
                                    itemBuilder: (context, index) {
                                      feed.channels.add(Channel());
                                      return Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    child: TextFormField(
                                                      decoration: styler
                                                          .inputFormTextFieldDecoration(
                                                              "Channel Name:"),
                                                      validator: (value) {
                                                        feed.channels[index]
                                                                .channelName =
                                                            value.toString();
                                                        return;
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    child: TextFormField(
                                                      decoration: styler
                                                          .inputFormTextFieldDecoration(
                                                              "Channel Value:"),
                                                      validator: (value) {
                                                        feed.channels[index]
                                                                .channelValue =
                                                            int.parse(value
                                                                .toString());
                                                        return;
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    child:
                                                        DropdownButtonFormField(
                                                      value: 60,
                                                      items: [
                                                        DropdownMenuItem(
                                                            value: 40,
                                                            child: Text(
                                                                'High 40%')),
                                                        DropdownMenuItem(
                                                            value: 60,
                                                            child: Text(
                                                                'Medium 60%')),
                                                        DropdownMenuItem(
                                                            value: 80,
                                                            child: Text(
                                                                'Low 80%')),
                                                      ],
                                                      onChanged: (value) {},
                                                      decoration: styler
                                                          .inputFormTextFieldDecoration(
                                                              "Alert Sensitivity:"),
                                                      validator: (value) {
                                                        feed.channels[index]
                                                                .alertSensitivity =
                                                            int.parse(value
                                                                .toString());
                                                        return;
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              child: OpenMapPicker(
                                                options: OpenMapOptions(
                                                  zoom: 10,
                                                  center: LatLng(
                                                      36.73378568677156,
                                                      3.087112267625266),
                                                ),
                                                decoration: styler
                                                    .inputFormTextFieldDecoration(
                                                        "My Location"),
                                                onChanged: (FormattedLocation?
                                                    newValue) {
                                                  if (newValue != null)
                                                    print(
                                                        " values :${newValue.address.city} ${newValue.lat.toString()} , ${newValue.lon.toString()}");

                                                  /// save new value
                                                },
                                                validator: (value) {
                                                  if (value == null) return;

                                                  feed.channels[index].lat =
                                                      value.lat;
                                                  feed.channels[index].long =
                                                      value.lon;
                                                  return;
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                })),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: ()async{
                            if (!formKey.currentState!.validate()) {

                              return;
                            }
                              await controller.addFeed(feed);
                            Get.back();
                            controller.update(["Home"]);

                            styler.showSnackBar("Success ", "Feed added");



                          },
                              style: styler.elevatedButtonStyle(),
                              child: Text("Submit")),
                          ElevatedButton(onPressed: ()=>Get.back(),
                              style: styler.elevatedButtonStyle(),
                              child: Text("Return"))
                        ],
                      )

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
