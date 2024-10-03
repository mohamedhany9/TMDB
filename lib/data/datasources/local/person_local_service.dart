import 'package:hive/hive.dart';
import 'package:tmdb/data/model/person_model.dart';

class PersonLocalDataSource {
  static const String boxName = 'persons';

  Future<void> cachePersons(List<PersonModel> persons) async {
    final box = await Hive.openBox<PersonModel>(boxName);
    await box.clear();
    await box.addAll(persons);
  }

  Future<List<PersonModel>> getLastPersons() async {
    final box = await Hive.openBox<PersonModel>(boxName);
    return box.values.toList();
  }
}