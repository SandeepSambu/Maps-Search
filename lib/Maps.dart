import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_search/Details.dart';
import 'package:maps_search/Location.dart';

class Maps extends StatefulWidget {
  final String location;
  final List<dynamic> latLng;
  final Map<String, dynamic> markers;
  final Function changeWidth;

  const Maps({
    super.key,
    required this.latLng,
    required this.location,
    required this.markers,
    required this.changeWidth
  });

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController mapController;

  late LatLng _center;

  final Map<String, Marker> _markers = {};

  late List<String> loc;

  late List<dynamic> latLng;

  var expanded = true;

  @override
  void initState() {
    super.initState();
    loc = widget.markers.keys.toList();
    latLng = widget.markers.values.toList();
  }

  void _navigateToDetails(String location) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Details(location: location)));
  }

  LatLng center() {
    _center = LatLng(widget.latLng[0], widget.latLng[1]);
    return _center;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.clear();
      widget.markers.forEach((location, coordinates) {
        final marker = Marker(
          markerId: MarkerId(location),
          position: LatLng(coordinates[0], coordinates[1]),
          infoWindow: InfoWindow(
            title: kIsWasm ? location : "",
            snippet: kIsWasm ? "Welcome to $location" : "",
          ),
          onTap: () {
            if(!kIsWasm) {
              _navigateToDetails(location);
            }
          },
        );
        _markers[location] = marker;
      });
    });
  }

  @override
  void didUpdateWidget(covariant Maps oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.latLng != widget.latLng) {
      _updateCameraPosition();
    }
  }

  void _updateCameraPosition() {
    final newCenter = LatLng(widget.latLng[0], widget.latLng[1]);
    mapController.animateCamera(CameraUpdate.newLatLng(newCenter));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Maps"),
          leading: kIsWasm
              ? IconButton(
                  onPressed: () {
                    widget.changeWidth();
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  icon: expanded
                      ? const Icon(Icons.fullscreen)
                      : const Icon(Icons.fullscreen_exit)
              )
              : null,
          elevation: 3,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center(),
            zoom: 8.0
          ),
          markers: _markers.values.toSet(),
        ),
        persistentFooterButtons: [
          kIsWasm
              ? const SizedBox()
              : Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                         onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Locations(
                                markers: widget.markers,
                                selectedLocation: const [15.8281, 78.0373],
                                changeWidth: widget.changeWidth,
                              ))
                          );
                        },
                        child: const Text("Locations")
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Details")
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}