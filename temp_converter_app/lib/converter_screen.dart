import 'package:flutter/material.dart';

enum ConversionType { fToC, cToF }

class TempConverterScreen extends StatefulWidget {
  const TempConverterScreen({super.key});

  @override
  State<TempConverterScreen> createState() => _TempConverterScreenState();
}

class _TempConverterScreenState extends State<TempConverterScreen> {
  ConversionType _selectedConversion = ConversionType.fToC;
  final TextEditingController _inputController = TextEditingController();
  String _convertedValue = '';
  final List<String> _history = [];

  void _convert() {
    final input = double.tryParse(_inputController.text);
    if (input == null) {
      setState(() {
        _convertedValue = 'Invalid input';
      });
      return;
    }
    double result;
    String historyEntry;
    if (_selectedConversion == ConversionType.fToC) {
      result = (input - 32) * 5 / 9;
      _convertedValue = result.toStringAsFixed(2);
      historyEntry = 'F to C: ${input.toStringAsFixed(2)} ➔ $_convertedValue';
    } else {
      result = input * 9 / 5 + 32;
      _convertedValue = result.toStringAsFixed(2);
      historyEntry = 'C to F: ${input.toStringAsFixed(2)} ➔ $_convertedValue';
    }
    setState(() {
      _history.insert(0, historyEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final inputField = SizedBox(
      width: 100,
      child: TextField(
        controller: _inputController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(border: OutlineInputBorder()),
        textAlign: TextAlign.center,
      ),
    );

    final outputField = SizedBox(
      width: 100,
      child: TextField(
        controller: TextEditingController(text: _convertedValue),
        readOnly: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        textAlign: TextAlign.center,
      ),
    );

    final conversionRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        inputField,
        const SizedBox(width: 10),
        const Text('=', style: TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        outputField,
      ],
    );

    final conversionSelector = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<ConversionType>(
          value: ConversionType.fToC,
          groupValue: _selectedConversion,
          onChanged: (val) => setState(() => _selectedConversion = val!),
        ),
        const Text('Fahrenheit to Celsius'),
        const SizedBox(width: 20),
        Radio<ConversionType>(
          value: ConversionType.cToF,
          groupValue: _selectedConversion,
          onChanged: (val) => setState(() => _selectedConversion = val!),
        ),
        const Text('Celsius to Fahrenheit'),
      ],
    );

    final convertButton = SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: _convert,
        child: const Text('CONVERT'),
      ),
    );

    final historyList = Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _history.isEmpty
            ? const Text('No conversions yet.')
            : ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) => Text(_history[index]),
              ),
      ),
    );

    final content = isLandscape
        ? Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    conversionSelector,
                    const SizedBox(height: 16),
                    conversionRow,
                    const SizedBox(height: 16),
                    convertButton,
                  ],
                ),
              ),
              Expanded(child: historyList),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              conversionSelector,
              const SizedBox(height: 16),
              conversionRow,
              const SizedBox(height: 16),
              convertButton,
              historyList,
            ],
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Converter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
    );
  }
}
