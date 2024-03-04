// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart' as ll;

class OpenStreetMap extends StatefulWidget {
  const OpenStreetMap({
    super.key,
    this.width,
    this.height,
    this.bikeList,
  });

  final double? width;
  final double? height;
  final List<MotorbikesRecord>? bikeList;

  @override
  State<OpenStreetMap> createState() => _OpenStreetMapState();
}

class _OpenStreetMapState extends State<OpenStreetMap> {
  late final fmap.MapController _mapController;

  // List<ll.LatLng> get _mapPoints => [
  //       ll.LatLng(55.755793, 37.617134),
  //       ll.LatLng(55.095960, 38.765519),
  //       ll.LatLng(56.129038, 40.406502),
  //       ll.LatLng(54.513645, 36.261268),
  //       ll.LatLng(54.193122, 37.617177),
  //       ll.LatLng(54.629540, 39.741809),
  //     ];

  // List<fmap.Marker> _getMarkers(List<ll.LatLng> mapPoints) {
  //   return List.generate(
  //     mapPoints.length,
  //     (index) => fmap.Marker(
  //       point: mapPoints[index],
  //       builder: (ctx) => GestureDetector(
  //         onTap: () {},
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(color: Colors.black, width: 1),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.5),
  //                 spreadRadius: 1,
  //                 blurRadius: 2,
  //                 offset: Offset(0, 3),
  //               ),
  //             ],
  //           ),
  //           padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  //           child: FittedBox(
  //             child: Text(
  //               '\$6000',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       width: 40,
  //       height: 20,
  //     ),
  //   );
  // }

  @override
  void initState() {
    _mapController = fmap.MapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  List<fmap.Marker> _getMarkersFromBikeList(List<MotorbikesRecord>? bikeList) {
    if (bikeList == null) return [];

    return List.generate(
      bikeList.length,
      (index) {
        final bike = bikeList[index];
        final point = ll.LatLng(bike.points!.latitude, bike.points!.longitude);

        return fmap.Marker(
          point: point,
          builder: (ctx) => GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: FittedBox(
                child: Text(
                  '\$${bike.price?.toStringAsFixed(2) ?? '0'}', // Assuming price is a double, format to 2 decimal places
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          width: 40,
          height: 20,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fmap.FlutterMap(
        mapController: _mapController,
        options: fmap.MapOptions(
          center: ll.LatLng(55.755793, 37.617134),
          zoom: 5,
        ),
        children: [
          fmap.TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          fmap.MarkerLayer(
            markers: _getMarkersFromBikeList(widget.bikeList),
          ),
        ],
      ),
    );
  }
}
