import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/firebase_options.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/views/add_task_page.dart';
import 'package:daybyday/views/config_day_page.dart';
import 'package:daybyday/views/home_page.dart';
import 'package:daybyday/views/planning_week_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => WeekController()),
      ChangeNotifierProvider(create: (_) => TaskController()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: AppColors.secondary,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.secondary),
          scaffoldBackgroundColor: AppColors.dominant,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(8),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.error),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.secondary),
                borderRadius: BorderRadius.circular(8)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.2),
          ),
          textTheme: GoogleFonts.ralewayTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)))),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.dominant,
                  textStyle: TextStyle(color: AppColors.secondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)))),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
          ))),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.addTask: (context) => const AddTaskPage(),
        AppRoutes.configDay: (context) => const ConfigDayPage(),
        AppRoutes.plannigWeek: (context) => const PlanningWeekPage(),
      },
    );
  }
}
