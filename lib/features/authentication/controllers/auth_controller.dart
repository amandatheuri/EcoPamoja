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
  final user = userCredential.user;

if (user != null) {
  final userDoc = await _firestore.collection('users').doc(user.uid).get();

  if (!userDoc.exists) {
    await _firestore.collection('users').doc(user.uid).set({
  'email': user.email ?? '',
  'username': user.displayName ?? 'Anonymous',
  'photoUrl': user.photoURL,  
  'createdAt': DateTime.now(),
  'lastActive': DateTime.now(),
  'lastReset': DateTime.now(),
  'streak': 0,
  'isAdmin': false,
  'badgesEarned': [],
  'completedSponsored': [],
  'quizzesCompleted': 0,
  'dailyHabitsCompleted': 0,
  'wasteReductionCompleted': 0,
  'totalChallengesCompleted': 0,
  'todayChallengesCompleted': 0,
  'dailyGoal': 3,
  'notificationsEnabled': true,
  'themeMode': 'dark',
  'hasSeenIntro': false,
  'groupsJoined': 0,
  'pointsEarned': 0,
    });
  }
}

  print('🟡 userCredential: ${userCredential.user}');
  return userCredential.user;
 }catch(e){
  print('🔴 Google Sign-In error: $e');
    return null;
 }
}

  //logic for login
  Future<UserCredential?> loginWithEmail({
  required String email,
  required String password,
}) async {
  try {
    // First: check if this email exists in admin list
    final checkAdmin = await _firestore.collection('admin_users').doc(email).get();

    if (checkAdmin.exists) {
      // This is an admin account block login on user side
      throw FirebaseAuthException(
        code: 'admin-account',
        message: 'This email is registered as an admin. Please use the admin app.',
      );
    }

    // Not an admin allow sign in
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    return userCredential;

  } on FirebaseAuthException catch (e) {
    print('❌ FirebaseAuth error: ${e.message}');
    return null;
  } catch (e) {
    print('❌ Unknown error: $e');
    return null;
  }
}

  //logic for username
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
final user = userCredential.user;
   if (user == null) return null;
    // Save user to Firestore
   await _firestore.collection('users').doc(userCredential.user!.uid).set({
  'email': user.email ?? '',
  'username': user.displayName ?? 'Anonymous',
  'photoUrl': user.photoURL,
  'createdAt': DateTime.now(),
  'lastActive': DateTime.now(),
  'lastReset': DateTime.now(),
  'streak': 0,
  'isAdmin': false,
  'badgesEarned': [],
  'completedSponsored': [], // ✅ important
  'quizzesCompleted': 0,
  'dailyHabitsCompleted': 0,
  'wasteReductionCompleted': 0,
  'totalChallengesCompleted': 0,
  'todayChallengesCompleted': 0,
  'dailyGoal': 3,
  'notificationsEnabled': true,
  'themeMode': 'dark',
  'hasSeenIntro': false,
  'groupsJoined': 0,
  'pointsEarned': 0,
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