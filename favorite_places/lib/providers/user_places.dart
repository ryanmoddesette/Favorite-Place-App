//Provider file used to manage the places added by the user
import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart'
    as syspaths; //interfaces to various OS for the filepath locattions/information
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  //utilitiy function to initalize/ receive the database object
  final dbPath = await sql
      .getDatabasesPath(); //returns a future that yields a path to the database on the device
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id Text PRIMARY KEY, title TEXT, image TEXT)');
    },
    version: 1, //keeps track of table configuration whne created
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    //receives place data from the database
    final db = await _getDatabase();
    final data = await db.query(
        'user_places'); //gets all of the places currently in the database
    //returns a future which yields a list of maps
    //every map is one row in the database
    final places = data
        .map(
          //parses the sql data and initializes it as a Place object
          (row) => Place(
            title: row['title'] as String,
            image: File(row['image'] as String),
            id: row['id'] as String,
          ),
        )
        .toList();

    state = places; //updates the provider state to include all of the palces
  }

  void addPlace(String title, File image) async {
    //adds a new place to the provider managed state, by extracting the title of the place
    final appDir = await syspaths
        .getApplicationDocumentsDirectory(); //yields a future that gives a directory object
    final filename =
        path.basename(image.path); //obtains the name of the image file supplied
    final copiedImage = await image.copy(
        //image that was copied to correct path for persistent storage
        '${appDir.path}/$filename'); //copy the image path for persistent storage

    final newPlace = Place(title: title, image: copiedImage);
    //final newPlace = Place(title: title);

    final db = await _getDatabase(); //initialize database

    db.insert('user_places', {
      //inserts data into the database for persistent storage
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    }); //insert actual data into the table
    state = [
      newPlace,
      ...state
    ]; //cannot directly edit the provider managed state, adds a newPlace to the preexisitng state list by creating a new one whilst copying
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  //instantiation of the Provider class to keep track of the places
  (ref) => UserPlacesNotifier(),
);
