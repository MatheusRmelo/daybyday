import 'package:flutter/material.dart';

Future<String?> addTaskBottomSheet(BuildContext context) async {
  TextEditingController controller = TextEditingController(text: "");
  final formGlobalKey = GlobalKey<FormState>();

  return await showModalBottomSheet<String>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Form(
                key: formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Nome da tarefa",
                        style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: controller,
                          style: const TextStyle(color: Colors.black),
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: "Informe o nome da tarefa"),
                          textInputAction: TextInputAction.send,
                          validator: (String? value) {
                            if (value == null) {
                              return "Digite o nome da tarefa";
                            }
                            if (value.isEmpty) {
                              return "Digite o nome da tarefa";
                            }

                            return null;
                          },
                          onFieldSubmitted: (String? value) {
                            if (formGlobalKey.currentState!.validate()) {
                              Navigator.pop(context, controller.text);
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                        height: 48,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16, bottom: 8),
                        child: ElevatedButton(
                            child: const Text("Continuar"),
                            onPressed: () {
                              if (formGlobalKey.currentState!.validate()) {
                                Navigator.pop(context, controller.text);
                              }
                            })),
                  ],
                )),
          )).then((value) => value).catchError((err) => null);
}
