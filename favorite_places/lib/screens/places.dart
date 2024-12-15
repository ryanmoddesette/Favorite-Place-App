//list screen which shows all the possible places

import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref
        .read(userPlacesProvider.notifier)
        .loadPlaces(); //utilizes the provider function loadPlaces to supply a future to the future builder
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userPlaces = ref.watch(
        userPlacesProvider); //watches whenever the provider managed state changes and gives access to it in the assigned variable
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      const AddPlaceScreen(), //on pushing the add button navigates to the AddPlaceScreen
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            //loads either a loading spinner or the places list
            future: _placesFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : PlacesList(places: userPlaces),
          )),
    );
  }
}
