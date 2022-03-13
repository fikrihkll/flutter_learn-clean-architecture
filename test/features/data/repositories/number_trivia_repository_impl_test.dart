import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_bloc_advance/core/error/exception.dart';
import 'package:learn_bloc_advance/core/error/failure.dart';
import 'package:learn_bloc_advance/core/network/network_info.dart';
import 'package:learn_bloc_advance/features/data/datasources/number_trivia_local_data_source.dart';
import 'package:learn_bloc_advance/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learn_bloc_advance/features/data/models/number_trivia_model.dart';
import 'package:learn_bloc_advance/features/data/repositories/number_trivia_repository_impl.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();
  NumberTriviaRepositoryImpl repository = NumberTriviaRepositoryImpl(
    remoteDataSource: mockRemoteDataSource,
    localDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo,
  );

  void runTestOnline(Function body){
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });

  }

  void runTestOffline(Function body){
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });

  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    runTestOnline( () {

      test(
          'should return remote data when the call to remote data source is succesfull',
          () async {
        //arrang
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should return cache when the call to remote data source is succesfull',
          () async {
        //arrang
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccesfull',
          () async {
        //arrange
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());

        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        // verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestOffline( () {

      test(
          'should return last locally cached data when the cached data is present',
          () async {
            //arrange
            when(()=>mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel );
            //act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verify(()=>mockLocalDataSource.getLastNumberTrivia());
            expect(result,Right(tNumberTrivia));
          });

      test(
          'should return cacheFailure when there is no cached data is present',
              () async {
            //arrange
            when(()=>mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verify(()=>mockLocalDataSource.getLastNumberTrivia());
            expect(result,Left(CacheFailure()));
          });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    runTestOnline( () {

      test(
          'should return remote data when the call to remote data source is succesfull',
              () async {
            //arrang
            when(() => mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((_) async => {});
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(() => mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          'should return cache when the call to remote data source is succesfull',
              () async {
            //arrang
            when(() => mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((_) async => {});
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(() => mockRemoteDataSource.getRandomNumberTrivia());
            verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          });

      test(
          'should return server failure when the call to remote data source is unsuccesfull',
              () async {
            //arrange
            when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((_) async => {});
            when(() => mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());

            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(() => mockRemoteDataSource.getRandomNumberTrivia());
            // verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });
    });
    runTestOffline( () {

      test(
          'should return last locally cached data when the cached data is present',
              () async {
            //arrange
            when(()=>mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel );
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(()=>mockLocalDataSource.getLastNumberTrivia());
            expect(result,Right(tNumberTrivia));
          });

      test(
          'should return cacheFailure when there is no cached data is present',
              () async {
            //arrange
            when(()=>mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(()=>mockLocalDataSource.getLastNumberTrivia());
            expect(result,Left(CacheFailure()));
          });
    });
  });
}
