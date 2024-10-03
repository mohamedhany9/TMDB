import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:tmdb/data/datasources/remote/person_api_service.dart';
import 'package:tmdb/data/model/person_model.dart';
import 'package:tmdb/core/constants/app_constants.dart';

import 'plant_api_service_test.mocks.dart';

@GenerateMocks([Dio])

void main() {
  late PersonApiService personApiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    personApiService = PersonApiService(dio: mockDio);
  });

  group('PersonApiService', () {
    test('getPersons returns list of PersonModel on success', () async {
      final mockResponse = {
        'results': [
          {
            'id': 1,
            'name': 'John Doe',
            'profile_path': '/path.jpg',
            'popularity': 10.5,
            'known_for_department': 'Acting',
            'original_name': 'John Doe'
          }
        ]
      };

      when(mockDio.get(AppConstants.baseUrl, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.baseUrl)));

      final result = await personApiService.getPersons(1);

      expect(result, isA<List<PersonModel>>());
      expect(result.length, 1);
      expect(result[0].name, 'John Doe');
    });

    test('getPersons throws exception on error', () async {
      when(mockDio.get(AppConstants.baseUrl, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioError(requestOptions: RequestOptions(path: AppConstants.baseUrl)));

      expect(() => personApiService.getPersons(1), throwsException);
    });
  });
}