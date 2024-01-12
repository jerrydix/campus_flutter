import 'package:campus_flutter/base/helpers/padded_divider.dart';
import 'package:campus_flutter/placesComponent/viewModels/places_viewmodel.dart';
import 'package:campus_flutter/placesComponent/views/cafeterias/cafeterias_view.dart';
import 'package:campus_flutter/placesComponent/views/campuses/campus_card_view.dart';
import 'package:campus_flutter/placesComponent/views/relaxation/relaxations_view.dart';
import 'package:campus_flutter/placesComponent/views/studyGroups/study_rooms_view.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesView extends ConsumerWidget {
  const PlacesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return _landscapeOrientation(context, ref);
        } else {
          return _portraitOrientation(context, ref);
        }
      },
    );
  }

  Widget _landscapeOrientation(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(
              left: context.padding,
              right: context.padding,
              top: context.halfPadding,
              bottom: context.halfPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _menuEntries(true, context),
            ),
          ),
        ),
        const PaddedDivider(),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            mainAxisSpacing: context.padding,
            crossAxisSpacing: context.padding,
            padding: EdgeInsets.only(
              left: context.padding,
              right: context.padding,
              top: context.halfPadding,
            ),
            children: [
              for (var campus in ref.watch(placesViewModel).campuses)
                CampusCardView(
                  campus: campus,
                  margin: EdgeInsets.zero,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _portraitOrientation(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ..._menuEntries(false, context),
          const PaddedDivider(),
          for (var campus in ref.watch(placesViewModel).campuses)
            CampusCardView(campus: campus),
        ],
      ),
    );
  }

  List<Widget> _menuEntries(bool isLandscape, BuildContext context) => [
        _menuCardWrapper(
          context.localizations.studyRooms,
          Icons.school,
          const StudyRoomsScaffold(),
          isLandscape,
          context,
        ),
        _menuCardWrapper(
          context.localizations.cafeterias,
          Icons.restaurant,
          const CafeteriasScaffold(),
          isLandscape,
          context,
        ),
        _menuCardWrapper(
          "Relaxation Places",
          Icons.weekend,
          const RelaxationsScaffold(),
          isLandscape,
          context,
        ),
      ];

  Widget _menuCardWrapper(
    String title,
    IconData iconData,
    Widget destination,
    bool isLandscape,
    BuildContext context,
  ) {
    if (isLandscape) {
      return Expanded(
        child: _menuCard(
          title,
          iconData,
          destination,
          context,
        ),
      );
    } else {
      return _menuCard(
        title,
        iconData,
        destination,
        context,
      );
    }
  }

  Widget _menuCard(
    String title,
    IconData iconData,
    Widget destination,
    BuildContext context,
  ) {
    return Card(
      child: Center(
        child: ListTile(
          leading: Icon(iconData),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 15),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => destination,
            ),
          ),
        ),
      ),
    );
  }
}
