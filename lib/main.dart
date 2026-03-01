import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/anime_provider.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AnimeProvider())],
      child: const KazeAnimeApp(),
    ),
  );
}

class KazeAnimeApp extends StatelessWidget {
  const KazeAnimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaze V1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFF47521),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF47521),
          secondary: Color(0xFFFAB913),
          surface: Color(0xFF141519),
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF000000),
          selectedItemColor: Color(0xFFF47521),
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
            .copyWith(
              displayLarge: GoogleFonts.poppins(
                textStyle: ThemeData.dark().textTheme.displayLarge,
              ),
              displayMedium: GoogleFonts.poppins(
                textStyle: ThemeData.dark().textTheme.displayMedium,
              ),
              bodyLarge: GoogleFonts.poppins(
                textStyle: ThemeData.dark().textTheme.bodyLarge,
              ),
              bodyMedium: GoogleFonts.poppins(
                textStyle: ThemeData.dark().textTheme.bodyMedium,
              ),
            )
            .apply(
              fontFamilyFallback: ['Helvetica', '.SF Pro Display', 'Arial'],
            ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
