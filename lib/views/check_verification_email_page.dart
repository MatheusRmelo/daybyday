import 'package:daybyday/controllers/auth_controller.dart';
import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:daybyday/views/widgets/snackbars/success_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckVerificationEmailPage extends StatefulWidget {
  const CheckVerificationEmailPage({super.key});

  @override
  State<CheckVerificationEmailPage> createState() =>
      _CheckVerificationEmailPageState();
}

class _CheckVerificationEmailPageState
    extends State<CheckVerificationEmailPage> {
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.signIn, (route) => false);
        }
      } else if (user.emailVerified) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthController>(builder: (context, controller, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: const Text(
                    "Verificação de e-mail",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  "Um e-mail foi enviado para você, clique nele e verifique sua conta para acessar o sistema",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: double.infinity,
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                      onPressed: _isBusy
                          ? null
                          : () {
                              setState(() => _isBusy = true);
                              controller.sendVerificationEmail().then((value) {
                                setState(() => _isBusy = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SuccessSnackbar(
                                        content: const Text(
                                            "Sucesso ao enviar e-mail")));
                              }).catchError((err) {
                                setState(() => _isBusy = false);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorSnackbar(
                                        content: Text(err.toString())));
                              });
                            },
                      child: _isBusy
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text("Carregando...",
                                      style: TextStyle(color: Colors.white))
                                ])
                          : const Text("Reenviar e-mail")),
                ),
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        context.read<TaskController>().clean();
                        context.read<WeekController>().clean();
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.signIn, (route) => false);
                      });
                    },
                    child: const Text(
                      "Sair e voltar pro login",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))
              ]),
        );
      }),
    );
  }
}
