import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Mappage extends StatefulWidget {
  const Mappage({Key? key}) : super(key: key);

  @override
  _MappageState createState() => _MappageState();
}

class _MappageState extends State<Mappage> {

  final  Completer<GoogleMapController> _controller=Completer();

  static const LatLng sourceLocation=LatLng(37.4221, -122.0841);
  static const LatLng destinationLocation=LatLng(37.4116, -122.0713);

  //for polylines
  List<LatLng> polylineCoordinates = [];
  void getPolipoint()async{
    PolylinePoints polylinePoints=PolylinePoints();

    PolylineResult result=await polylinePoints.getRouteBetweenCoordinates(
      "Google api",
      PointLatLng(sourceLocation.latitude,sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
      travelMode: TravelMode.driving
    );

    if(result.points.isNotEmpty){

      result.points.forEach(
              (PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude))
      );
      setState(() {

      });
    }
  }
  //for polylines

  //device location
  LocationData? currentLocation;
  void getcureentLocation() async{
    Location location=Location();
    location.getLocation().then((value) {
      currentLocation=value;
    });
    GoogleMapController googleMapController=await _controller.future;

    //location on change
    location.onLocationChanged.listen((event) {
      currentLocation=event;
      googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(zoom: 16.5,target: LatLng(event.latitude!,event.longitude!))));
      setState(() {

      });
    });

  }
  //custiom marker
  BitmapDescriptor sourceIcon=BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon=BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon=BitmapDescriptor.defaultMarker;

 void setCustomMarkerIcon(){
      BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "asset/pin_cource.pngh").then((value){
        sourceIcon=value;
      });BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "asset/pin_cource.pngh").then((value){
        destinationIcon=value;
      });BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "asset/pin_cource.pngh").then((value){
        currentIcon=value;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcureentLocation();
    getPolipoint();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: currentLocation == null?const Center(child: Text("loading....")): GoogleMap(
        initialCameraPosition:  CameraPosition(target: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),zoom: 16.5),
        markers: {
            Marker(
              markerId: MarkerId("source"),
              position: sourceLocation,
             icon: sourceIcon
          ),
           Marker(
              markerId: MarkerId("destination"),
              position: destinationLocation,
               icon: destinationIcon
          ),
           Marker(
              markerId: const MarkerId("current"),
              position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
               icon: currentIcon
          ),
        },
        polylines:{
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.deepPurpleAccent,
            width: 6
          )
        },
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },
      )
    );
  }
}
