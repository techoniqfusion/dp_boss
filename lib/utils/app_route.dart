import 'package:dp_boss/screens/Add%20Bank%20Account/add_bank_account.dart';
import 'package:dp_boss/screens/Add%20UPI%20Screen/add_upi_screen.dart';
import 'package:dp_boss/screens/Change%20Password%20Screen/change_password_screen.dart';
import 'package:dp_boss/screens/Create%20Request/create_request.dart';
import 'package:dp_boss/screens/Dashboard/dashboard.dart';
import 'package:dp_boss/screens/Deposit%20Screen/deposit_screen.dart';
import 'package:dp_boss/screens/Deposit%20Summary/deposit_summary.dart';
import 'package:dp_boss/screens/Edit%20Profile/edit_profile.dart';
import 'package:dp_boss/screens/Game%20Chart/game_chart.dart';
import 'package:dp_boss/screens/Game%20Details/game_details.dart';
import 'package:dp_boss/screens/Game%20Rate/game_rate.dart';
import 'package:dp_boss/screens/Help%20&%20Support/help_and_support.dart';
import 'package:dp_boss/screens/Notification%20Screen/notification.dart';
import 'package:dp_boss/screens/OTP%20Screen/otp_screen.dart';
import 'package:dp_boss/screens/Points%20Screen/points_screen.dart';
import 'package:dp_boss/screens/Recover%20Password/recover_password.dart';
import 'package:dp_boss/screens/Refer%20and%20Earn/refer_and_earn.dart';
import 'package:dp_boss/screens/Registration%20Screen/registration.dart';
import 'package:dp_boss/screens/Supreme%20Day%20Screen/supreme_day.dart';
import 'package:dp_boss/screens/Verify%20Screen/verify_screen.dart';
import 'package:dp_boss/screens/Wallet%20Screen/wallet_screen.dart';
import 'package:dp_boss/screens/Withdrawal%20All%20Data/withdrawal_all_data.dart';
import 'package:dp_boss/screens/Withdrawal%20Screen/withdrawal_screen.dart';
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
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => Dashboard(screenKey: arguments['key']));
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
      case AppScreen.pointsScreen:
        return MaterialPageRoute(builder: (_) => PointsScreen());
      case AppScreen.addUpiScreen:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => AddUPI(
                  upiType: arguments['upiType'],
                  upiId: arguments['upiId'],
                ));
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
      case AppScreen.supremeDay:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => SupremeDay(
                points: arguments['points'], gameName: arguments['gameName']));
      case AppScreen.depositScreen:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => DepositScreen(upiId: arguments['upiId']));
      case AppScreen.gameDetails:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => GameDetails(
                points: arguments['points'],
                gameType: arguments['gameType']));
      case AppScreen.depositSummary:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => DepositSummary(
                  upiId: arguments['upiId'],
                  amount: arguments['amount'],
                ));
      case AppScreen.withdrawalScreen:
        return MaterialPageRoute(builder: (_) => WithdrawalScreen());
      case AppScreen.withdrawalAllData:
        return MaterialPageRoute(builder: (_) => WithdrawalAllData());
      case AppScreen.gameRate:
        return MaterialPageRoute(builder: (_) => GameRate());
      case AppScreen.gameChart:
        return MaterialPageRoute(builder: (_) => GameChart());
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
  static const String pointsScreen = "pointsScreen";
  static const String addUpiScreen = "addUpiScreen";
  static const String supremeDay = "supremeDay";
  static const String depositScreen = "depositScreen";
  static const String depositSummary = "depositSummary";
  static const String withdrawalScreen = "withdrawalScreen";
  static const String withdrawalAllData = "withdrawalAllData";
  static const String gameRate = "gameRate";
  static const String gameDetails = "gameDetails";
  static const String gameChart = "gameChart";
}
