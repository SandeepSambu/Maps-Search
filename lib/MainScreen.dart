import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:maps_search/Location.dart';
import 'package:maps_search/Maps.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Map<String, dynamic> markers = {"Kurnool" : [15.8281, 78.0373], "Bangalore" : [12.9716, 77.5946], "Hyderabad" : [17.4065, 78.4772]};

  List<dynamic> selectedLocation = [15.8281, 78.0373];

  var width = false;

  void updateLocation(List<dynamic> newLocation) {
    setState(() {
      selectedLocation = newLocation;
    });
  }

  void changeWidth() {
    setState(() {
      width = !width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        kIsWasm
            ? SizedBox(
                width: MediaQuery.of(context).size.width * (width ? 0 : 0.3),
                child: Locations(
                  markers: markers,
                  onLocationSelected: updateLocation,
                  selectedLocation: selectedLocation,
                  changeWidth: changeWidth,
                ),
              )
            : const SizedBox(),
        SizedBox(
          width: kIsWasm ? MediaQuery.of(context).size.width * (width ? 1 : 0.7) : MediaQuery.of(context).size.width,
          child: Maps(
            latLng: selectedLocation,
            location: 'India',
            markers: markers,
            changeWidth: changeWidth,
          ),
        )
      ],
    );
  }
}