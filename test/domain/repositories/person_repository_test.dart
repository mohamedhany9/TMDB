import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb/domain/entities/person.dart';
import 'package:tmdb/domain/repositories/person_repository.dart';


void main() {
  group('PersonRepository', () {
    test('contract', () {

      final repository = _MockPlantRepository();

      expect(repository.getPersons(1), isA<Future<List<Person>>>());
    });
  });
}

class _MockPlantRepository implements PersonRepository {
  @override
  Future<List<Person>> getPersons(int page) async {
    return [];
  }
}