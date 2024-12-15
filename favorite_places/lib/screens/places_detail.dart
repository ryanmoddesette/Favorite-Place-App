//screen which will show the details of a selected place

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          //stack that shows place details
          Image.file(place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Positioned(
            //shows a preview of the location on a map, if the API woprked lol
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                    //if you tap on the circle it displays a map
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const MapScreen(
                              isSelecting:
                                  false //the user has already selected a location at this point in the Flow,
                              ),
                        ),
                      );
                    },
                    child: const CircleAvatar()),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    //adds background behind the text
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                  child: const Text(
                    'Location Placeholder',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ) //stack that shows the Map preview of the palce
        ],
      ),
    );
  }
}
