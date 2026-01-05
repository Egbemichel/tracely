import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../../app/theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/icons.dart';
import '../../../widgets/inputs.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String path = "/auth/signup";
  static const String routeName = "signup";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.register(
        name: _nameController.text.trim(),
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
    _nameController.dispose();
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
              'Create account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            CustomTextField(
              controller: _nameController,
              hintText: 'Name',
              prefixIcon: TracelyIcon(
                path: 'assets/icons/Profile.svg',
                size: 24,
                color: TracelyTheme.neutral200,
              ),
            ),
            const SizedBox(height: 20),

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
                label: _loading ? 'Creating account...' : 'Sign up',
                onPressed: _loading ? null : _signUp,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => context.push('/auth/login'),
                  child: const Text(
                    'Log in',
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
