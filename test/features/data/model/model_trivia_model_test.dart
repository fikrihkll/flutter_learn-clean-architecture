import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_bloc_advance/features/data/models/number_trivia_model.dart';

import '../../../fixtures/fixture_reader.dart';

void main(){
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
      ()async{

      //Assert
        expect(tNumberTriviaModel,isA<NumberTriviaModel>());

      },
  );

  group('from json', (){
    test(
      'should return a valid model when the JSON number is an integer',
        ()async{
          //arrange
          final Map<String,dynamic> jsonMap = jsonDecode(fixture("trivia.json"));
          //act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //assert
          expect(result,equals(tNumberTriviaModel));
        },
    );
    test(
      'should return a valid model when the JSON number is an regarded as a double',
          ()async{
        //arrange
        final Map<String,dynamic> jsonMap = jsonDecode(fixture("trivia_double.json"));
        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result,equals(tNumberTriviaModel));
      },
    );
  });

  group('to json', (){
    test(
      'should return a JSON map containing the proper data',
          ()async{
        //arrange
        final result = tNumberTriviaModel.toJson();
        //act
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result,expectedMap);
        //assert

      },
    );
  });

}