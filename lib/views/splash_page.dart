import 'package:daybyday/controllers/auth_controller.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthController>().checkAuthentication().then((authenticaded) {
      if (mounted) {
        if (authenticaded) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: size.width * 0.6,
        child: Image.asset('assets/images/logo.png'),
      )),
    );
  }
}
