import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:learn_bloc_advance/core/error/exception.dart';
import 'package:learn_bloc_advance/core/error/failure.dart';
import 'package:learn_bloc_advance/features/data/models/number_trivia_model.dart';
import 'package:learn_bloc_advance/features/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  Map<String,dynamic> parseResponse(String responseBody){
    final parsed = json.decode(responseBody);
    return parsed;
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) async {
    final response = await _getFromApi(number);

    return NumberTriviaModel.fromJson(parseResponse(response.body));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await _getFromApi(null);

    return NumberTriviaModel.fromJson(parseResponse(response.body));
  }

  Future<Response> _getFromApi(int? number)async{
    final url = Uri.parse('http://numbersapi.com/${number!=null?number:'random'}');
    final response = await client.get(url,
      headers:
      {'Content-Type': 'application/json',},
    );

    if(response.statusCode == 200){
      return response;
    }else{
      throw ServerException();
    }
  }
}
