import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiceGameApp());
}

class DiceGameApp extends StatelessWidget {
  const DiceGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DiceGameScreen(),
    );
  }
}

class DiceGameScreen extends StatefulWidget {
  const DiceGameScreen({Key? key}) : super(key: key);

  @override
  _DiceGameScreenState createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen> {
  int walletBalance = 10; // Initial balance
  int wager = 0;
  String gameType = "2 Alike"; // Default game type
  List<int> diceRolls = [1, 1, 1, 1]; // Initial dice values
  String message = "Welcome to the Dice Game!";

  // Method to roll dice and calculate result
  void rollDice() {
    if (wager <= 0 || wager > walletBalance) {
      setState(() {
        message = "Invalid wager! Please check your wallet balance.";
      });
      return;
    }

    // Roll dice
    diceRolls = List.generate(4, (_) => Random().nextInt(6) + 1);

    // Check results
    Map<int, int> counts = {};
    for (var dice in diceRolls) {
      counts[dice] = (counts[dice] ?? 0) + 1;
    }

    int multiplier = 0;
    if (gameType == "2 Alike" && counts.values.contains(2)) {
      multiplier = 2;
    } else if (gameType == "3 Alike" && counts.values.contains(3)) {
      multiplier = 3;
    } else if (gameType == "4 Alike" && counts.values.contains(4)) {
      multiplier = 4;
    }

    // Update wallet and message
    setState(() {
      if (multiplier > 0) {
        int winnings = wager * multiplier;
        walletBalance += winnings;
        message = "You won $winnings coins! Dice: $diceRolls";
      } else {
        walletBalance -= wager;
        message = "You lost $wager coins! Dice: $diceRolls";
      }

      // Reset wager
      wager = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dice Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Wallet Balance: $walletBalance coins",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: gameType,
              onChanged: (String? value) {
                setState(() {
                  gameType = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: "2 Alike", child: Text("2 Alike")),
                DropdownMenuItem(value: "3 Alike", child: Text("3 Alike")),
                DropdownMenuItem(value: "4 Alike", child: Text("4 Alike")),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Wager",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                wager = int.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: rollDice,
              child: const Text("Roll Dice"),
            ),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: diceRolls
                  .map((dice) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          dice.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
