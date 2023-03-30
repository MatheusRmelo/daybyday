import 'package:daybyday/controllers/auth_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/field_error_extension.dart';
import 'package:daybyday/views/widgets/outlined_input.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:daybyday/views/widgets/snackbars/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dominant,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textNormal,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, AppRoutes.signIn);
            }
          },
        ),
      ),
      body: Consumer<AuthController>(builder: (context, controller, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Informe o e-mail para receber um link para redefinir sua senha",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 40,
              ),
              OutlinedInput(
                label: 'E-mail',
                prefixIcon: const Icon(Icons.email),
                placeholder: 'Digite o seu e-mail',
                controller: _emailController,
                error: controller.errors.getErrorWithCode('email'),
              ),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() => _isLoading = true);
                            controller
                                .sendPasswordResetEmail(
                                    email: _emailController.text)
                                .then((value) {
                              if (value.isEmpty) {
                                _emailController.text = '';
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SuccessSnackbar(
                                        content: const Text(
                                            "E-mail enviado com sucesso!")));
                              }
                              if (value.getErrorWithCode('general') != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorSnackbar(
                                        content: Text(value
                                            .getErrorWithCode('general')!)));
                              }
                              setState(() => _isLoading = false);
                            }).catchError((err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  ErrorSnackbar(content: Text(err.toString())));
                              setState(() => _isLoading = false);
                            });
                          },
                    child: _isLoading
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
                        : const Text('Mudar senha')),
              ),
            ]),
          ),
        );
      }),
    );
  }
}
