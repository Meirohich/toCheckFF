// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:to_check/details_page/details_page_widget.dart';
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
  MotorbikesRecord? selectedBike;
  List<bool> isMarkerHovered = [];

  @override
  void initState() {
    _mapController = fmap.MapController();
    isMarkerHovered = List.filled(widget.bikeList!.length, false);
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
        bool isCardVisible = selectedBike == bike;

        return fmap.Marker(
          width: isCardVisible ? 200 : 40,
          height: isCardVisible ? 270 : 20,
          point: point,
          builder: (ctx) => InkWell(
            onTap: () => _onMarkerTapped(bike),
            onHover: (isHovered) {
              setState(() {
                isMarkerHovered[index] = isHovered;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Marker is hovered: $isHovered"),
                  duration:
                      Duration(seconds: 2), // Adjust the duration as needed
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isCardVisible)
                  Positioned(
                    top:
                        0, // Adjust the position as needed to place it on top of the marker
                    child: BikeDetailCard(
                      bike: bike,
                      onClose: () {
                        setState(() {
                          selectedBike = null; // Hide the card
                        });
                      },
                    ),
                  ),
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isMarkerHovered[index] ? Colors.green : Colors.black,
                      width: isMarkerHovered[index] ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: FittedBox(
                    child: Text(
                      '\$${bike.price.toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onMarkerTapped(MotorbikesRecord bike) {
    setState(() {
      if (selectedBike == bike) {
        // If the same bike is tapped again, hide the card
        selectedBike = null;
      } else {
        // Show the card for the tapped marker
        selectedBike = bike;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          fmap.FlutterMap(
            mapController: _mapController,
            options: fmap.MapOptions(
              center: ll.LatLng(55.755793, 37.617134),
              zoom: 5,
              interactiveFlags:
                  fmap.InteractiveFlag.all & ~fmap.InteractiveFlag.rotate,
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
        ],
      ),
    );
  }
}

class BikeDetailCard extends StatelessWidget {
  final MotorbikesRecord bike;
  final VoidCallback onClose;

  const BikeDetailCard({
    super.key,
    required this.bike,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 120,
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(bike.imageUrl, width: 130, height: 80),
              ListTile(
                title: Text(bike.name),
                subtitle: Text(bike.location),
                trailing: Text('\$${bike.price}'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('DETAILS'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DetailsPageWidget(),
                      ));
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
