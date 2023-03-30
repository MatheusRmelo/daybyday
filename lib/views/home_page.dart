import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/models/day.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/utils/extensions/task_extension.dart';
import 'package:daybyday/utils/extensions/week_extension.dart';
import 'package:daybyday/views/profile_page.dart';
import 'package:daybyday/views/tasks_page.dart';
import 'package:daybyday/views/widgets/circle_icon_button.dart';
import 'package:daybyday/views/widgets/day_card.dart';
import 'package:daybyday/views/widgets/notification_card.dart';
import 'package:daybyday/views/widgets/task_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [TaskPage(), ProfilePage()];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.signIn, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: Theme.of(context).primaryColor,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.grey[100]!,
                    color: Colors.black,
                    selectedIndex: _selectedIndex,
                    mainAxisAlignment: MainAxisAlignment.center,
                    onTabChange: ((index) =>
                        setState(() => _selectedIndex = index)),
                    tabs: const [
                      GButton(
                        icon: Icons.home,
                        text: 'Início',
                      ),
                      GButton(
                        icon: Icons.person,
                        text: 'Perfil',
                      )
                    ],
                  )))),
    );
  }
}
