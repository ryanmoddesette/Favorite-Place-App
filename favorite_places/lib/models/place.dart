//blueprint for place objects
//ids are to be auto generated
import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid(); //utility object for generating unique ids

class PlaceLocation {
  //represents the model of the location fetched by the Google maps API
  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({
    required this.title,
    required this.image,
    String? id,
  }) : id = id ??
            uuid.v4(); //id field is generated outside of the immediate constructor via uuid if not supplied by the user
  final String id;
  final String title;
  final File image;
}
