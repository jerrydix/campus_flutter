import 'dart:async';
import 'package:campus_flutter/placesComponent/services/map_theme_service.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends ConsumerStatefulWidget {
  factory MapWidget.fullPadding({
    required Set<Marker> markers,
    LatLng? latLng,
    EdgeInsets? controlPadding,
    double? zoom,
    double? aspectRatio,
    bool aspectRatioNeeded = true,
    bool roundedCorners = true,
  }) {
    return MapWidget._(
      markers: markers,
      horizontalPadding: false,
      controlPadding: controlPadding,
      latLng: latLng,
      zoom: zoom,
      aspectRatio: aspectRatio,
      aspectRatioNeeded: aspectRatioNeeded,
      roundedCorners: roundedCorners,
    );
  }

  factory MapWidget.horizontalPadding({
    required Set<Marker> markers,
    LatLng? latLng,
    EdgeInsets? controlPadding,
    double? zoom,
    double? aspectRatio,
    bool aspectRatioNeeded = true,
    bool roundedCorners = true,
  }) {
    return MapWidget._(
      markers: markers,
      latLng: latLng,
      zoom: zoom,
      aspectRatio: aspectRatio,
      horizontalPadding: true,
      controlPadding: controlPadding,
      aspectRatioNeeded: aspectRatioNeeded,
      roundedCorners: roundedCorners,
    );
  }

  factory MapWidget.noPadding({
    required Set<Marker> markers,
    LatLng? latLng,
    EdgeInsets? controlPadding,
    double? zoom,
    double? aspectRatio,
    bool aspectRatioNeeded = true,
    bool roundedCorners = true,
  }) {
    return MapWidget._(
      markers: markers,
      latLng: latLng,
      zoom: zoom,
      aspectRatio: aspectRatio,
      horizontalPadding: false,
      padding: EdgeInsets.zero,
      controlPadding: controlPadding,
      aspectRatioNeeded: aspectRatioNeeded,
      roundedCorners: roundedCorners,
    );
  }

  factory MapWidget.customPadding({
    required Set<Marker> markers,
    required EdgeInsets padding,
    EdgeInsets? controlPadding,
    LatLng? latLng,
    double? zoom,
    double? aspectRatio,
    bool aspectRatioNeeded = true,
    bool roundedCorners = true,
  }) {
    return MapWidget._(
      markers: markers,
      padding: padding,
      controlPadding: controlPadding,
      latLng: latLng,
      zoom: zoom,
      aspectRatio: aspectRatio,
      horizontalPadding: false,
      aspectRatioNeeded: aspectRatioNeeded,
      roundedCorners: roundedCorners,
    );
  }

  const MapWidget._({
    required this.markers,
    required this.horizontalPadding,
    this.latLng,
    this.zoom,
    this.aspectRatio,
    this.padding,
    this.controlPadding,
    required this.aspectRatioNeeded,
    required this.roundedCorners,
  });

  final Set<Marker> markers;
  final bool horizontalPadding;
  final LatLng? latLng;
  final double? zoom;
  final double? aspectRatio;
  final bool aspectRatioNeeded;
  final bool roundedCorners;
  final EdgeInsets? padding;
  final EdgeInsets? controlPadding;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget>
    with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool isMapVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setMapStyle();
  }

  Future _setMapStyle({bool platformChanged = false}) async {
    final controller = await _controller.future;
    setBrightness(controller, platformChanged);
  }

  void setBrightness(GoogleMapController controller, bool platformChanged) {
    final brightness = Theme.of(context).brightness;
    if (brightness == (platformChanged ? Brightness.light : Brightness.dark)) {
      controller.setMapStyle(getIt.get<MapThemeService>().darkTheme);
    } else {
      controller.setMapStyle(getIt.get<MapThemeService>().lightTheme);
    }
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _setMapStyle(platformChanged: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(context.padding),
      child: ClipRRect(
        borderRadius: widget.roundedCorners
            ? BorderRadius.circular(15.0)
            : BorderRadius.zero,
        child: widget.aspectRatioNeeded
            ? AspectRatio(
                aspectRatio: widget.aspectRatio ?? 1.0,
                child: _mapWidget(),
              )
            : _mapWidget(),
      ),
    );
  }

  Widget _mapWidget() {
    return AnimatedOpacity(
      curve: Curves.fastOutSlowIn,
      opacity: isMapVisible ? 1.0 : 0.01,
      duration: const Duration(milliseconds: 200),
      child: GoogleMap(
        mapType: MapType.normal,
        padding: widget.controlPadding ?? EdgeInsets.zero,
        initialCameraPosition: CameraPosition(
          target: widget.latLng ??
              const LatLng(48.26307794976663, 11.668018668778569),
          zoom: widget.zoom ?? 10,
        ),
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        rotateGesturesEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
        tiltGesturesEnabled: false,
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: widget.markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          Future.delayed(
            const Duration(milliseconds: 250),
            () => setState(() {
              isMapVisible = true;
            }),
          );
        },
      ),
    );
  }
}
