import 'package:app_clean_architecture/core/route/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //back button in left
        // leading: IconButton(
        //   onPressed: () {
        //     context.goNamed(loginRoute);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        title: Text('Signup Screen'),
        //title in center
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [Center(child: Text('Signup Screen'))]),
      ),
    );
  }
}
