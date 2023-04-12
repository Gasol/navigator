import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../login_state.dart';
import '../ui/create_account.dart';
import '../ui/details.dart';
import '../ui/error_page.dart';
import '../ui/home_screen.dart';
import '../ui/login.dart';
import '../ui/more_info.dart';
import '../ui/payment.dart';
import '../ui/personal_info.dart';
import '../ui/signin_info.dart';

class MyRouter {
  final LoginState loginState;

  MyRouter(this.loginState);

  late final GoRouter router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        name: rootRouteName,
        path: '/',
        redirect: (context, _) =>
            router.namedLocation(homeRouteName, params: {'tab': 'shop'}),
      ),
      GoRoute(
        name: loginRouteName,
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const Login(),
        ),
      ),
      GoRoute(
        name: createAccountRouteName,
        path: '/create-account',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const CreateAccount(),
        ),
      ),
      GoRoute(
        name: homeRouteName,
        // path: '/home/:tab',
        path: '/home/:tab(shop|cart|profile)',
        pageBuilder: (context, state) {
          final tab = state.params['tab']!;
          return MaterialPage<void>(
            key: state.pageKey,
            child: HomeScreen(tab: tab),
          );
        },
        routes: [
          GoRoute(
            name: subDetailsRouteName,
            path: 'details/:item',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: Details(description: state.params['item']!),
            ),
          ),
          GoRoute(
            name: profilePersonalRouteName,
            path: 'personal',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const PersonalInfo(),
            ),
          ),
          GoRoute(
            name: profilePaymentRouteName,
            path: 'payment',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const Payment(),
            ),
          ),
          GoRoute(
            name: profileSigninInfoRouteName,
            path: 'signin-info',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const SigninInfo(),
            ),
          ),
          GoRoute(
            name: profileMoreInfoRouteName,
            path: 'more-info',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const MoreInfo(),
            ),
          ),
        ],
      ),
      // forwarding routes to remove the need to put the 'tab' param in the code
      GoRoute(
        name: detailsRouteName,
        path: '/details-redirector/:item',
        redirect: (context, state) => router.namedLocation(
          subDetailsRouteName,
          params: {'tab': 'shop', 'item': state.params['item']!},
        ),
      ),
      GoRoute(
        name: personalRouteName,
        path: '/profile-personal',
        redirect: (context, _) => router.namedLocation(
          profilePersonalRouteName,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: paymentRouteName,
        path: '/profile-payment',
        redirect: (context, _) => router.namedLocation(
          profilePaymentRouteName,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: signinInfoRouteName,
        path: '/profile-signin-info',
        redirect: (context, _) => router.namedLocation(
          profileSigninInfoRouteName,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: moreInfoRouteName,
        path: '/profile-more-info',
        redirect: (context, _) => router.namedLocation(
          profileMoreInfoRouteName,
          params: {'tab': 'profile'},
        ),
      ),
    ],

    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),

    // redirect to the login page if the user is not logged in
    redirect: (context, state) {
      final loginLoc = router.namedLocation(loginRouteName);
      final loggingIn = state.subloc == loginLoc;
      final createAccountLoc = router.namedLocation(createAccountRouteName);
      final creatingAccount = state.subloc == createAccountLoc;
      final loginState = context.read<LoginState>();
      final loggedIn = loginState.loggedIn;

      String? returnLoc = null;
      if (!loggedIn && !loggingIn && !creatingAccount) {
        returnLoc = loginLoc;
      } else if (loggedIn && (loggingIn || creatingAccount)) {
        returnLoc = router.namedLocation(rootRouteName);
      }
      return returnLoc;
    },
  );
}
