import 'package:campus_flutter/base/enums/campus.dart';
import 'package:campus_flutter/base/helpers/icon_text.dart';
import 'package:campus_flutter/base/views/seperated_list.dart';
import 'package:campus_flutter/homeComponent/widgetComponent/views/widget_frame_view.dart';
import 'package:campus_flutter/navigaTumComponent/viewModels/navigatum_viewmodel.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/cafeteria.dart';
import 'package:campus_flutter/placesComponent/model/studyRooms/study_room_group.dart';
import 'package:campus_flutter/placesComponent/viewModels/cafeterias_viewmodel.dart';
import 'package:campus_flutter/placesComponent/viewModels/places_viewmodel.dart';
import 'package:campus_flutter/placesComponent/viewModels/study_rooms_viewmodel.dart';
import 'package:campus_flutter/placesComponent/views/cafeterias/cafeteria_row_view.dart';
import 'package:campus_flutter/placesComponent/views/campuses/campus_most_searched_view.dart';
import 'package:campus_flutter/placesComponent/views/homeWidget/study_room_widget_view.dart';
import 'package:campus_flutter/placesComponent/views/map_widget.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:campus_flutter/placesComponent/views/relaxation/relaxations_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdaptedCampusView extends StatelessWidget {
  const AdaptedCampusView({
    super.key,
    required this.campus,
    required this.orientation,
  });

  final Campus campus;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CampusView(
        campus: campus,
        orientation: orientation,
      ),
    );
  }
}

class CampusView extends ConsumerStatefulWidget {
  const CampusView({
    super.key,
    required this.campus,
    required this.orientation,
  });

  final Campus campus;
  final Orientation orientation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CampusViewState();
}

class _CampusViewState extends ConsumerState<CampusView> {
  late List<Cafeteria> cafeterias;
  late List<StudyRoomGroup> studyRooms;

  @override
  void initState() {
    ref
        .read(navigaTumViewModel)
        .mostSearched(widget.campus.searchStringRooms, false);
    cafeterias =
        ref.read(cafeteriasViewModel).campusCafeterias.value?[widget.campus] ??
            [];
    studyRooms =
        ref.read(studyRoomsViewModel).campusStudyRooms.value?[widget.campus] ??
            [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orientation == Orientation.landscape) {
      return _landscapeOrientation();
    } else {
      return _portraitOrientation();
    }
  }

  Widget _landscapeOrientation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: WidgetFrameView(
            title: context.localizations.map,
            child: Expanded(
              child: MapWidget.horizontalPadding(
                aspectRatioNeeded: false,
                markers: ref
                    .read(placesViewModel)
                    .getCampusMarkers(context, widget.campus),
                latLng: LatLng(
                  widget.campus.location.latitude,
                  widget.campus.location.longitude,
                ),
                zoom: 15,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _campusWidgets(),
          ),
        ),
      ],
    );
  }

  Widget _portraitOrientation() {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
        _campusWidgets(),
      ],
    );
  }

  Widget _campusWidgets() {
    return Column(
      children: [
        Column(
          children: [
            if (cafeterias.isNotEmpty)
              WidgetFrameView(
                titleWidget: IconText(
                  iconData: Icons.location_pin,
                  label: context.localizations.cafeterias,
                  style: Theme.of(context).textTheme.titleMedium,
                  leadingIcon: false,
                ),
                child: Card(
                  child: SeparatedList.list(
                    data: cafeterias,
                    tile: (cafeteria) => CafeteriaRowView(cafeteria: cafeteria),
                  ),
                ),
              ),
            if (studyRooms.isNotEmpty)
              WidgetFrameView(
                titleWidget: IconText(
                  iconData: Icons.location_pin,
                  label: context.localizations.studyRooms,
                  iconColor: Colors.red,
                  style: Theme.of(context).textTheme.titleMedium,
                  leadingIcon: false,
                ),
                child: Card(
                  child: SeparatedList.list(
                    data: studyRooms,
                    tile: (studyRoomGroup) =>
                        StudyRoomWidgetView(studyRoomGroup),
                  ),
                ),
              ),
            if (widget.campus == Campus.stammgelaende)
              WidgetFrameView(
                title: context.localizations.more,
                child: Card(
                  child: ListTile(
                    title: IconText(
                      iconData: Icons.location_pin,
                      iconColor: Colors.green,
                      label: context.localizations.relaxationPlaces,
                      leadingIcon: false,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RelaxationsScaffold(),
                      ),
                    ),
                  ),
                ),
              ),
            const CampusMostSearchedView(),
          ],
        ),
      ],
    );
  }
}
