import 'package:daybyday/controllers/auth_controller.dart';
import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/views/widgets/dialogs/delete_dialog.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:daybyday/views/widgets/snackbars/success_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dominant,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Perfil",
          style: TextStyle(color: AppColors.textNormal),
        ),
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "Falha ao buscar usuário",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return Consumer<AuthController>(builder: (context, controller, _) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (snapshot.data != null)
                        Text(
                          snapshot.data!.displayName ?? "Não informado",
                          style: TextStyle(
                              color: AppColors.textNormal,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      if (snapshot.data != null)
                        Text(
                          snapshot.data!.email ?? "Não informado",
                          style: TextStyle(
                              fontSize: 16, color: AppColors.textNormal),
                        ),
                      Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(bottom: 24, top: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          onPressed: () {
                            showDeleteDialog(context, 'AÇÃO CRÍTICA!',
                                'Excluir todos os seus é uma ação irreversível',
                                () {
                              setState(() => _isDeleting = true);
                              controller.deleteAllData().then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SuccessSnackbar(
                                        content: const Text(
                                            "Dados excluídos com sucesso")));
                                Navigator.pushNamedAndRemoveUntil(context,
                                    AppRoutes.signIn, (route) => false);
                              }).catchError((err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorSnackbar(
                                        content: Text(err
                                                    is FirebaseAuthException &&
                                                err.code ==
                                                    'requires-recent-login'
                                            ? 'Ação sensível, precisa sair e entrar novamente para confirmar que é você'
                                            : err.toString())));
                                setState(() => _isDeleting = false);
                              });
                            });
                          },
                          child: const Text("Excluir todos os meus dados"),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(bottom: 64),
                        child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: const Icon(Icons.logout)),
                              const Text("Sair"),
                            ],
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              context.read<TaskController>().clean();
                              context.read<WeekController>().clean();
                            });
                          },
                        ),
                      )
                    ]),
              );
            });
          }),
    );
  }
}
