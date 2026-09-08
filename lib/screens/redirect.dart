import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:vroom/screens/home_screen.dart';
import 'package:vroom/screens/login_screen.dart';
import 'package:vroom/view_model/auth_viewmodel.dart';

class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        var status = authViewModel.authStatus;

        switch (status) {
          case AuthStatus.authenticated: 
            return const HomeScreen();
            
          case AuthStatus.unauthenticated: 
            return const LoginScreen();
        }
      },
    );
  }
}
