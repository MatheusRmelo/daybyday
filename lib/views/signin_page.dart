import 'package:daybyday/controllers/auth_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/field_error_extension.dart';
import 'package:daybyday/views/widgets/outlined_input.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: null, elevation: 0, backgroundColor: Colors.transparent),
      body: Consumer<AuthController>(builder: (context, controller, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Bem vindo ao DayByDay,",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Entre agora e planeje sua semana",
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
                onChanged: (value) {
                  setState(() {});
                },
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
                onChanged: (value) {
                  setState(() {});
                },
                error: controller.errors.getErrorWithCode('password'),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.recoveryPassword);
                        },
                        child: const Text(
                          "Esqueci minha senha",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                    onPressed: _isLoading ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty
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
                        : const Text('Entrar')),
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
                            controller.signInWithGoogle().then((value) {
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
                                  'Entrar com Google',
                                  style: TextStyle(color: AppColors.secondary),
                                )
                              ])),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: TextButton(
                    onPressed: () {
                      controller.cleanErrors();
                      Navigator.pushNamed(context, AppRoutes.signUp);
                    },
                    child: const Text(
                      "Não tem conta ainda? Crie uma agora!",
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
