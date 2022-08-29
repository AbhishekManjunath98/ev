import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapType type = MapType.normal;
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(12.971599, 77.594566), zoom: 11.5);
  Marker? origin;
  Marker? destination;
  GoogleMapController? _googleMapController;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (origin != null)
            TextButton(
                onPressed: () => _googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: origin!.position, zoom: 14.5, tilt: 50))),
                child: Text('origin')),
        ],
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        onLongPress: addMarker,
        onMapCreated: (controller) => _googleMapController = controller,
        mapType: type,
        initialCameraPosition: _initialCameraPosition,
        markers: {
          if (origin != null) origin!,
          if (destination != null) destination!,
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition)),
      ),
    );
  }

  void addMarker(LatLng pos) {
    if (origin == null || (origin != null && destination != null)) {
      setState(() {
        origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'origin'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
        destination = null;
      });
    } else {
      setState(() {
        destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'destination'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: pos);
      });
    }
  }
}
