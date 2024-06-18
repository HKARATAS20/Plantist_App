import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoDetailsScreen extends StatefulWidget {
  final bool isEditing;
  final String? initialPriority;
  final DateTime? initialDate;

  TodoDetailsScreen({
    required this.isEditing,
    this.initialPriority,
    this.initialDate,
  });

  @override
  _TodoDetailsScreenState createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  late DateTime _selectedDate;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedPriority = widget.initialPriority ?? 'Normal';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Todo' : 'Add Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedPriority,
              items: ['Low', 'Normal', 'High']
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate)}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }
}
