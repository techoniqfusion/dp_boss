import 'package:dp_boss/screens/Add%20Bank%20Account/add_bank_account.dart';
import 'package:dp_boss/screens/Change%20Password%20Screen/change_password_screen.dart';
import 'package:dp_boss/screens/Create%20Request/create_request.dart';
import 'package:dp_boss/screens/Dashboard/dashboard.dart';
import 'package:dp_boss/screens/Edit%20Profile/edit_profile.dart';
import 'package:dp_boss/screens/Help%20&%20Support/help_and_support.dart';
import 'package:dp_boss/screens/Notification%20Screen/notification.dart';
import 'package:dp_boss/screens/OTP%20Screen/otp_screen.dart';
import 'package:dp_boss/screens/Recover%20Password/recover_password.dart';
import 'package:dp_boss/screens/Refer%20and%20Earn/refer_and_earn.dart';
import 'package:dp_boss/screens/Registration%20Screen/registration.dart';
import 'package:dp_boss/screens/Verify%20Screen/verify_screen.dart';
import 'package:dp_boss/screens/Wallet%20Screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import '../screens/Chat Screen/chat_screen.dart';
import '../screens/Login Screen/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case "/" :
      //   return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppScreen.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppScreen.registration:
        return MaterialPageRoute(builder: (_) => const Registration());
      case AppScreen.recoverPassword:
        return MaterialPageRoute(builder: (_) => const RecoverPassword());
      case AppScreen.otpScreen:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => OtpScreen(
                  mobileNumber: arguments['mobile'],
                  isAppClosed: arguments['isAppClosed'],
                  isRecoverPassword: arguments['isRecoverPassword'],
                ));
      case AppScreen.dashboard:
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case AppScreen.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfile());
      case AppScreen.notificationScreen:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case AppScreen.addBankAccount:
        return MaterialPageRoute(builder: (_) => const AddBankAccount());
      case AppScreen.walletScreen:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case AppScreen.referAndEarn:
        return MaterialPageRoute(builder: (_) => const ReferAndEarn());
      case AppScreen.verifyScreen:
        return MaterialPageRoute(builder: (_) => const VerifyScreen());
      case AppScreen.helpAndSupport:
        return MaterialPageRoute(builder: (_) => const HelpAndSupport());
      case AppScreen.createRequest:
        return MaterialPageRoute(builder: (_) => const CreateRequest());
      case AppScreen.chatScreen:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ChatScreen(
              supportId: arguments['supportId'],
            ));

      case AppScreen.changePassword:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ChangePassword(
                  mobileNumber: arguments['mobile'],
                ));
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: const Center(
          child: Text("something went wrong"),
        ),
      );
    });
  }
}

class AppScreen {
  static const String login = "login";
  static const String registration = "registration";
  static const String recoverPassword = "RecoverPassword";
  static const String otpScreen = "otpScreen";
  static const String dashboard = "dashboard";
  static const String editProfile = "editProfile";
  static const String notificationScreen = "notificationScreen";
  static const String walletScreen = "walletScreen";
  static const String changePassword = "changePassword";
  static const String addBankAccount = "addBankAccount";
  static const String verifyScreen = "verifyScreen";
  static const String referAndEarn = "referAndEarn";
  static const String helpAndSupport = "helpAndSupport";
  static const String createRequest = "createRequest";
  static const String chatScreen = "chatScreen";
}
