import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../../app/theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/icons.dart';
import '../../../widgets/inputs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String path = "/auth/login";
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _logIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      context.go('/home');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: TracelyIcon(
                path: 'assets/icons/Email.svg',
                size: 24,
                color: TracelyTheme.neutral200,
              ),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              isPassword: true,
              prefixIcon: TracelyIcon(
                path: 'assets/icons/Lock.svg',
                size: 24,
                color: TracelyTheme.neutral200,
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 15),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: PrimaryButton(
                label: _loading ? 'Logging in...' : 'Log in',
                onPressed: _loading ? null : () {
                  _logIn();
                },
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don’t have an account? "),
                GestureDetector(
                  onTap: () => context.push('/auth/signup'),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: TracelyTheme.links),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
