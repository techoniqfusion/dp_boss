import 'package:dp_boss/Providers/Add%20Upi%20Provider/add_upi_provider.dart';
import 'package:dp_boss/Providers/Bank%20Details%20List%20Provider/bank_details_list_provider.dart';
import 'package:dp_boss/Providers/Dashboard%20Provider/dashboard_provider.dart';
import 'package:dp_boss/Providers/Points%20Provider/points_provider.dart';
import 'package:dp_boss/Providers/Profile%20Update%20Provider/profile_update_provider.dart';
import 'package:dp_boss/Providers/Recover%20Password%20Provider/recover_password_provider.dart';
import 'package:dp_boss/Providers/Transaction%20History%20Provider/transaction_history_provider.dart';
import 'package:dp_boss/Providers/Verificartion%20Provider/verification_provider.dart';
import 'package:dp_boss/screens/Dashboard/dashboard.dart';
import 'package:dp_boss/screens/Login%20Screen/login_screen.dart';
import 'package:dp_boss/screens/OTP%20Screen/otp_screen.dart';
import 'package:dp_boss/utils/app_color.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Providers/Add Bank Details Provider/add_bank_details_provider.dart';
import 'Providers/Auth Provider/auth_provider.dart';
import 'Providers/Registration Provider/registration_provider.dart';
import 'Providers/Support Create Request Provider/support_create_request_provider.dart';
import 'Providers/Support History All Data Provider/support_history_provider.dart';
import 'Providers/Support History ID Provider/support_history_id_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  // showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  print("notification message ${message}");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
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
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
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
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecoverPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ProfileUpdateProvider()),
        ChangeNotifierProvider(create: (_) => AddBankDetailsProvider()),
        ChangeNotifierProvider(create: (_) => SupportHistoryProvider()),
        ChangeNotifierProvider(create: (_) => SupportCreateRequestProvider()),
        ChangeNotifierProvider(create: (_) => VerificationProvider()),
        ChangeNotifierProvider(create: (_) => SupportHistoryIdProvider()),
        ChangeNotifierProvider(create: (_) => BankDetailsListProvider()),
        ChangeNotifierProvider(create: (_) => PointsTransferProvider()),
        ChangeNotifierProvider(create: (_) => TransactionHistoryProvider()),
        ChangeNotifierProvider(create: (_) => AddUpiProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
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
        home: isLoggedIn
            ? const Dashboard()
            : isRegistered
                ? OtpScreen()
                : const LoginScreen(),
      ),
    );
  }
}
