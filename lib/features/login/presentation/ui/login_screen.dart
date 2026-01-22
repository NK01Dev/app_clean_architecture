import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/route/route_name.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Column(children: [Center(child: Text('Login')),
        IconButton.filled(onPressed: (
            ) {
          context.goNamed(signUpRoute);
          debugPrint('ll');
        }, icon: Icon(Icons.login))]),
      ),
    );
  }
}
