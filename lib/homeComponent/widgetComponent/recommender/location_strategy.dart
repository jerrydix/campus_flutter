import 'dart:developer';

import 'package:campus_flutter/base/classes/location.dart';
import 'package:campus_flutter/base/enums/campus.dart';
import 'package:campus_flutter/base/enums/home_widget.dart';
import 'package:campus_flutter/base/services/location_service.dart';
import 'package:campus_flutter/homeComponent/widgetComponent/recommender/widget_recommender_strategy.dart';
import 'package:campus_flutter/placesComponent/services/cafeterias_service.dart';
import 'package:campus_flutter/placesComponent/services/study_rooms_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationStrategy implements WidgetRecommenderStrategy {
  /// distance in meters
  final int closeDistance = 1000;
  final int veryCloseDistance = 250;

  @override
  Future<Map<HomeWidget, int>> getRecommendations() async {
    try {
      await LocationService.determinePosition();
    } catch (e) {
      log("Recommender - ${e.toString()}");
    }
    return {for (var e in HomeWidget.values) e: await _priority(e)};
  }

  Future<int> _priority(HomeWidget homeWidget) async {
    return LocationService.getLastKnown().then(
      (location) async {
        int priority = 0;
        if (location != null) {
          switch (homeWidget) {
            case HomeWidget.cafeteria:
              final locations = await _getCafeteriaLocations();

              for (var distance in [closeDistance, veryCloseDistance]) {
                locations.removeWhere(
                  (element) => (Geolocator.distanceBetween(
                        element.latitude,
                        element.longitude,
                        location.latitude,
                        location.longitude,
                      ) >=
                      distance),
                );
                if (locations.isNotEmpty) {
                  priority++;
                } else {
                  priority = 0;
                }
              }

            case HomeWidget.studyRoom:
              final locations = await _getStudyRoomLocations();

              for (var distance in [closeDistance, veryCloseDistance]) {
                locations.removeWhere(
                  (element) =>
                      Geolocator.distanceBetween(
                        element.latitude,
                        element.longitude,
                        location.latitude,
                        location.longitude,
                      ) >=
                      distance,
                );

                if (locations.isNotEmpty) {
                  priority++;
                } else {
                  priority = 0;
                }
              }

            case HomeWidget.departures:
              List<Campus> locations = Campus.values.toList();

              locations.removeWhere(
                (element) =>
                    Geolocator.distanceBetween(
                      element.location.latitude,
                      element.location.longitude,
                      location.latitude,
                      location.longitude,
                    ) >=
                    closeDistance,
              );

              if (locations.isEmpty) {
                priority == 0;
              } else {
                priority++;
              }

            default:
              priority = 1;
              break;
          }
        }

        return priority;
      },
      onError: (error) => 0,
    );
  }

  Future<List<Location>> _getCafeteriaLocations() async {
    try {
      final cafeterias = await CafeteriasService.fetchCafeterias(false);
      return cafeterias.$2
          .map(
            (e) => Location(
              latitude: e.location.latitude,
              longitude: e.location.longitude,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Location>> _getStudyRoomLocations() async {
    try {
      List<Location> locations = [];
      final response = await StudyRoomsService.fetchStudyRooms(false);

      if (response.$2.groups == null) {
        return locations;
      }

      for (var group in response.$2.groups!) {
        if (group.coordinate != null) {
          locations.add(group.coordinate!);
        }
      }

      return locations;
    } catch (_) {
      return [];
    }
  }
}
