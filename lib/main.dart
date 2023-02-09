import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/core/services/notificationsApi.dart';
import 'package:peterjustesen/firebase_options.dart';
import 'package:peterjustesen/ui/screens/HomeScreen.dart';
import 'package:peterjustesen/ui/screens/LoginScreen.dart';
import 'package:peterjustesen/ui/screens/Tabs/MainScreen.dart';
import 'core/bloc/cart_bloc.dart';
import "core/constants/constants.dart";
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final storage = await HydratedStorage.build(storageDirectory: directory);
  HydratedBloc.storage = storage;

  runApp(MyApp());

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Color(0xFF212C62)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Color.fromARGB(255, 20, 26, 58).withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    NotificationsApi.init();
    listenForNotifications();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<PeterMainBloc>(
              create: (context) => PeterMainBloc(),
            ),
            BlocProvider<CartBloc>(
              create: (context) => CartBloc(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Peter Justeson',
            theme: ThemeData(
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            // You can use the library anywhere in the app even in theme
            home: child,
            builder: EasyLoading.init(),
            // splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.scale,
          ),
        );
      },
      child: Builder(builder: (context) {
        return Scaffold(
            body: AnimatedSplashScreen(
                duration: 800,
                backgroundColor: primaryColor,
                splash: 'assets/images/PJ_logo_white 1.png',
                nextScreen: FirebaseAuth.instance.currentUser == null ? LoginScreen() : MainScreen()));
      }),
    );
  }
  
  void listenForNotifications() {
    NotificationsApi.notificationsStream.listen((notification) {
      NotificationsApi.showNotification(title: notification.title ?? '', body: notification.body ?? '');
    });
  }
}
