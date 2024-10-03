import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb/domain/entities/person.dart';

void main() {
  group('Person', () {
    test('should create a Person instance with correct properties', () {
      // Arrange & Act
      final person = Person(
        id: 1,
        original_name: 'John Doe',
        name: 'John Doe',
        known_for_department: 'Acting',
        popularity: 10.5,
        profilepath: '/path.jpg'
      );


      expect(person.profilepath, '/path.jpg');
      expect(person.name, 'John Doe');
      expect(person.original_name, 'John Doe');
      expect(person.id, 1);
      expect(person.known_for_department, 'Acting');
      expect(person.popularity, 10.5);

    });
  });
}