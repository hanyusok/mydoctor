import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mydoctor/pages/account_page.dart';
import 'package:mydoctor/pages/login_page.dart';
import 'package:mydoctor/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://tmrzeashfdqyxrryelqm.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtcnplYXNoZmRxeXhycnllbHFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTcwMzgxMjYsImV4cCI6MjAzMjYxNDEyNn0.UaBtO4AKE_eU9kuc-tQjVVYqsWqq4D0x9oVb_AuHg2w');
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myDoctor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage()
      },
    );
  }
}
