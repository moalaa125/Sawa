import 'package:flutter/material.dart';

class Requests extends StatelessWidget {
  const Requests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          Center(
            child: Container(
              height: 80,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text('lolmohamedalaajj@gmail.com'),
                  SizedBox(width: 40),

                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 10),

                  Icon(Icons.close, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
