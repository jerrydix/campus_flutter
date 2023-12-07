import 'package:campus_flutter/calendarComponent/model/calendar_data_source.dart';
import 'package:campus_flutter/calendarComponent/services/calendar_view_service.dart';
import 'package:campus_flutter/calendarComponent/views/appointment_view.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWeekView extends ConsumerWidget {
  const CalendarWeekView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SfCalendar(
        view: CalendarView.workWeek,
        dataSource: MeetingDataSource(
          ref.read(calendarViewModel).events.value ?? [],
          context,
        ),
        onTap: (details) {
          getIt<CalendarViewService>()
              .showModalSheet(details, null, context, ref);
        },
        firstDayOfWeek: 1,
        showDatePickerButton: true,
        headerDateFormat: "",
        showWeekNumber: true,
        showNavigationArrow: true,
        minDate: getIt<CalendarViewService>().minDate(ref),
        maxDate: getIt<CalendarViewService>().maxDate(ref),
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 7,
          endHour: 22,
          timeFormat: "HH:mm",
        ),
        appointmentBuilder: (context, details) => AppointmentView(details),
      ),
    );
  }
}
