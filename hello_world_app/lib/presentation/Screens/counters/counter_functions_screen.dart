import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    Color numeroColor = Colors.blue; 
    if (clickCounter > 0) {
      numeroColor = Colors.green;
    } else if (clickCounter < 0) {
      numeroColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Functions'),
        centerTitle: true,
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
              style: GoogleFonts.plaster( // <-- Tipografía Permanent Marker
                fontSize: 160,
                color: numeroColor,
              ),
            ),
            Text(
              '$click', 
              style: GoogleFonts.plaster(fontSize: 40) // <-- Aplicada también a la palabra
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                clickCounter--;
                if (clickCounter == 1 || clickCounter == -1) {
                  click = "click";
                } else if (clickCounter == 0) {
                  click = " ";
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
                if (clickCounter == 1 || clickCounter == -1) {
                  click = "click";
                } else if (clickCounter == 0) {
                  click = " ";
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