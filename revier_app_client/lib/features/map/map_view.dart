import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:revier_app_client/config/env.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(envConfig.MAPBOX_ACCESS_TOKEN);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: [
                const SizedBox(height: 0),
                Expanded(
                  child: MapWidget(
                    onMapCreated: (MapboxMap map) {},
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(-0.1278, 51.5074),
                      ),
                      zoom: 10.0,
                      bearing: 0.0,
                      pitch: 0.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
