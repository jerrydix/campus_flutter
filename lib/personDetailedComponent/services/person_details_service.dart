import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_exception.dart';
import 'package:campus_flutter/base/networking/apis/tumOnlineApi/tum_online_api_service.dart';
import 'package:campus_flutter/base/networking/base/rest_client.dart';
import 'package:campus_flutter/personDetailedComponent/model/person_details.dart';
import 'package:campus_flutter/main.dart';

class PersonDetailsService {
  static Future<(DateTime?, PersonDetails)> fetchPersonDetails(
    bool forcedRefresh,
    String identNumber,
  ) async {
    RESTClient restClient = getIt<RESTClient>();
    final response = await restClient.getWithException<PersonDetailsData,
        TumOnlineApi, TumOnlineApiException>(
      TumOnlineApi(TumOnlineServicePersonDetails(identNumber: identNumber)),
      PersonDetailsData.fromJson,
      TumOnlineApiException.fromJson,
      forcedRefresh,
    );
    return (response.saved, response.data.person);
  }
}
