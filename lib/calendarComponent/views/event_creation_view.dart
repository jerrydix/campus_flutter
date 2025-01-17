import 'package:campus_flutter/base/extensions/context.dart';
import 'package:campus_flutter/calendarComponent/model/calendar_event.dart';
import 'package:campus_flutter/calendarComponent/viewModels/calendar_addition_viewmodel.dart';
import 'package:campus_flutter/calendarComponent/views/event_creation_date_time_picker.dart';
import 'package:campus_flutter/calendarComponent/views/event_creation_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventCreationScaffold extends ConsumerWidget {
  const EventCreationScaffold({
    super.key,
    required this.calendarEvent,
  });

  final CalendarEvent? calendarEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            ref.invalidate(calendarAdditionViewModel(calendarEvent));
            Navigator.pop(context);
          },
        ),
        title: Text(context.localizations.createCalendarEvent),
      ),
      body: EventCreationView(
        calendarEvent: calendarEvent,
      ),
    );
  }
}

class EventCreationView extends ConsumerWidget {
  const EventCreationView({
    super.key,
    required this.calendarEvent,
  });

  final CalendarEvent? calendarEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            EventCreationFormField(
              title: context.localizations.title,
              controller: ref
                  .read(calendarAdditionViewModel(calendarEvent))
                  .titleController,
              maxLength: 255,
              maxLines: 2,
              calendarEvent: calendarEvent,
            ),
            EventCreationFormField(
              title: context.localizations.annotation,
              controller: ref
                  .read(calendarAdditionViewModel(calendarEvent))
                  .annotationController,
              maxLength: 4000,
              maxLines: 200,
              calendarEvent: calendarEvent,
            ),
            EventCreationDateTimePicker(
              title: context.localizations.from,
              currentDate:
                  ref.watch(calendarAdditionViewModel(calendarEvent)).from,
              onDateSet: ref
                  .read(calendarAdditionViewModel(calendarEvent))
                  .setFromDate,
              onTimeOfDaySet: ref
                  .read(calendarAdditionViewModel(calendarEvent))
                  .setFromTimeOfDay,
            ),
            EventCreationDateTimePicker(
              title: context.localizations.to,
              currentDate:
                  ref.watch(calendarAdditionViewModel(calendarEvent)).to,
              onDateSet:
                  ref.read(calendarAdditionViewModel(calendarEvent)).setToDate,
              onTimeOfDaySet: ref
                  .read(calendarAdditionViewModel(calendarEvent))
                  .setToTimeOfDay,
            ),
            _submitButton(ref),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(calendarAdditionViewModel(calendarEvent)).isValid,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: (snapshot.data ?? false)
              ? () => ref
                      .read(calendarAdditionViewModel(calendarEvent))
                      .saveEvent()
                      .then((value) {
                    ref.invalidate(calendarAdditionViewModel);
                    Navigator.pop(context);
                  })
              : null,
          child: Text(context.localizations.submit),
        );
      },
    );
  }
}
