import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _loggedIn = false;

  LoginState(this.prefs) {
    checkLoggedIn();
  }

  bool get loggedIn => _loggedIn;
  set loggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool(loggedInKey) ?? false;
  }
}

class LoginScope extends InheritedNotifier<LoginState> {
  const LoginScope({
    required LoginState super.notifier,
    required super.child,
    super.key,
  });

  static LoginState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LoginScope>()!.notifier!;
}
