import 'package:flutter/material.dart';
import 'package:fuel_exp_tracker_update/util/my_button.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller1,
    required this.controller2,
    required this.onCancel,
    required this.onSave,
  });

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  bool isPetrol = true; // Default to petrol

  @override
  void initState() {
    super.initState();
    // Initialize controller2 with the default value
    widget.controller2.text = isPetrol ? 'Petrol' : 'Diesel';
  }

  void _toggleFuelType(bool value) {
    setState(() {
      isPetrol = value;
      // Update controller2 based on the selected fuel type
      widget.controller2.text = isPetrol ? 'Petrol' : 'Diesel';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Container(
        height: 250, // Increased height to accommodate the toggle
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: widget.controller1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Total Cost",
              ),
            ),
            // Toggle switch for petrol/diesel selection
            SwitchListTile(
              title: Text(isPetrol ? 'Petrol' : 'Diesel'),
              value: isPetrol,
              onChanged: _toggleFuelType,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(text: "Save", onPressed: widget.onSave),
                MyButton(text: "Cancel", onPressed: widget.onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}