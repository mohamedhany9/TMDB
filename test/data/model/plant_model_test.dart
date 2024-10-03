import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb/data/model/person_model.dart';


void main() {
  group('PlantModel', () {
    test('should create PersonModel from JSON', () {

      final json = {
        'id': 1,
        'name': 'John Doe',
        'profile_path': '/path.jpg',
        'popularity': 10.5,
        'known_for_department': 'Acting',
        'original_name': 'John Doe'
      };


      final personModel  = PersonModel.fromJson(json);


      expect(personModel.id, 1);
      expect(personModel.name, 'John Doe');
      expect(personModel.profilepath, '/path.jpg');
      expect(personModel.popularity, 10.5);
      expect(personModel.known_for_department, 'Acting');
      expect(personModel.original_name, 'John Doe');
    });

    test('should create PersonModel with default values when JSON is incomplete', () {

      final json = {'status': 'Active'};


      final personModel = PersonModel.fromJson(json);


      expect(personModel.id, 0);
      expect(personModel.popularity, 10.5);
      expect(personModel.original_name, '');
      expect(personModel.known_for_department, '');
      expect(personModel.profilepath, '');
      expect(personModel.name, '');
    });

    test('should convert PlantModel to JSON', () {

      final personModel = PersonModel(
        id: 1,
        name: 'John Doe',
        profilepath: '/path.jpg',
        popularity: 10.5,
        known_for_department: 'Acting',
        original_name: 'John Doe',
      );


      final json = personModel.toJson();


      expect(json['id'], 1);
      expect(json['name'], 'John Doe');
      expect(json['profile_path'], '/path.jpg');
      expect(json['popularity'], 10.5);
      expect(json['known_for_department'], 'Acting');
      expect(json['original_name'], 'John Doe');
    });
  });
}