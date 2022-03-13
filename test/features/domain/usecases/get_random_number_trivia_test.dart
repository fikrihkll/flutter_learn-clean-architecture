import 'package:dartz/dartz.dart';
import 'package:learn_bloc_advance/core/usecase/usecase.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';
import 'package:learn_bloc_advance/features/domain/repositories/number_trivia_repository.dart';
import 'package:learn_bloc_advance/features/domain/usecases/get_random_number_trivia.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {

  MockNumberTriviaRepository mockNumberTriviaRepository= MockNumberTriviaRepository();
  GetRandomNumberTrivia usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);

  setUp(() {

  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia from the repo',
        () async {
      //Arrange
      when(()=>mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //Act
      final result = await usecase.call(NoParams());
      //Assert
      expect(result, Right(tNumberTrivia));
      verify(()=>mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
