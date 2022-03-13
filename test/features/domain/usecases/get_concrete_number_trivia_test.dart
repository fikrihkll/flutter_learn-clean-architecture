import 'package:dartz/dartz.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';
import 'package:learn_bloc_advance/features/domain/repositories/number_trivia_repository.dart';
import 'package:learn_bloc_advance/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {

  MockNumberTriviaRepository mockNumberTriviaRepository= MockNumberTriviaRepository();
  GetConcreteNumberTrivia usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);

  setUp(() {

  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repo',
    () async {
      //Arrange
      when(()=>mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //Act
      final result = await usecase.call(Params(number: tNumber));
      //Assert
      expect(result, Right(tNumberTrivia));
      verify(()=>mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
