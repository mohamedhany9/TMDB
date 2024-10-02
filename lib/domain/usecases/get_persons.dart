



import 'package:tmdb/domain/entities/person.dart';
import 'package:tmdb/domain/repositories/person_repository.dart';

class GetPersons {
  final PersonRepository repository;

  GetPersons(this.repository);

  Future<List<Person>> call(int page) async {
    return await repository.getPersons(page);
  }
}