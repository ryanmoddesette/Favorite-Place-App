//screen displayed to add a new place

import 'dart:io';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController =
      TextEditingController(); //controller for title text field input
  File? _selectedImage;

  void _savePlace() {
    //extract the text entered by the user and add it to the provider managed state list
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty || _selectedImage == null) {
      // sanity testing for the user input
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(
        enteredTitle, _selectedImage!); //instantiates the user places provider
    Navigator.of(context).pop(); //leave the add places screen
  }

  @override //dispose the controller method when it is not being used
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new Place'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage =
                      image; //gets the selectedimage from the passed in function call
                },
              ), //image input (use the phone's camera)
              const SizedBox(
                height: 10,
              ),
              const LocationInput(),
              const SizedBox(height: 16), //spacing
              ElevatedButton.icon(
                //button to actualy add the place
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ), //Text field to enter a title for the new place
            ],
          ),
        ) //column of different fields to be inputed
        );
  }
}
