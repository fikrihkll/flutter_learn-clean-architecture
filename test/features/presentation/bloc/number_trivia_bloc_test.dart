import 'package:flutter_test/flutter_test.dart';
import 'package:learn_bloc_advance/core/util/input_converter.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';
import 'package:learn_bloc_advance/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learn_bloc_advance/features/domain/usecases/get_random_number_trivia.dart';
import 'package:learn_bloc_advance/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  mockInputConverter = MockInputConverter();
  bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter);

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    test(
        'should call the input converter to validate and convert the string to an unsigned integer',
        () async {
      //arrange
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Right(tNumberParsed));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));
      //assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should call emit [ERROR] when the input is invalid', () async {
      //arrange
      when(() => mockGetConcreteNumberTrivia.call(any()))
        .thenAnswer((_) async => Right(tNumberTrivia));
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure()));

      //assert later
      final expected = [Empty(), Error(message: 'INVALID INPUT MESSAGE')];
      expectLater(bloc.state, emitsInOrder(expected));

      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));

    });
  });
}
