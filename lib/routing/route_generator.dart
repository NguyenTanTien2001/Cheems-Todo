import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/pages/auth/forgot_password/forgot_password_page.dart';
import 'package:to_do_list/pages/auth/reset_password/reset_password_page.dart';
import '/pages/auth/sign_up/sign_up_page.dart';
import '/pages/splash/splash_page.dart';
import '/pages/welcome/welcome_page.dart';
import '../pages/auth/sign_in/sign_in_page.dart';
import '../pages/auth/successful_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static RouteGenerator? _instance;

  RouteGenerator._();

  factory RouteGenerator() {
    _instance ??= RouteGenerator._();
    return _instance!;
  }

  Route<dynamic> onGenerateRoute(RouteSettings setting) {
    final uri = Uri.parse(setting.name!);
    GetPageRoute page({required Widget child}) {
      return GetPageRoute(
          settings: setting, page: () => child, transition: Transition.fadeIn);
    }

    switch (setting.name) {
      case AppRoutes.WELCOME:
        return page(child: WelcomePage.instance());
      case AppRoutes.SPLASH:
        return page(child: SplashPage.instance());
      case AppRoutes.SIGN_IN:
        return page(child: SignInPage.instance());
      case AppRoutes.SIGN_UP:
        return page(child: SignUpPage.instance());
      case AppRoutes.FORGOT_PASSWORD:
        return page(child: ForgotPasswordPage.instance());
      case AppRoutes.RESET_PASSWORD:
        return page(child: ResetPasswordPage.instance());
      case AppRoutes.SUCCESSFUL:
        return page(child: SuccessfulScreen());
      default:
        throw RouteException("Route not found");
    }
  }
}

class RouteException implements Exception {
  final String message;

  const RouteException(this.message);
}
