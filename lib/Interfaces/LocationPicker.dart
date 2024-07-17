import 'package:firestream/Controllers/LocationPickerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_location_picker/open_location_picker.dart';

import '../Modules/Styler.dart';

class  LocationPicker extends StatelessWidget {
   LocationPicker({super.key});
  final styler =Styler();
  @override
  Widget build(BuildContext context) {
    return  GetBuilder< LocationPickerController>(
        init:  LocationPickerController(),
        id: "LocationPickerInterface",
        builder: (controller){
          return Scaffold(
            body: Container(
              decoration: styler.orangeBlueBackground(),
              child: Center(
                child: OpenMapPicker(
                  initialValue: FormattedLocation.fromLatLng(lat: 36.733969197575064, lon:  3.232971603447732),
                  decoration: const InputDecoration(hintText: "My location"),
                  onChanged: (FormattedLocation? newValue) {
                    if(newValue!=null)

                      print(" values :${newValue.address.city} ${newValue.lat.toString()} , ${newValue.lon.toString()}");
                    /// save new value
                  },
                ),
              ),
            ),
          );
        }
    );
  }
}
