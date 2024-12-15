import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

//Widget to representing inputting the location of a user's favorite location
class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Location? _pickedLocation; //stores the picked location from the user
  var _isGettingLocation =
      false; //flag to represent when the location is getting fetched
  //gets the users current location
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled =
        await location.serviceEnabled(); //checks if location service is enabled
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location
        .hasPermission(); //checkls if the app has location permissions
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      //start the spinner when location is getting fetched
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
    });
    print(locationData.latitude);
    print(locationData.longitude);
  }

  void _selectOnMap() {
    //goes to the map screen when you press a button, also takes back the picked location after the user returns from the map screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_isGettingLocation) {
      //updaters UI based on if location is received
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //adds a colored border around the Take Picture Button
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ), //shows preview of place on a map
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location.'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on map.'),
              onPressed: _selectOnMap,
            ),
          ],
        ), //two buttons to use location package to get user's location and other button opens map to go to place manually
      ],
    );
  }
}
