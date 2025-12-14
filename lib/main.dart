import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/app_shell.dart';

/// MBUY Application
/// Clean Architecture - Worker-Only Backend
///
/// This app communicates exclusively with Cloudflare Worker
/// No direct Supabase integration in Flutter code
///
/// هيكل مزدوج: تطبيقين منفصلين (عميل + تاجر)
/// يتم تحديد التطبيق عبر RootController
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: AppShell()));
}
