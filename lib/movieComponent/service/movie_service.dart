import 'package:campus_flutter/base/networking/apis/google/protobuf/timestamp.pb.dart';
import 'package:campus_flutter/base/networking/apis/tumdev/cached_client.dart';
import 'package:campus_flutter/base/networking/apis/tumdev/campus_backend.pbgrpc.dart';
import 'package:campus_flutter/providers_get_it.dart';

class MovieService {
  static Future<(DateTime?, List<Movie>)> fetchMovies(
    bool forcedRefresh,
  ) async {
    final start = DateTime.now();
    CachedCampusClient mainApi = getIt<CachedCampusClient>();
    final response = await mainApi.listMovies(
      ListMoviesRequest(
        oldestDateAt: Timestamp.fromDateTime(
          DateTime(start.year, start.month, start.day),
        ),
      ),
    );
    return (start, response.movies);
  }
}
