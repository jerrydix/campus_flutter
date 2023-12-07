import 'package:campus_flutter/base/enums/campus.dart';
import 'package:campus_flutter/placesComponent/views/map_widget.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CampusMapScaffold extends StatelessWidget {
  const CampusMapScaffold({super.key, required this.campus});

  final Campus campus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(campus.name),
        titleSpacing: 0,
      ),
      body: CampusMapView(
        campus: campus,
      ),
    );
  }
}

class CampusMapView extends ConsumerWidget {
  const CampusMapView({super.key, required this.campus});

  final Campus campus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapWidget.noPadding(
      aspectRatioNeeded: false,
      markers: ref.read(placesViewModel).getCampusMarkers(context, campus),
      latLng: LatLng(
        campus.location.latitude,
        campus.location.longitude,
      ),
      zoom: 15,
      roundedCorners: false,
      controlPadding: const EdgeInsets.all(20),
    );
  }
}
