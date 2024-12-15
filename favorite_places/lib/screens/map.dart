//shows the google map

import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    //default place location value to be displayed
    super.key,
    this.location =
        const PlaceLocation(latitude: 37, longitude: -120, address: 'ddress'),
    this.isSelecting = true,
  });
  final PlaceLocation location;
  final bool
      isSelecting; //keep track of if a user is selecting a new location or not

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting
            ? 'Pick Your Location'
            : 'Your Location'), //displays a different title based on if the user is selecting a location or displaying a preselected location
        actions: [
          if (widget
              .isSelecting) //displays a save button if the user is selecting a new location
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {},
            )
        ],
      ),
      body: const Text('Google Map xD'),
    );
  }
}
