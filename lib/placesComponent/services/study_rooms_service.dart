import 'package:campus_flutter/base/networking/apis/tumDevAppApi/tum_dev_app_api.dart';
import 'package:campus_flutter/base/networking/apis/tumDevAppApi/tum_dev_app_api_service.dart';
import 'package:campus_flutter/base/networking/protocols/main_api.dart';
import 'package:campus_flutter/placesComponent/model/studyRooms/study_room_data.dart';
import 'package:campus_flutter/providers_get_it.dart';

class StudyRoomsService {
  static Future<(DateTime?, StudyRoomData)> fetchStudyRooms(
    bool forcedRefresh,
  ) async {
    MainApi mainApi = getIt<MainApi>();
    final response = await mainApi.makeRequest<StudyRoomData, TumDevAppApi>(
      TumDevAppApi(tumDevAppService: TumDevAppServiceRooms()),
      StudyRoomData.fromJson,
      forcedRefresh,
    );

    return (response.saved, response.data);
  }
}
