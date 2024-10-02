import 'package:dio/dio.dart';
import 'package:tmdb/core/constants/app_constants.dart';
import 'package:tmdb/data/model/person_model.dart';


class PersonApiService {
  final Dio dio;


  PersonApiService({Dio? dio}) : dio = dio ?? Dio();

  Future<List<PersonModel>> getPersons(int page) async {
    try {
      final response = await dio.get(
        AppConstants.baseUrl,
        queryParameters: {'api_key': AppConstants.apiKey, 'page': page},
      );

      final data = response.data['results'] as List;
      return data.map((json) => PersonModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch persons');
    }
  }
}