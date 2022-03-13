import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_bloc_advance/core/util/input_converter.dart';

void main(){
  InputConverter inputConverter = InputConverter();

  group('stringToUnsignedInt', (){
    test('should return an integer when the string represent an unsigned integer',(){
      //arrange
      final str ='123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result,Right(123));

    });

    test('should return failure when the string is not an integer',(){
      //arrange
      final str ='abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result,Left(InvalidInputFailure()));

    });

    test('should return failure when the string is an negative integer',(){
      //arrange
      final str ='-123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result,Left(InvalidInputFailure()));

    });
  });

}