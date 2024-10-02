import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/data/datasources/remote/person_api_service.dart';
import 'package:tmdb/data/repositories/person_repository_impl.dart';
import 'package:tmdb/domain/usecases/get_persons.dart';
import 'package:tmdb/presentation/screens/person_list_screen.dart';

import 'presentation/providers/plant_provider.dart';

void main() {
  final plantApiService = PersonApiService();
  final plantRepository = PersonRepositoryImpl(plantApiService);
  final getPlantsUseCase = GetPersons(plantRepository);

  runApp(MyApp(getPersonsUseCase: getPlantsUseCase));
}

class MyApp extends StatelessWidget {
  final GetPersons getPersonsUseCase;
  const MyApp({super.key, required this.getPersonsUseCase});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        rebuildFactor: (old, data) => true,
        builder: (context, child) {
          return ChangeNotifierProvider(
            create: (_) => PlantProvider(getPersonsUseCase),
            child: MaterialApp(
              title: 'Plant',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const PersonListScreen(),
            ),
          );
        }
    );
  }
}


