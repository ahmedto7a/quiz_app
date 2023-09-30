import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/ranking_screen.dart';
import '../services/auth_service.dart';
import 'action_button.dart';


class RankAuthButton extends StatefulWidget {
  const RankAuthButton({Key? key}) : super(key: key);

  @override
  _RankAuthButtonState createState() => _RankAuthButtonState();
}

class _RankAuthButtonState extends State<RankAuthButton> {
  bool _isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn)
      return ActionButton(
        title: 'Ranking',
        onTap:
            () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RankingScreen(),
            ),
          );
        },
      );

    return ActionButton(
      isPrimary: false,
      title: 'Sign in with Google',
      onTap: () {
        if (kIsWeb) {
          AuthService.signInWithGoogleWeb();
          return;
        }
        AuthService.signInWithGoogle();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        setState(() {
          _isLoggedIn = false;
        });
        return;
      }

      setState(() {
        _isLoggedIn = true;
      });
    });
  }
}
