import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/marker_model.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 17, target: LatLng(31.166464377638103, 31.771104449027494));
   // initMarker();
   // initPolylines();
    initCircles();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  Set<Marker> markers = {};
  Set<Polyline>polylines={};
  Set<Circle>circles={};


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          // mapType: MapType.satellite,
          //لو عايز تشيل +- بتوع الزووم
          //zoomControlsEnabled: false,
          //لو عايز توقف امكانيه الزوم من خلال الشاشه الا هي الطتش
          //zoomGesturesEnabled:false ,
          circles: circles,
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) {
              googleMapController = controller;
              initStyleMap();
            },
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                southwest: const LatLng(31.109703148504675, 31.659634700054472),
                northeast:
                    const LatLng(31.186429462960977, 31.868366194574648))),
            initialCameraPosition: initialCameraPosition),
        // Positioned(
        //   bottom: 5,
        //   left: 5,
        //   right: 5,
        //   child: ElevatedButton(
        //       onPressed: () {
        //         googleMapController.animateCamera(CameraUpdate.newLatLng(
        //             const LatLng(31.040643781341096, 31.378671860289113)));
        //
        //       },
        //       child: const Text('update map')),
        // )
      ],
    );
  }

  void initStyleMap() async {
    var newStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/map_style_light.json');
    googleMapController.setMapStyle(newStyle);
  }

  void initMarker()async {
    //var myMarker=const Marker(markerId: MarkerId('1'),position:LatLng(31.16554968266113, 31.763965988925918), );
    var markerIcon=await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/images/location.png');
    var myMarkers = markerList
        .map((markerModel) => Marker(
      icon: markerIcon,
            markerId: MarkerId(markerModel.id.toString()),
            position: markerModel.latLng,
            infoWindow: InfoWindow(title: markerModel.name)))
        .toSet();
    markers.addAll(myMarkers);
    setState(() {

    });
  }

  void initPolylines() {
    Polyline polyline = const Polyline(
      color: Colors.blue,
        width: 10,
        //عشان اطراف الخط متكونش حاده يكون فيها كرف
        startCap: Cap.roundCap,
        polylineId: PolylineId('1'),
        points:[
          LatLng(31.166482094785135, 31.771126196149346),
          LatLng(31.165326682719307, 31.771449036813646),
          LatLng(31.165372036457164, 31.771729841591537),
          LatLng(31.165602664704288, 31.771739991165553),
        ]
    );
    polylines.add(polyline);
  }

  void initCircles() {
    Circle circle =  Circle(circleId: const CircleId('1'),
      fillColor: Colors.black.withOpacity(.5),
      strokeColor: Colors.black.withOpacity(.5),
      radius: 5000,
      center: const LatLng(31.166871251794937, 31.77234764152659),
    );
    circles.add(circle);
  }
}
