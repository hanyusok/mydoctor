import 'dart:async';
// import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mydoctor/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email for a login link!')),
        );
        _emailController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInKakao() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithOAuth(OAuthProvider.kakao

          // OAuthProvider.kakao,
          // {redirectto: dotenv.env['REDIRECT_URI']!}
          // email: _emailController.text.trim(),
          // emailRedirectTo:
          //     kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
          );

      // await _kakaoLogin();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your kakao link!')),
        );
        _emailController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Future<void> _kakaoLogin() async {
  //   bool talkInstalled = await isKakaoTalkInstalled();
  //   if (talkInstalled) {
  //     try {
  //       await AuthCodeClient.instance.authorizeWithTalk(
  //         // redirectUri: '${REDIRECT_URI}',
  //         redirectUri: dotenv.env['REDIRECT_URI']!,
  //       );
  //     } catch (error) {
  //       log('Login with Kakao Talk fails $error');
  //     }
  //   } else {
  //     // 카카오계정으로 로그인
  //     try {
  //       await AuthCodeClient.instance.authorize(
  //         // redirectUri: '${REDIRECT_URI}',
  //         redirectUri: dotenv.env['REDIRECT_URI']!,
  //       );
  //     } catch (error) {
  //       log('Login with Kakao Account fails. $error');
  //     }
  //   }
  // }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in via KakaoTalk'),
          ElevatedButton(
              onPressed: () {
                _signInKakao();
              },
              child: Text(_isLoading ? 'Loading' : 'Send KakaoTalk')),
          const Spacer(),
          const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: Text(_isLoading ? 'Loading' : 'Send Magic Link'),
          ),
        ],
      ),
    );
  }
}
