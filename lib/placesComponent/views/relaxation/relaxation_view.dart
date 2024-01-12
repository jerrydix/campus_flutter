import 'package:campus_flutter/base/classes/location.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:campus_flutter/placesComponent/views/directions_button.dart';
import 'package:campus_flutter/placesComponent/views/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class RelaxationScaffold extends StatelessWidget {
  const RelaxationScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Bank"),
      ),
      body: const RelaxationView(),
    );
  }
}

class RelaxationView extends StatelessWidget {
  const RelaxationView({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return const Row(
            children: [
              /*
              Expanded(
                child: Column(
                  children: [..._mapAndDirections()],
                ),
              ),
              Expanded(child: _pickerAndSlider()),
               */
            ],
          );
        } else {
          return Column(
            children: [
              const Text("Description"),
              Padding(
                padding: EdgeInsets.all(context.padding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(
                      "assets/images/placeholders/news_placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              MapWidget.customPadding(
                padding: EdgeInsets.only(
                  left: context.padding,
                  right: context.padding,
                  bottom: context.padding,
                ),
                aspectRatio: 16 / 9,
                markers: {
                  Marker(
                    markerId: MarkerId(const Uuid().v4()),
                    position: const LatLng(
                      48,
                      11,
                    ),
                  ),
                },
                latLng: const LatLng(
                  48,
                  11,
                ),
              ),
              DirectionsButton.location(
                location: Location(
                  latitude: 48,
                  longitude: 11,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
