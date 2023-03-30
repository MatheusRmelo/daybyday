import 'package:daybyday/controllers/auth_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/field_error_extension.dart';
import 'package:daybyday/views/widgets/outlined_input.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
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
              const Text(
                "Crie sua conta no DayByDay,",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "E comece a planejar sua semana",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 40,
              ),
              OutlinedInput(
                label: 'Nome',
                prefixIcon: const Icon(Icons.person),
                placeholder: 'Digite o nome',
                controller: _nameController,
                error: controller.errors.getErrorWithCode('name'),
              ),
              const SizedBox(
                height: 16,
              ),
              OutlinedInput(
                label: 'E-mail',
                prefixIcon: const Icon(Icons.email),
                placeholder: 'Digite o seu e-mail',
                controller: _emailController,
                error: controller.errors.getErrorWithCode('email'),
              ),
              const SizedBox(
                height: 16,
              ),
              OutlinedInput(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.remove_red_eye,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() => _obscureText = !_obscureText);
                  },
                ),
                obscureText: _obscureText,
                label: 'Senha',
                placeholder: "Digite a sua senha",
                controller: _passwordController,
                error: controller.errors.getErrorWithCode('password'),
              ),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() => _isLoading = true);
                            controller
                                .createUserWithEmailAndPassword(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then((value) {
                              if (value.isEmpty) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, AppRoutes.home, (route) => false);
                                return;
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
                        : const Text('Criar conta')),
              ),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(top: 24),
                child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() => _isLoading = true);
                            controller
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then((value) {
                              if (value.isEmpty) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, AppRoutes.home, (route) => false);
                                return;
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _isLoading
                            ? [
                                const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                const Text("Carregando...",
                                    style: TextStyle(color: Colors.white))
                              ]
                            : [
                                Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: FaIcon(
                                      FontAwesomeIcons.google,
                                      color: AppColors.secondary,
                                    )),
                                Text(
                                  'Continuar com Google',
                                  style: TextStyle(color: AppColors.secondary),
                                )
                              ])),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: TextButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.signIn);
                      }
                    },
                    child: const Text(
                      "Já tem conta? Entre agora!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              )
            ]),
          ),
        );
      }),
    );
  }
}
