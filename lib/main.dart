import 'package:flutter/material.dart';
import 'package:google_map/widgets/custom_google_map.dart';

void main() {
  runApp(const GoogleMapTest());
}
class GoogleMapTest extends StatelessWidget {
  const GoogleMapTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomGoogleMap(),
    );
  }
}

