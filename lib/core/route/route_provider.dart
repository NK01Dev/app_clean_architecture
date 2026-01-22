import 'package:app_clean_architecture/core/route/route_name.dart' ;
import 'package:app_clean_architecture/features/signup/presentation/ui/signup_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/login/presentation/ui/login_screen.dart';

final goRouteProvide = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [

      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/login',
        name: loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: signUpRoute,
        builder: (context, state) => const SignupScreen(),
      ),
    ]
  );
});
