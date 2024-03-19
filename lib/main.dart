import 'package:flutter/material.dart';
import 'package:nike_shop/ui/root.dart';

import 'data/repo/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(fontFamily: 'Estedad');

    return MaterialApp(
      title: 'فروشگاه نایک',
      theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          hintColor: lightColorScheme.onBackground.withOpacity(0.1),
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: lightColorScheme.outline.withOpacity(0.3),
              ),
            ),
          ),
          textTheme: TextTheme(
              //bodyText2
              bodySmall: defaultTextStyle,
              //caption
              labelLarge: defaultTextStyle,
              //headline6
              titleMedium:
                  defaultTextStyle.copyWith(fontWeight: FontWeight.w700))),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff217CF3),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD7E2FF),
  onPrimaryContainer: Color(0xFF001A40),
  secondary: Color(0xff262A35),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD9E2FF),
  onSecondaryContainer: Color(0xFF001944),
  tertiary: Color(0xFF705574),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFBD7FC),
  onTertiaryContainer: Color(0xFF29132E),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFEFBFF),
  onBackground: Color(0xFF1B1B1F),
  surface: Color(0xFFFEFBFF),
  onSurface: Color(0xFF1B1B1F),
  surfaceVariant: Color(0xFFE0E2EC),
  onSurfaceVariant: Color(0xFF44474E),
  outline: Color(0xFF74777F),
  onInverseSurface: Color(0xFFF2F0F4),
  inverseSurface: Color(0xFF2F3033),
  inversePrimary: Color(0xFFACC7FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF005BBE),
  outlineVariant: Color(0xFFC4C6D0),
  scrim: Color(0xFF000000),
);
