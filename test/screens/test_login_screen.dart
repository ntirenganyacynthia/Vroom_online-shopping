import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vroom/model/user.dart';
import 'package:vroom/view_model/auth_viewmodel.dart';
import 'package:vroom/screens/login_screen.dart';

class MockAuthViewModel extends ChangeNotifier implements AuthViewModel {
  @override
  AuthStatus authStatus = AuthStatus.unauthenticated;

  @override
  String? errorMessage;

  @override
  User? user;

  @override
  bool isLoading = false;

  @override
  bool get hasListeners => super.hasListeners;

  bool loginCalled = false;
  bool loginSuccess = true;

  @override
  Future<bool> login(String username, String password) async {
    loginCalled = true;
    return loginSuccess;
  }

  bool signupCalled = false;
  bool signupSuccess = true;

  @override
  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    signupCalled = true;
    return signupSuccess;
  }

  @override
  Future<void> autoLogin() async {

  }

  @override
  Future<void> logout() async {
    
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
   
  }
}

Widget _wrap(MockAuthViewModel vm) {
  return MaterialApp(
    home: ChangeNotifierProvider<AuthViewModel>.value(
      value: vm,
      child: const LoginScreen(),
    ),
  );
}

void main() {
  late MockAuthViewModel mockAuthViewModel;

  setUp(() {
    mockAuthViewModel = MockAuthViewModel();
  });

  testWidgets('shows validation errors', (tester) async {
    await tester.pumpWidget(_wrap(mockAuthViewModel));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(mockAuthViewModel.loginCalled, isFalse);
  });
}