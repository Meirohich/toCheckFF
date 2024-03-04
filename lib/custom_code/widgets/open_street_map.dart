// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:toCheck/detailspage.dart';
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
            onTap: () {
              showDialog(
                context: ctx,
                builder: (BuildContext context) {
                  return Dialog(
                    child: BikeDetailCard(bike: bikeList[index]),
                  );
                },
              );
            },
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
                  '\$${bike.price.toString()}',
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

class BikeDetailCard extends StatelessWidget {
  final MotorbikesRecord bike;

  const BikeDetailCard({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.network(
              bike.imageUrl), // Assuming the bike object has an imageUrl field
          ListTile(
            title: Text(bike.name), // Assuming the bike object has a name field
            subtitle: Text(bike.points
                as String), // Use the appropriate field for location
            trailing: Text('\$${bike.price}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: Text('DETAILS'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailsPage(
                        bike:
                            bike), // Assuming you have a DetailsPage that takes a bike object
                  ));
                },
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
