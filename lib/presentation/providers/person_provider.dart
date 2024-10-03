import 'package:flutter/material.dart';
import 'package:tmdb/domain/entities/person.dart';
import 'package:tmdb/domain/usecases/get_persons.dart';


class PersonProvider with ChangeNotifier {
  final GetPersons getPersonsUseCase;

  PersonProvider(this.getPersonsUseCase);

  final List<Person> _persons = [];
  bool _isLoading = false;

  List<Person> get persons => _persons;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  int _currentPage = 1;

  bool get hasMore => _hasMore;


  Future<void> fetchPersons() async {

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPlants = await getPersonsUseCase( _currentPage);
      if (newPlants.isEmpty) {
        _hasMore = false;
      } else {
        _persons.addAll(newPlants);
        _currentPage++;
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void resetPagination() {
    _persons.clear();
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }

  Future<void> refreshPersons() async {
    resetPagination();
    await fetchPersons();
  }
}