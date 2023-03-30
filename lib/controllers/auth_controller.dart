import 'package:daybyday/models/field_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<FieldError> _errors = [];
  List<FieldError> get errors => _errors;

  Future<List<FieldError>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    _errors = [];
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return [];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errors.add(
            FieldError(code: 'email', message: 'E-mail ou senha inválidos'));
        _errors.add(
            FieldError(code: 'password', message: 'E-mail ou senha inválidos'));
      } else if (e.code == 'wrong-password') {
        _errors.add(
            FieldError(code: 'email', message: 'E-mail ou senha inválidos'));
        _errors.add(
            FieldError(code: 'password', message: 'E-mail ou senha inválidos'));
      }
      notifyListeners();
      return _errors;
    }
  }

  Future<List<FieldError>> createUserWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    _errors = [];
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
      }
      return [];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errors
            .add(FieldError(code: 'email', message: 'E-mail já está em uso'));
      } else if (e.code == 'invalid-email') {
        _errors.add(FieldError(code: 'email', message: 'E-mail não é válido'));
      } else if (e.code == 'weak-password') {
        _errors.add(FieldError(
            code: 'password',
            message: 'Sua senha precisa ter no mínimo 6 caracteres'));
      }
      notifyListeners();
      return _errors;
    }
  }

  Future<bool> checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 1));
    return auth.currentUser != null;
  }
}
