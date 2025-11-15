import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel
{
  final int id;
  final String name;
  final LatLng latLng;

  MarkerModel({required this.id, required this.name, required this.latLng});

}

List<MarkerModel>markerList = [
  MarkerModel(id:1 , name: 'شارع الاستاذ رضا صبح', latLng:const LatLng(31.16540153584782, 31.771726894322324)),
  MarkerModel(id:2 , name: 'حي الاستاذ رضا صبح', latLng:const LatLng(31.166377940219412, 31.771173059082393)),

];