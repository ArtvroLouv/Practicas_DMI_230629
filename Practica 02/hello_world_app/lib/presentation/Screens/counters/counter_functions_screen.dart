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
              style: GoogleFonts.plaster(
                fontSize: 160,
                color: numeroColor,
              ),
            ),
            Text(
              '$click', 
              style: GoogleFonts.plaster(fontSize: 40)
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton( icon: Icons.refresh_rounded,
            onPressed: () {
              clickCounter=0;
              setState(() {
                
              });
            },),
          const SizedBox(height: 10),
          CustomButton( icon: Icons.exposure_minus_1_outlined,
            onPressed: () {
              clickCounter--;
              setState(() {
                
              });
            },),
          const SizedBox(height: 10),
          CustomButton( icon: Icons.plus_one,
            onPressed: () {
              clickCounter++;
              setState(() {
                
              });
            },),
          
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key, 
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // shape: const StadiumBorder(),
      enableFeedback: true,
      elevation: 20,
      onPressed: onPressed,
      child:  Icon(icon),
    );
  }
}