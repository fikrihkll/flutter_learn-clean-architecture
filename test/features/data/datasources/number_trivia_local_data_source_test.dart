import 'package:learn_bloc_advance/core/error/exception.dart';
import 'package:learn_bloc_advance/features/data/datasources/number_trivia_local_data_source.dart';
import 'package:learn_bloc_advance/features/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../fixtures/fixture_reader.dart';

/*
* THIS TEST HAVEN'T IMPLEMENTED BECAUSE I'M SUCK
*/

class MockSharedPreferences extends Mock
    implements SharedPreferences {}

void main() {

  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  NumberTriviaLocalDataSrouceImpl dataSrouce = NumberTriviaLocalDataSrouceImpl(sharedPreferences: mockSharedPreferences);

  group('getLastNumberTrivia', () {

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from SharedPreferences when their is one in the cache',() async {
      //arrange
      when(()=> mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await dataSrouce.getLastNumberTrivia();
      //assert
      verify(()=>mockSharedPreferences.getString(KEY_CACHE));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is no a cached value',() async {
      //arrange
      when(()=> mockSharedPreferences.getString(any()))
          .thenReturn(null);
      //act
      final call = dataSrouce.getLastNumberTrivia;
      //assert
      expect(()=> call, throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Trivia');
    test('should call preferences to cache the data',() async {
      //act
      dataSrouce.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = await json.encode(tNumberTriviaModel.toJson());
      verify(()=>mockSharedPreferences.setString(KEY_CACHE, expectedJsonString));
    });
  });
}
