import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_exception.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_service.dart';
import 'package:campus_flutter/base/networking/base/rest_client.dart';
import 'package:campus_flutter/calendarComponent/model/calendar_editing.dart';
import 'package:campus_flutter/calendarComponent/model/calendar_event.dart';
import 'package:campus_flutter/main.dart';

class CalendarService {
  static Future<(DateTime?, List<CalendarEvent>)> fetchCalendar(
    bool forcedRefresh,
  ) async {
    RESTClient restClient = getIt<RESTClient>();
    final response = await restClient
        .getWithException<CalendarEvents, TumOnlineApi, TumOnlineApiException>(
      TumOnlineApi(TumOnlineServiceCalendar()),
      CalendarEvents.fromJson,
      TumOnlineApiException.fromJson,
      forcedRefresh,
    );
    return (response.saved, response.data.events);
  }

  static Future<CalendarCreationConfirmation> createCalendarEvent(
    AddedCalendarEvent addedCalendarEvent,
  ) async {
    RESTClient restClient = getIt<RESTClient>();
    final response = await restClient.getWithException<
        CalendarCreationConfirmationData, TumOnlineApi, TumOnlineApiException>(
      TumOnlineApi(
        TumOnlineServiceEventCreate(
          title: addedCalendarEvent.title,
          annotation: addedCalendarEvent.annotation,
          from: TumOnlineApi.dateFormat.format(addedCalendarEvent.from),
          to: TumOnlineApi.dateFormat.format(addedCalendarEvent.to),
        ),
      ),
      CalendarCreationConfirmationData.fromJson,
      TumOnlineApiException.fromJson,
      true,
    );
    return response.data.calendarCreationConfirmation;
  }

  static Future<void> deleteCalendarEvent(
    String id,
  ) async {
    RESTClient restClient = getIt<RESTClient>();
    restClient.getWithException(
      TumOnlineApi(
        TumOnlineServiceEventDelete(
          eventId: id,
        ),
      ),
      CalendarDeletionConfirmationData.fromJson,
      TumOnlineApiException.fromJson,
      true,
    );
  }
}
