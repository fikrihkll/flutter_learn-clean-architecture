import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learn_bloc_advance/core/error/failure.dart';
import 'package:learn_bloc_advance/core/usecase/usecase.dart';
import 'package:learn_bloc_advance/core/util/input_converter.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';
import 'package:learn_bloc_advance/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learn_bloc_advance/features/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INPUT_FAILURE_MESSAGE = 'Input Failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {
        required this.getConcreteNumberTrivia,
        required this.getRandomNumberTrivia,
        required this.inputConverter
      })
      : super(Empty()) {

    on<GetTriviaForConcreteNumber>((event, emit) async{
      emit(Loading());
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

      final result = inputEither.fold((l) => INPUT_FAILURE_MESSAGE, (r) => r);

      if(inputEither.isLeft()) {
        emit(Error(message: result as String));
      }else{
        final failureOrTrivia = await getConcreteNumberTrivia(Params(number: result as int));
        emit(
          failureOrTrivia.fold((l) => Error(message: l is ServerFailure ? SERVER_FAILURE_MESSAGE:CACHE_FAILURE_MESSAGE), (r) => Loaded(trivia: r))
        );
      }
    });

    on<GetTriviaForRandomNumber>((event, emit) async{
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      emit(
          failureOrTrivia.fold((l) => Error(message: l is ServerFailure ? SERVER_FAILURE_MESSAGE:CACHE_FAILURE_MESSAGE), (r) => Loaded(trivia: r))
      );


    });
  }

}
