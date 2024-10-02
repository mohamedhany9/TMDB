

import 'package:tmdb/domain/entities/person.dart';

class PersonModel extends Person {
  PersonModel({
    required super.name,
    required super.id,
    required super.profilepath,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilepath: json['profile_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilepath,

    };
  }
}