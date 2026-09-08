import 'package:vroom/model/login_response.dart';
import 'package:vroom/model/token_response.dart';
import 'package:vroom/model/user.dart';
import 'package:vroom/model/auth_exception.dart';
import 'package:vroom/service/auth_api.dart';
import 'package:vroom/view_model/auth_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthApi extends Mock implements AuthApi {}

User _mockUser = User(
  id: 1,
  username: 'andy',
  email: 'andy@gmail.com',
  firstName: 'Andy',
  lastName: 'Laique',
  gender: 'female',
  image: 'http://image.url',
);

void main() {
  late MockAuthApi mockApi;

  setUpAll(() {
    registerFallbackValue(_mockUser);
  });

  setUp(() {
    mockApi = MockAuthApi();
  });

  group('login', () {
    test('successful login sets authenticated status and user (happy path)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.login('andy', 'andypassword')).thenAnswer(
        (_) async => LoginResponse(
          user: _mockUser,
          accessToken: 'access123',
          refreshToken: 'refresh123',
        ),
      );

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.login('andy', 'andypassword');

      expect(success, isTrue);
      expect(vm.authStatus, AuthStatus.authenticated);
      expect(vm.user?.firstName, _mockUser.firstName);
      expect(vm.isLoading, isFalse);
    });

    test('wrong password throws AuthException, stays unauthenticated (negative)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.login('andy', 'wrongpassword'))
          .thenThrow(AuthException('Invalid credentials'));

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.login('andy', 'wrongpassword');

      expect(success, isFalse);
      expect(vm.authStatus, AuthStatus.unauthenticated);
      expect(vm.errorMessage, 'Invalid credentials');
      expect(vm.user, isNull);
      expect(vm.isLoading, isFalse);
    });

    test('unexpected/network error is caught and surfaced as errorMessage (edge case)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.login('andy', 'andypassword'))
          .thenThrow(Exception('Network unreachable'));

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.login('andy', 'andypassword');

      expect(success, isFalse);
      expect(vm.authStatus, AuthStatus.unauthenticated);
      expect(vm.errorMessage, contains('Network unreachable'));
      expect(vm.isLoading, isFalse);
    });

    test('empty username is passed straight through to the API (boundary)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.login('', 'somepassword'))
          .thenThrow(AuthException('Username required'));

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.login('', 'somepassword');

      expect(success, isFalse);
      expect(vm.errorMessage, 'Username required');
    });
  });

  group('signup', () {
    test('successful signup returns true (happy path)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.register(
            firstName: 'Andy',
            lastName: 'Laique',
            email: 'andy@gmail.com',
            password: 'andypassword',
          )).thenAnswer((_) async => _mockUser);

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.signup(
        firstName: 'Andy',
        lastName: 'Laique',
        email: 'andy@gmail.com',
        password: 'andypassword',
      );

      expect(success, isTrue);
      expect(vm.isLoading, isFalse);
    });

    test('signup fails with AuthException when email already exists (negative)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.register(
            firstName: 'Andy',
            lastName: 'Laique',
            email: 'taken@gmail.com',
            password: 'andypassword',
          )).thenThrow(AuthException('Email already registered'));

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.signup(
        firstName: 'Andy',
        lastName: 'Laique',
        email: 'taken@gmail.com',
        password: 'andypassword',
      );

      expect(success, isFalse);
      expect(vm.errorMessage, 'Email already registered');
    });

    test('signup fails with a generic error and captures the message (edge case)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.register(
            firstName: 'Andy',
            lastName: 'Laique',
            email: 'andy@gmail.com',
            password: 'andypassword',
          )).thenThrow(Exception('Server unreachable'));

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.signup(
        firstName: 'Andy',
        lastName: 'Laique',
        email: 'andy@gmail.com',
        password: 'andypassword',
      );

      expect(success, isFalse);
      expect(vm.errorMessage, contains('Server unreachable'));
    });
  });

  group('autoLogin', () {
    test('no stored tokens leaves user unauthenticated, never calls API (boundary)', () async {
      SharedPreferences.setMockInitialValues({});

      final vm = AuthViewModel(authApi: mockApi);
      await vm.autoLogin();

      expect(vm.authStatus, AuthStatus.unauthenticated);
      expect(vm.user, isNull);
      verifyNever(() => mockApi.fetchCurrentUser(any()));
      verifyNever(() => mockApi.refresh(any()));
    });

    test('valid stored access token logs the user in automatically (happy path)', () async {
      SharedPreferences.setMockInitialValues({
        'ACCESS_TOKEN_KEY': 'validAccess',
        'REFRESH_TOKEN_KEY': 'validRefresh',
      });

      when(() => mockApi.fetchCurrentUser('validAccess'))
          .thenAnswer((_) async => _mockUser);

      final vm = AuthViewModel(authApi: mockApi);
      await vm.autoLogin();

      expect(vm.authStatus, AuthStatus.authenticated);
      expect(vm.user?.username, _mockUser.username);
    });

    test('expired access token triggers a refresh, then succeeds (edge case)', () async {
      SharedPreferences.setMockInitialValues({
        'ACCESS_TOKEN_KEY': 'expiredAccess',
        'REFRESH_TOKEN_KEY': 'validRefresh',
      });

      when(() => mockApi.fetchCurrentUser('expiredAccess'))
          .thenThrow(AuthException('Token expired'));
      when(() => mockApi.refresh('validRefresh')).thenAnswer(
        (_) async => TokenResponse(
          accessToken: 'newAccess',
          refreshToken: 'newRefresh',
        ),
      );
      when(() => mockApi.fetchCurrentUser('newAccess'))
          .thenAnswer((_) async => _mockUser);

      final vm = AuthViewModel(authApi: mockApi);
      await vm.autoLogin();

      expect(vm.authStatus, AuthStatus.authenticated);
      expect(vm.user?.username, _mockUser.username);
    });

    test('expired access token AND failed refresh leaves user unauthenticated (negative)', () async {
      SharedPreferences.setMockInitialValues({
        'ACCESS_TOKEN_KEY': 'expiredAccess',
        'REFRESH_TOKEN_KEY': 'expiredRefresh',
      });

      when(() => mockApi.fetchCurrentUser('expiredAccess'))
          .thenThrow(AuthException('Token expired'));
      when(() => mockApi.refresh('expiredRefresh'))
          .thenThrow(AuthException('Refresh token expired'));

      final vm = AuthViewModel(authApi: mockApi);
      await vm.autoLogin();

      expect(vm.authStatus, AuthStatus.unauthenticated);
      expect(vm.user, isNull);
      expect(vm.isLoading, isFalse);
    });
  });

  group('logout', () {
    test('logout clears the session and stored tokens (happy path)', () async {
      SharedPreferences.setMockInitialValues({});

      when(() => mockApi.login('andy', 'andypassword')).thenAnswer(
        (_) async => LoginResponse(
          user: _mockUser,
          accessToken: 'access123',
          refreshToken: 'refresh123',
        ),
      );

      final vm = AuthViewModel(authApi: mockApi);
      await vm.login('andy', 'andypassword');
      expect(vm.authStatus, AuthStatus.authenticated);

      await vm.logout();

      expect(vm.authStatus, AuthStatus.unauthenticated);
      expect(vm.user, isNull);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ACCESS_TOKEN_KEY'), isNull);
      expect(prefs.getString('REFRESH_TOKEN_KEY'), isNull);
    });

    test('logging out when already logged out is a safe no-op (boundary)', () async {
      SharedPreferences.setMockInitialValues({});

      final vm = AuthViewModel(authApi: mockApi);
      await vm.logout();

      expect(vm.authStatus, AuthStatus.unauthenticated);
      expect(vm.user, isNull);
    });
  });
}