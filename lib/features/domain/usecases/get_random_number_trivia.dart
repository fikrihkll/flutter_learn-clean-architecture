import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learn_bloc_advance/core/error/failure.dart';
import 'package:learn_bloc_advance/core/usecase/usecase.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';
import 'package:learn_bloc_advance/features/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {

  NumberTriviaRepository repository;


  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }

}

