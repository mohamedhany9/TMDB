import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tmdb/domain/entities/person.dart';
import 'package:tmdb/domain/repositories/person_repository.dart';
import 'package:tmdb/domain/usecases/get_persons.dart';

import 'get_persons_test.mocks.dart';

@GenerateMocks([PersonRepository])

void main() {
  late GetPersons getPersons;
  late MockPersonRepository mockRepository;

  setUp(() {
    mockRepository = MockPersonRepository();
    getPersons = GetPersons(mockRepository);
  });

  group('GetPersons', () {
    final tPage = 1;
    final tPersonList = [
      Person(
          id: 1,
          original_name: 'John Doe',
          name: 'John Doe',
          known_for_department: 'Acting',
          popularity: 10.5,
          profilepath: '/path.jpg'
      ),
      Person(
          id: 2,
          original_name: 'Jane Doe',
          name: 'Jane Doe',
          known_for_department: 'Directing',
          popularity: 9.5,
          profilepath: '/path2.jpg'
      ),
    ];

    test('should get persons from the repository', () async {
      // Arrange
      when(mockRepository.getPersons(tPage))
          .thenAnswer((_) async => tPersonList);

      // Act
      final result = await getPersons(tPage);

      // Assert
      expect(result, equals(tPersonList));
      verify(mockRepository.getPersons(tPage)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw an exception when repository fails', () async {
      // Arrange
      when(mockRepository.getPersons(tPage))
          .thenThrow(Exception('Failed to get persons'));

      // Act & Assert
      expect(() => getPersons(tPage), throwsA(isA<Exception>()));
      verify(mockRepository.getPersons(tPage)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}