import 'package:learn_bloc_advance/core/error/exception.dart';
import 'package:learn_bloc_advance/features/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const KEY_CACHE = "CACHED_TRIVIA";

abstract class NumberTriviaLocalDataSource{
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSrouceImpl implements NumberTriviaLocalDataSource{

  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSrouceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(KEY_CACHE);
    if(jsonString!=null){
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }
    else{
      throw CacheException();
    }

  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(KEY_CACHE, json.encode(triviaToCache.toJson()));
  }

}