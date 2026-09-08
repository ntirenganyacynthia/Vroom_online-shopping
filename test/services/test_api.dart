import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:vroom/service/auth_api.dart';
import 'package:vroom/model/auth_exception.dart';

class MockHttpClient extends Mock implements http.Client {}

void main(){
  late MockHttpClient mockClient;
  late AuthApi authApi;

  setUp((){
    mockClient = MockHttpClient();
    authApi = AuthApi(client: mockClient);
    registerFallbackValue(Uri.parse("http://dummy.url"));
  });
  
  group ('login', (){
    test('returns AuthResult on success', () async{
      final dummyResponse = {
        'id': 1,
        'username': 'Jack',
        'email': 'jack@beanstalk.com',
        'firstName': 'Jack',
        'lastName': 'Black',
        'image': 'http:image.link',
        'gender': 'male',
        'accessToken': 'access123',
        'refreshToken': 'refresh123'
      };

      when(()=> mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => 
      http.Response(jsonEncode(dummyResponse), 200));

      final result = await authApi.login('jack','jackpassword');
      expect(result.accessToken, 'access123');
      expect(result.user.firstName, 'Jack');
    });

    test('test failed login', () async {

      when(()=> mockClient.post(any(),
      
      headers: any(named: 'headers'),
      body: any(named: 'body'),
      ),
      ).thenAnswer((_) async => 
      http.Response(jsonEncode({'message': 'Invalid credentials'}), 400));

      expect(()=> authApi.login('blacks','wrongpass'), throwsA(
        isA<AuthException>().having((e)=> e.toString(),
        'message',
        contains('Invalid credentials'),
        ),
      ));
    });
  });
}