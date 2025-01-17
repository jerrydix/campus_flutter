import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_exception.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_service.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api.dart';
import 'package:campus_flutter/base/networking/base/rest_client.dart';
import 'package:campus_flutter/main.dart';
import 'package:campus_flutter/profileComponent/model/profile.dart';
import 'package:campus_flutter/profileComponent/model/tuition.dart';

class ProfileService {
  static Future<(DateTime?, Profile)> fetchProfile(bool forcedRefresh) async {
    RESTClient restClient = getIt<RESTClient>();
    final response = await restClient
        .getWithException<Profiles, TumOnlineApi, TumOnlineApiException>(
      TumOnlineApi(TumOnlineServiceIdentify()),
      Profiles.fromJson,
      TumOnlineApiException.fromJson,
      forcedRefresh,
    );

    return (response.saved, response.data.profile);
  }

  static Future<(DateTime?, Tuition?)> fetchTuition(
    bool forcedRefresh,
    String personGroup,
    String id,
  ) async {
    RESTClient restClient = getIt<RESTClient>();
    final response = await restClient
        .getWithException<Tuitions, TumOnlineApi, TumOnlineApiException>(
      TumOnlineApi(TumOnlineServiceTuitionStatus()),
      Tuitions.fromJson,
      TumOnlineApiException.fromJson,
      forcedRefresh,
    );

    return (response.saved, response.data.tuition);
  }
}
