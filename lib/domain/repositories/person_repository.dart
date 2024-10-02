

import 'package:tmdb/domain/entities/person.dart';

abstract class PersonRepository {
  Future<List<Person>> getPersons(int page);
}