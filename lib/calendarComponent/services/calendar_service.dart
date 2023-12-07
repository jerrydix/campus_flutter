import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_exception.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_service.dart';
import 'package:campus_flutter/base/networking/protocols/main_api.dart';
import 'package:campus_flutter/calendarComponent/model/calendar_event.dart';
import 'package:campus_flutter/providers_get_it.dart';

class CalendarService {
  static Future<(DateTime?, List<CalendarEvent>)> fetchCalendar(
    bool forcedRefresh,
  ) async {
    MainApi mainApi = getIt<MainApi>();
    final response = await mainApi.makeRequestWithException<CalendarEventsData,
        TumOnlineApi, TumOnlineApiException>(
      TumOnlineApi(TumOnlineServiceCalendar()),
      CalendarEventsData.fromJson,
      TumOnlineApiException.fromJson,
      forcedRefresh,
    );
    return (response.saved, response.data.events?.event ?? []);
  }
}
