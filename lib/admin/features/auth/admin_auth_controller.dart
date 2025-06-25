/*
  Step 1: create a class that does not extend anything
  Step 2: initialize firestore and authentication instances
  Step 3: create a future function signInAdmin that returns a nullable User, parameters: email, password
  Step 4: create a try catch block
  Step 5: initialize credentials that will check firebase auth for user
  Step 6: check whether user exist in firestore collection admin users
  Step 7: create if else stattements that will handle when user is in firestore or not
  Step 8: create a future function that returns a nullable user called sendEmailResetLink
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final adminAuthControllerProvider = Provider((ref) => AdminAuthController());
class AdminAuthController{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> signInUser({required String email, required String password}) async {
  try {
     if (kDebugMode) {
       print('🔐 Attempting Firebase login...');
     }
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
 if (kDebugMode) {
   print('✅ Firebase login success: ${credential.user?.email}');
 }
    final checkUser = await _firestore.collection('admin_users').doc(email).get();
       if (kDebugMode) {
         print('📝 Firestore check: ${checkUser.exists ? 'Admin exists' : 'Not an admin'}');
       }
    if (checkUser.exists) {
      return credential.user;
    } else {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'not-admin',
        message: 'You are not authorized as an admin.',
      );
    }
  } on FirebaseAuthException catch (e) {
    if(kDebugMode)print('❌ Admin login error: ${e.message}');
    return null;
  } catch (e) {
    if(kDebugMode)print('❌ Unknown error: $e');
    return null;
  }
}

  Future<void> sendPasswordReset(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    if (kDebugMode) {
      print("✅ Password reset email sent to $email");
    }
  } on FirebaseAuthException catch (e) {
    if (kDebugMode) {
      print("❌ Error sending reset email: ${e.message}");
    }
    rethrow;
  }
}
}