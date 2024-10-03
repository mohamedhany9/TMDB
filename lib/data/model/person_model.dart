

import 'package:tmdb/domain/entities/person.dart';

class PersonModel extends Person {
  PersonModel({
    required super.name,
    required super.id,
    required super.profilepath,
    required super.popularity,
    required super.known_for_department,
    required super.original_name,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilepath: json['profile_path'] ?? '',
      popularity: json['popularity'] ?? 10.5,
      known_for_department: json['known_for_department'] ?? '',
      original_name: json['original_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilepath,
      'popularity': popularity,
      'known_for_department': known_for_department,
      'original_name': original_name,


    };
  }
}