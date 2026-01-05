import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';

class TracelyApp extends StatelessWidget {
  const TracelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tracely',
      debugShowCheckedModeBanner: false,
      theme: TracelyTheme.theme,
      routerConfig: appRouter,
    );
  }
}
