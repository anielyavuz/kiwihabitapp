// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/auth/authenticationStreamer.dart';
import 'package:kiwihabitapp/firebase_options.dart';
import 'package:kiwihabitapp/services/local_notification_service.dart';
import 'package:kiwihabitapp/l10n/l10n.dart';
import 'package:kiwihabitapp/l10n/app_localizations.dart';
import 'package:kiwihabitapp/pages/auth/loginPage.dart';
import 'package:kiwihabitapp/pages/home/homePage.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox("kiwiHive");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationsServices().initialiseNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still connecting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildApp(
            home: Scaffold(
              backgroundColor: Color.fromRGBO(21, 9, 35, 1),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xffE4EBDE)),
              ),
            ),
          );
        }

        final user = snapshot.data;

        // Unauthenticated → show login
        if (user == null) {
          return _buildApp(home: LoginPage());
        }

        // Authenticated — MultiProvider wraps MaterialApp so its Navigator
        // (and every pushed route) inherits all providers.
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
          child: _buildApp(home: HomePage()),
        );
      },
    );
  }

  /// Shared MaterialApp config reused for both authenticated and
  /// unauthenticated states.
  Widget _buildApp({required Widget home}) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
