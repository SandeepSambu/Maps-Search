import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maps_search/Maps.dart';

class Locations extends StatefulWidget {
  final Map<String, dynamic> markers;
  final Function(List<dynamic>)? onLocationSelected;
  final List<dynamic> selectedLocation;
  final Function changeWidth;

  const Locations({
    super.key,
    required this.markers,
    this.onLocationSelected,
    required this.selectedLocation,
    required this.changeWidth
  });

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  late List<String> locations;
  late List<dynamic> latLng;

  @override
  void initState() {
    super.initState();
    locations = widget.markers.keys.toList();
    latLng = widget.markers.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locations"),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(locations[index]),
                onTap: () {
                  kIsWasm
                      ? widget.onLocationSelected!(latLng[index])
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Maps(
                              location : locations[index],
                              latLng: latLng[index],
                              markers: widget.markers,
                              changeWidth: widget.changeWidth,
                            ),
                          ),
                        );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}