import 'user.dart'; 

class LoginResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.user,        
    required this.accessToken, 
    required this.refreshToken, 
  });
}
