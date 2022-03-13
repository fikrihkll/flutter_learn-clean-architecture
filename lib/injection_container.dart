
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/data/datasources/number_trivia_local_data_source.dart';
import 'features/data/datasources/number_trivia_remote_data_source.dart';
import 'features/data/repositories/number_trivia_repository_impl.dart';
import 'features/domain/repositories/number_trivia_repository.dart';
import 'features/domain/usecases/get_concrete_number_trivia.dart';
import 'features/domain/usecases/get_random_number_trivia.dart';
import 'features/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
        () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      inputConverter: sl(),
      getRandomNumberTrivia: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
        () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
        () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
        () => NumberTriviaLocalDataSrouceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}