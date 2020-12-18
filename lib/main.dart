import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.3850, 78.4867),
    zoom: 14.4746,
  );


  MapType mapTye = MapType.normal;
  Set<Marker> markerList=Set();
  Marker currentMArker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMArker=Marker(markerId: MarkerId("1"),position: _kGooglePlex.target);
    markerList.clear();
    markerList.add(currentMArker);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title:Text("Google Maps"),actions: [
        Container(
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.greenAccent,
                  shape: BoxShape.rectangle
              ),
          child: Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: DropdownButton(
              style: TextStyle(color: Colors.black,fontSize: 20,),
                value: mapTye,
                items: [
                  DropdownMenuItem(
                    child: Text("Normal"),
                    value: MapType.normal,
                  ),
                  DropdownMenuItem(
                    child: Text("Hybrid"),
                    value: MapType.hybrid,
                  ),
                  DropdownMenuItem(
                      child: Text("Satellite"),
                      value: MapType.satellite
                  ),
                  DropdownMenuItem(
                      child: Text("Terrain"),
                      value:  MapType.terrain
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    mapTye = value;
                  });
                }),
          ),
        ),
      ],),
      body: GoogleMap(
        mapType: mapTye,
        initialCameraPosition: _kGooglePlex,
        markers: markerList,
        onCameraIdle: (){
          setState(() {
            markerList.clear();
            markerList.add(currentMArker);
            print("Markers $currentMArker");
          });

        },
        onCameraMove: (campposition){
          currentMArker=Marker(markerId: MarkerId("1"),position: campposition.target);


        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Share Location!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
   if(currentMArker==null)
     {
       return;
     }
    Share.share('https://www.google.com/maps/search/?api=1&query=${currentMArker.position.latitude},${currentMArker.position.longitude}');

  }
}
