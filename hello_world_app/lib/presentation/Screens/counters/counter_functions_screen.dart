import 'package:flutter/material.dart';

class CounterFunctionsScreen extends StatefulWidget {
  const CounterFunctionsScreen({super.key});

  @override
  State<CounterFunctionsScreen> createState() => _CounterFunctionsScreenState();
}

class _CounterFunctionsScreenState extends State<CounterFunctionsScreen> {
  int clickCounter = 0;
  String click = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Functions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                clickCounter = 0;
                click = " ";
              });
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$clickCounter',
              style: const TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text('$click', style: const TextStyle(fontSize: 25)),
          ],
        ),
      ),
      
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (clickCounter > 0) { 
                  clickCounter--;
                }
                if (clickCounter == 1) {
                  click = "click";
                } else {
                  click = "clicks";
                }
              });
            },
            child: const Icon(Icons.exposure_minus_1),
          ),
          
          const SizedBox(height: 10), 
          
          
          FloatingActionButton(
            onPressed: () {
              setState(() {
                clickCounter++;
                if (clickCounter == 1) {
                  click = "click";
                } else {
                  click = "clicks";
                }
              });
            },
            child: const Icon(Icons.plus_one),
          ),
        ],
      ),
    );
  }
}