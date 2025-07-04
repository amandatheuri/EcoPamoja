import 'package:flutter/material.dart';

class ActionChallengeType extends StatelessWidget{
  const ActionChallengeType({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      backgroundColor: const Color.fromARGB(255, 14, 86, 28),
      content: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height*0.25,
            maxWidth: MediaQuery.of(context).size.width*0.6,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Normal Challenge'),
                onPressed: () => Navigator.pop(context, 'normal'),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.campaign, color: Colors.yellow),
                label: const Text('Sponsored Challenge'),
                onPressed: () => Navigator.pop(context, 'sponsored'),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.quiz, color: Colors.brown),
                label: const Text('Quiz Challenge'),
                onPressed: () => Navigator.pop(context, 'Quiz'),
              ),
          ],),
        ),
      ),
    );
  }
}