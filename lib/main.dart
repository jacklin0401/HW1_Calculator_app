import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _display = '0'; // Current text shown on screen
  double? _firstOperand; // Stores the first number
  String? _operator;     // Stores +, -, *, or /
  bool _shouldReset = false; // Flag to clear screen for next number entry

  // logic for button presses
  void _onPressed(String btnText) {
    setState(() {
      if (btnText == 'C') {
        _reset();
      } else if (btnText == '±') {
        _toggleSign();
      } else if (['+', '-', '×', '÷'].contains(btnText)) {
        _handleOperator(btnText);
      } else if (btnText == '=') {
        _calculateResult();
      } else {
        _inputDigit(btnText);
      }
    });
  }

  void _inputDigit(String digit) {
    if (_display == '0' || _shouldReset || _display == 'Error') {
      _display = digit;
      _shouldReset = false;
    } else {
      _display += digit;
    }
  }

  void _handleOperator(String op) {
    _firstOperand = double.tryParse(_display);
    _operator = op;
    _shouldReset = true;
  }

  void _toggleSign() {
    if (_display == '0' || _display == 'Error') return;
    _display = _display.startsWith('-') ? _display.substring(1) : '-$_display';
  }

  void _calculateResult() {
    if (_firstOperand == null || _operator == null) return;
    double secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+': result = _firstOperand! + secondOperand; break;
      case '-': result = _firstOperand! - secondOperand; break;
      case '×': result = _firstOperand! * secondOperand; break;
      case '÷':
        if (secondOperand == 0) {
          _display = 'Error'; // Feature 3: Error Handling
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
    }

    _display = result % 1 == 0 ? result.toInt().toString() : result.toString();
    _firstOperand = null;
    _operator = null;
    _shouldReset = true;
  }

  void _reset() {
    _display = '0';
    _firstOperand = null;
    _operator = null;
    _shouldReset = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 70, color: Colors.white),
              ),
            ),
          ),
          // Buttons
          Expanded(
            flex: 2,
            child: _buildButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    final grid = [
      ['C', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '=']
    ];

    return Column(
      children: grid.map((row) {
        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: row.map((text) {
              return Expanded(
                flex: text == '0' ? 2 : 1, // '0' spans two columns
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getBtnColor(text),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _onPressed(text),
                    child: Text(text, style: const TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

Color _getBtnColor(String text) {
  if (['÷', '×', '-', '+', '='].contains(text)) {
    return Colors.orange;
  }
  if (['C', '±', '%'].contains(text)) {
    return Colors.grey.shade700;
  }
  return const Color(0xFF2C2C2C); 
}
}