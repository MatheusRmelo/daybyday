import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/models/field_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<FieldError> _errors = [];
  List<FieldError> get errors => _errors;

  void cleanErrors() {
    _errors = [];
    notifyListeners();
  }

  Future<User> reloadUser() async {
    if (auth.currentUser == null) throw Exception('Usuário não autenticado');
    await auth.currentUser!.reload();
    return auth.currentUser!;
  }

  Future<bool> sendVerificationEmail() async {
    if (auth.currentUser == null) throw Exception('Usuário não autenticado');
    if (auth.currentUser!.emailVerified) {
      throw Exception('E-mail já verificado');
    }
    await auth.currentUser!.sendEmailVerification();
    return true;
  }

  Future<List<FieldError>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    _errors = [];
    notifyListeners();
    try {
      var userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }
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
      } else if (e.code == 'invalid-email') {
        _errors.add(FieldError(code: 'email', message: 'E-mail não é válido'));
      } else if (e.code == 'too-many-requests') {
        _errors.add(FieldError(code: 'general', message: 'Muitas requisições'));
      } else {
        _errors.add(FieldError(code: 'general', message: 'Falha desconhecida'));
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
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
        }
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

  Future<List<FieldError>> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
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
      } else if (e.code == 'too-many-requests') {
        _errors.add(FieldError(code: 'general', message: 'Muitas requisições'));
      } else {
        _errors.add(FieldError(code: 'general', message: 'Falha desconhecida'));
      }
      notifyListeners();
      return _errors;
    }
  }

  Future<List<FieldError>> sendPasswordResetEmail(
      {required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return [];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/user-not-found') {
        // Send message success to user not know when user not exists
        return [];
      } else if (e.code == 'auth/invalid-email') {
        _errors.add(
            FieldError(code: 'email', message: 'E-mail ou senha inválidos'));
      } else {
        _errors.add(FieldError(code: 'general', message: 'Falha desconhecida'));
      }
      notifyListeners();
      return _errors;
    }
  }

  Future<void> deleteAllData() async {
    if (auth.currentUser == null) throw Exception('Usuário não autenticado');
    var weekCollection = FirebaseFirestore.instance.collection('weeks');
    var snapshots = await weekCollection
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get();
    for (var element in snapshots.docs) {
      await weekCollection.doc(element.id).delete();
    }
    await auth.currentUser!.delete();
  }
}
