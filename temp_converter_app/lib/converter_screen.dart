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

    final inputField = TextField(
      controller: _inputController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Enter Temperature',
        prefixIcon: const Icon(Icons.thermostat_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final outputField = TextField(
      controller: TextEditingController(text: _convertedValue),
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Converted',
        prefixIcon: const Icon(Icons.check_circle_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final conversionSelector = Column(
      children: [
        ListTile(
          leading: Radio<ConversionType>(
            value: ConversionType.fToC,
            groupValue: _selectedConversion,
            onChanged: (val) => setState(() => _selectedConversion = val!),
          ),
          title: const Text('Fahrenheit to Celsius'),
        ),
        ListTile(
          leading: Radio<ConversionType>(
            value: ConversionType.cToF,
            groupValue: _selectedConversion,
            onChanged: (val) => setState(() => _selectedConversion = val!),
          ),
          title: const Text('Celsius to Fahrenheit'),
        ),
      ],
    );

    final convertButton = SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _convert,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(Icons.cached),
        label: const Text('Convert', style: TextStyle(fontSize: 16)),
      ),
    );

    final historyList = _history.isEmpty
        ? const Center(
            child: Text(
              'No conversions yet.',
              style: TextStyle(color: Colors.grey),
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _history.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(_history[index]),
              );
            },
          );

    final card = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            inputField,
            const SizedBox(height: 16),
            conversionSelector,
            const SizedBox(height: 16),
            outputField,
            const SizedBox(height: 20),
            convertButton,
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            card,
            const SizedBox(height: 20),
            const Text(
              'Conversion History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            historyList,
          ],
        ),
      ),
    );
  }
}
