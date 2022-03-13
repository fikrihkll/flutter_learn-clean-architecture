import 'package:learn_bloc_advance/core/error/exception.dart';
import 'package:learn_bloc_advance/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learn_bloc_advance/features/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient = MockHttpClient();
  NumberTriviaRemoteDataSourceImpl dataSource = NumberTriviaRemoteDataSourceImpl(
      client: mockHttpClient);

  void setupHttpClientSuccess(int tNumber,Uri url){

    when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupHttpClientFailed(int tNumber,Uri url){
    when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 400));
  }

  group('getConcreteNumber', () {
    final tNumber = 1;
    final url = Uri.parse('http://numbersapi.com/$tNumber');
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    
    test('''should perform a GET request on a URL with number 
    being the endpoint and with application/json header''', () async {
      //arrange
      setupHttpClientSuccess(tNumber,url);
      //act
      await dataSource.getConcreteNumberTrivia(tNumber);
      //assert

      verify(() =>
          mockHttpClient.get(url,
              headers:
              {'Content-Type': 'application/json',}
          ));
      

    });
    test('should return NumberTrivia when the response code is 200 (success)',
            ()async{
          //arrange
          setupHttpClientSuccess(tNumber,url);
          //act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          //assert
          expect(result, equals(tNumberTriviaModel));
        });

    test('should throw a ServerException when the response code is 404 or other',
            ()async{
          //arrange
          setupHttpClientFailed(tNumber, url);
          //act
          final call = dataSource.getConcreteNumberTrivia;
          //assert
          expect(()=>call(tNumber),throwsA(TypeMatcher<ServerException>()));
        });
  });

  group('getRandomNumber', () {
    final tNumber = 1;
    final url = Uri.parse('http://numbersapi.com/random');
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
    being the endpoint and with application/json header''', () async {
      //arrange
      setupHttpClientSuccess(tNumber,url);
      //act
      await dataSource.getRandomNumberTrivia();
      //assert

      verify(() =>
          mockHttpClient.get(url,
              headers:
              {'Content-Type': 'application/json',}
          ));


    });
    test('should return NumberTrivia when the response code is 200 (success)',
            ()async{
          //arrange
          setupHttpClientSuccess(tNumber,url);
          //act
          final result = await dataSource.getRandomNumberTrivia();
          //assert
          expect(result, equals(tNumberTriviaModel));
        });

    test('should throw a ServerException when the response code is 404 or other',
            ()async{
          //arrange
          setupHttpClientFailed(tNumber, url);
          //act
          final call = dataSource.getRandomNumberTrivia;
          //assert
          expect(()=>call(),throwsA(TypeMatcher<ServerException>()));
        });
  });
}
