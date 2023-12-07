import 'package:campus_flutter/calendarComponent/model/calendar_data_source.dart';
import 'package:campus_flutter/calendarComponent/services/calendar_view_service.dart';
import 'package:campus_flutter/calendarComponent/views/appointment_view.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarMonthView extends ConsumerWidget {
  const CalendarMonthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaItemHeight: 75,
          navigationDirection: MonthNavigationDirection.vertical,
        ),
        dataSource: MeetingDataSource(
          ref.read(calendarViewModel).events.value ?? [],
          context,
        ),
        firstDayOfWeek: 1,
        showDatePickerButton: true,
        showNavigationArrow: true,
        minDate: getIt<CalendarViewService>().minDate(ref),
        maxDate: getIt<CalendarViewService>().maxDate(ref),
        onTap: (details) {
          getIt<CalendarViewService>()
              .showModalSheet(details, null, context, ref);
        },
        appointmentBuilder: (context, details) => AppointmentView(details),
      ),
    );
  }
}
