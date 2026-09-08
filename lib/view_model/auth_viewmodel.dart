import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vroom/model/auth_exception.dart';
import 'package:vroom/model/user.dart';
import 'package:vroom/service/auth_api.dart';

enum AuthStatus { authenticated, unauthenticated }


class AuthViewModel extends ChangeNotifier {
  late AuthApi _authApi;
  User? user;
  String? errorMessage;
  bool isLoading = false;

 
  static const String ACCESS_TOKEN_KEY = 'ACCESS_TOKEN_KEY';
  static const String REFRESH_TOKEN_KEY = 'REFRESH_TOKEN_KEY';

  AuthStatus authStatus = AuthStatus.unauthenticated;

  AuthViewModel({AuthApi? authApi}) {
    _authApi = authApi ?? AuthApi();
    autoLogin();
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();
    bool success = false;
    try {
      var result = await _authApi.login(username, password);
      String accessToken = result.accessToken;
      String refreshToken = result.refreshToken;

     
      user = result.user;

      await saveTokens(accessToken, refreshToken);
      authStatus = AuthStatus.authenticated;
      success = true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      success = false;
      authStatus = AuthStatus.unauthenticated;
    } catch (e) {
      errorMessage = e.toString();
      authStatus = AuthStatus.unauthenticated;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();
    bool success = false;
    try {
      await _authApi.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      success = true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      success = false;
    } catch (e) {
      errorMessage = e.toString();
      success = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN_KEY, accessToken);
    await prefs.setString(REFRESH_TOKEN_KEY, refreshToken);
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString(ACCESS_TOKEN_KEY);
    String? refreshToken = prefs.getString(REFRESH_TOKEN_KEY);

    if (accessToken != null && refreshToken != null) {
      try {
        isLoading = true;
        notifyListeners();

     
        user = await _authApi.fetchCurrentUser(accessToken);
        authStatus = AuthStatus.authenticated;
      } catch (e) {
   
        try {
          final tokenResult = await _authApi.refresh(refreshToken);
          await saveTokens(tokenResult.accessToken, tokenResult.refreshToken);
          user = await _authApi.fetchCurrentUser(tokenResult.accessToken);
          authStatus = AuthStatus.authenticated;
        } catch (_) {
          authStatus = AuthStatus.unauthenticated;
        }
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_TOKEN_KEY);
    await prefs.remove(REFRESH_TOKEN_KEY);
    user = null;
    authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }
}