import 'package:flame/Flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hidden_blade_rescue_the_master/shinobis_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Blade: Rescue the Master',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ShinobisAdventure game = ShinobisAdventure();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    GameWidget(game: kDebugMode ? ShinobisAdventure() : game),
              ),
            );
          },
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}
