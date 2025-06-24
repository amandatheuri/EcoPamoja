// ignore_for_file: depend_on_referenced_packages, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authControllerProvider = Provider((ref)=> AuthController());

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //logic for sign in with google
Future<User?> signInWithGoogle()async{
 try{
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  print('🔵 googleUser: $googleUser');
  if(googleUser==null)return null;
  final GoogleSignInAuthentication googleAuth= await googleUser.authentication;
  print('🟢 googleAuth: accessToken=${googleAuth.accessToken}, idToken=${googleAuth.idToken}');
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken
  );
  final userCredential= await  _auth.signInWithCredential(credential);
  print('🟡 userCredential: ${userCredential.user}');
  return userCredential.user;
 }catch(e){
  print('🔴 Google Sign-In error: $e');
    return null;
 }
}

  //logic for login
  Future<UserCredential?>loginWithEmail({
    required String email,
    required String password,
  })async{
    try{
      // ignore: non_constant_identifier_names
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }on FirebaseAuthException catch (e){
      print('Login error ${e.message}');
      return null;
    }
  }
  //logic for sign up
 Future<bool> checkUsernameExists(String username) async {
  final result = await _firestore
      .collection('users')
      .where('username', isEqualTo: username)
      .get();

  return result.docs.isNotEmpty;
}

Future<User?> registerWithEmail({
  required String email,
  required String password,
  required String username,
}) async {
  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user to Firestore
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return userCredential.user;
  } catch (e) {
    print('Registration error: $e');
    return null;
  }
}
Future<void> sendPasswordResetEmail(String email)async{
  await _auth.sendPasswordResetEmail(email: email);
}
  }