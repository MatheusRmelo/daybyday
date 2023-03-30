import 'package:daybyday/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                        child: const Text("Exclúi todos os meus dados"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
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
                          FirebaseAuth.instance.signOut();
                        },
                      ),
                    )
                  ]),
            );
          }),
    );
  }
}
