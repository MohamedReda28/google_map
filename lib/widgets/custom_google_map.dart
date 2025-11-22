import 'package:flutter/material.dart';
import 'package:google_map/utils/location_servece.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:permission_handler/permission_handler.dart' as perm_handler;

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  late LocationServece locationServece;
  bool isFristCall = true;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 17, target: LatLng(31.166464377638103, 31.771104449027494));
    locationServece = LocationServece();
    getLocationAndPermission();
  }

  @override
  void dispose() {
    googleMapController!.dispose();
    super.dispose();
  }

  Set<Marker> markers = {};
  // Set<Polyline>polylines={};
  // Set<Circle>circles={};

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
            // circles: circles,
            markers: markers,
            //   polylines: polylines,
            onMapCreated: (controller) {
              googleMapController = controller;
              initStyleMap();
            },
            // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
            //     southwest: const LatLng(31.109703148504675, 31.659634700054472),
            //     northeast:
            //         const LatLng(31.186429462960977, 31.868366194574648))),
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
    googleMapController!.setMapStyle(newStyle);
  }

  // void initMarker()async {
  //   //var myMarker=const Marker(markerId: MarkerId('1'),position:LatLng(31.16554968266113, 31.763965988925918), );
  //   var markerIcon=await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/images/location.png');
  //   var myTruckMarkers = Marker(
  //       markerId: const MarkerId('1'),
  //           position: getLocationData(),
  //   );
  //   markers.add(myTruckMarkers);
  //   setState(() {
  //
  //   });
  // }

  void getLocationAndPermission() async {
    await locationServece.checkAndRequestLocationService();
    if (await locationServece.checkAndRequestPermissionLocation()) {
      locationServece.getRealTimeLocationData((locationData) async {
        setCameraPossion(locationData);
        await setMaylocationMarker(locationData);
      });
    } else {}
  }

  Future<void> setMaylocationMarker(LocationData locationData) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/images/location.png');

    var myMarker = Marker(
        icon: markerIcon,
        markerId: const MarkerId('1'),
        position: LatLng(locationData.latitude!, locationData.longitude!));

    markers.add(myMarker);
    setState(() {});
  }

  void setCameraPossion(LocationData locationData) {
    if (isFristCall) {
      CameraPosition newCameraPossion = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 17);
      googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(newCameraPossion));
     isFristCall=false;
    } else {
      googleMapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }
}
