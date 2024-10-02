

import 'package:tmdb/data/datasources/remote/person_api_service.dart';
import 'package:tmdb/domain/entities/person.dart';
import 'package:tmdb/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonApiService apiService;

  PersonRepositoryImpl(this.apiService);

  @override
  Future<List<Person>> getPersons(int page) async {
    return await apiService.getPersons(page);
  }
}