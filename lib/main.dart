import 'package:dosra_ghar/firebase_options.dart';
import 'package:dosra_ghar/providers/firebase_provider.dart';
import 'package:dosra_ghar/providers/menu_provider.dart';
import 'package:dosra_ghar/providers/user_provider.dart';
import 'package:dosra_ghar/utils/auth.dart';
import 'package:dosra_ghar/views/auth_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosra_ghar/views/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => MMenuProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreServiceProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DusraGhar',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: FutureBuilder<bool>(
              future: authProvider.isUserSignedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasData && snapshot.data!) {
                    return const ProfileScreen();
                  } else {
                    return const AuthView();
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
