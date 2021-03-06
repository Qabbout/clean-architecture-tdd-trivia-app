import 'dart:convert';

import 'package:clean_arch_tdd_trivia_app/core/error/exceptions.dart';
import 'package:clean_arch_tdd_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_tdd_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    test(
        'should return NumberTrivia from SharedPreferences when there is one in th cache',
        () async {
      //arrange
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture("trivia_cache.json")));
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cache.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();

      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
      'should throw CacheException when there is not a cached value',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //act
        final call = dataSource.getLastNumberTrivia;

        //assert
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () async {
      //removed arranged part because we cant test if theres is actual data from here
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      //assert
      final excpectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, excpectedJsonString));
    });
  });
}
