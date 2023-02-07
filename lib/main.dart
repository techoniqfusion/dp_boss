import 'package:dp_boss/Providers/Profile%20Update%20Provider/profile_update_provider.dart';
import 'package:dp_boss/Providers/Recover%20Password%20Provider/recover_password_provider.dart';
import 'package:dp_boss/screens/Dashboard/dashboard.dart';
import 'package:dp_boss/screens/Login%20Screen/login_screen.dart';
import 'package:dp_boss/screens/OTP%20Screen/otp_screen.dart';
import 'package:dp_boss/utils/app_color.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Providers/Add Bank Details Provider/add_bank_details_provider.dart';
import 'Providers/Auth Provider/auth_provider.dart';
import 'Providers/Registration Provider/registration_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool isLoggedIn = false;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    checkUserExist();
  }

  checkUserExist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
      isRegistered = prefs.getBool("isRegistered") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // statusBarIconBrightness:  Brightness.light,
        statusBarColor: AppColor.black));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> RegistrationProvider()),
        ChangeNotifierProvider(create: (_)=> AuthProvider()),
        ChangeNotifierProvider(create: (_)=> RecoverPasswordProvider()),
        ChangeNotifierProvider(create: (_)=> ProfileUpdateProvider()),
        ChangeNotifierProvider(create: (_)=> AddBankDetailsProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'DP Boss',
        home: isLoggedIn ? const Dashboard() : isRegistered ? OtpScreen(): const LoginScreen(),
      ),
    );
  }
}
