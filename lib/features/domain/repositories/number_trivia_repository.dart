import 'package:dartz/dartz.dart';
import 'package:learn_bloc_advance/core/error/failure.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure,NumberTrivia>> getConcreteNumberTrivia(int? number);
  Future<Either<Failure,NumberTrivia>> getRandomNumberTrivia();
}