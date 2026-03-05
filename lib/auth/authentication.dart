import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/auth/authenticationStreamer.dart';
import 'package:kiwihabitapp/pages/auth/loginPage.dart';
import 'package:kiwihabitapp/pages/home/homePage.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color.fromRGBO(21, 9, 35, 1),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xffE4EBDE)),
            ),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const LoginPage();
        }

        return MultiProvider(
          providers: [
            StreamProvider<DocumentSnapshot?>.value(
              value: UserStream(uid: user.uid).stream,
              initialData: null,
            ),
            StreamProvider<QuerySnapshot?>.value(
              value: ConfigStream().stream,
              initialData: null,
            ),
            ChangeNotifierProvider(
              create: (_) => ChallengeProvider(uid: user.uid),
            ),
          ],
          child: const HomePage(),
        );
      },
    );
  }
}
