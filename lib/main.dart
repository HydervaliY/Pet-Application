import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: PetNameScreen(),
  ));
}

class PetNameScreen extends StatefulWidget {
  @override
  _PetNameScreenState createState() => _PetNameScreenState();
}

class _PetNameScreenState extends State<PetNameScreen> {
  TextEditingController _nameController = TextEditingController();

  void _startApp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalPetApp(petName: _nameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text('Enter Pet Name', style: TextStyle(fontFamily: 'RobotoMono')),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Pet Name',
                  labelStyle: TextStyle(fontFamily: 'RobotoMono'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontFamily: 'RobotoMono'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _startApp,
                child: Text('Start', style: TextStyle(fontFamily: 'RobotoMono')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalPetApp extends StatefulWidget {
  final String petName;

  DigitalPetApp({required this.petName});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _timer;
  Timer? _winTimer;
  int _winDuration = 0; // Track the duration the happiness level is above 80

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  void _startHungerTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 10).clamp(0, 100);
        _updateHappiness();
        _checkWinLossCondition();
      });
    });
  }

  void _startWinTimer() {
    _winTimer?.cancel(); // Cancel any existing win timer
    _winTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _winDuration++;
      if (_winDuration >= 180) { // 180 seconds = 3 minutes
        _showEndDialog("You Win!", "Your pet is very happy for 3 minutes!");
        timer.cancel();
      }
    });
  }

  void _resetWinTimer() {
    _winTimer?.cancel();
    _winDuration = 0;
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _checkWinLossCondition();
    });
    _showSnackBar("You played with your pet!");
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkWinLossCondition();
    });
    _showSnackBar("You fed your pet!");
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  String _getMood() {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }

  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  void _checkWinLossCondition() {
    if (happinessLevel > 80) {
      if (_winDuration == 0) {
        _startWinTimer();
        _showEndDialog("You win", "Your pet is happy!");

      }
    } else {
      _resetWinTimer();
    }

    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _showEndDialog("Game Over", "Your pet is too hungry and unhappy!");
    }
  }

  void _showEndDialog(String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: 'RobotoMono')),
          content: Text(message, style: TextStyle(fontFamily: 'RobotoMono')),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  happinessLevel = 50;
                  hungerLevel = 50;
                  _winDuration = 0;
                  _winTimer?.cancel();
                });
              },
              child: Text('Restart', style: TextStyle(fontFamily: 'RobotoMono')),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      );
    });
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(fontFamily: 'RobotoMono')),
      backgroundColor: Colors.teal,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Digital Pet', style: TextStyle(fontFamily: 'RobotoMono')),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: ${widget.petName}',
              style: TextStyle(fontSize: 24.0, fontFamily: 'RobotoMono'),
            ),
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 60.0,
              backgroundColor: _getPetColor(),
              child: Icon(Icons.pets, size: 80.0, color: Colors.white),
            ),
            SizedBox(height: 20.0),
            LinearProgressIndicator(
              value: happinessLevel / 100,
              backgroundColor: Colors.red,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10.0,
            ),
            SizedBox(height: 10.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0, fontFamily: 'RobotoMono'),
            ),
            SizedBox(height: 10.0),
            LinearProgressIndicator(
              value: hungerLevel / 100,
              backgroundColor: Colors.green,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              minHeight: 10.0,
            ),
            SizedBox(height: 10.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0, fontFamily: 'RobotoMono'),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet', style: TextStyle(fontFamily: 'RobotoMono')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet', style: TextStyle(fontFamily: 'RobotoMono')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }
}