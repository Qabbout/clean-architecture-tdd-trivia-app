import 'dart:convert';

import 'package:clean_arch_tdd_trivia_app/core/error/exceptions.dart';
import 'package:clean_arch_tdd_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_tdd_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;

import '../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl datasource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSucces200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group('getConcreteNumberTrivia ', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      //arrange
      setUpMockHttpClientSucces200();
      //act
      datasource.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return NumberTrivia when response code is 200 (success)',
        () async {
      //arrange

      setUpMockHttpClientSucces200();
      //act
      final result = await datasource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = datasource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('getRandomNumberTrivia ', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with random being the endpoint and with application/json header',
        () async {
      //arrange
      setUpMockHttpClientSucces200();
      //act
      datasource.getRandomNumberTrivia();

      //assert
      verify(mockHttpClient.get('http://numbersapi.com/random', headers: {
        'Content-Type': 'application/json',
      }));
    });

    test(
        'should return a random NumberTrivia when response code is 200 (success)',
        () async {
      //arrange

      setUpMockHttpClientSucces200();
      //act
      final result = await datasource.getRandomNumberTrivia();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = datasource.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
