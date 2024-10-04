// lib/widgets/student_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../models/student_model.dart';

class StudentDialog extends StatefulWidget {
  final bool isUpdate;
  final Student? student;

  const StudentDialog({super.key, required this.isUpdate, this.student});

  @override
  _StudentDialogState createState() => _StudentDialogState();
}

class _StudentDialogState extends State<StudentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  String? _selectedCourse;
  late TextEditingController _yearController;
  bool _enrolled = true;

  final List<String> _courses = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.student?.lastName ?? '');
    _selectedCourse = widget.student?.course;
    _yearController =
        TextEditingController(text: widget.student?.year.toString() ?? '');
    _enrolled = widget.student?.enrolled ?? true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdate ? 'Update Student' : 'Create Student'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter first name' : null,
              ),
              // Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter last name' : null,
              ),
              // Course Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                decoration: const InputDecoration(labelText: 'Course'),
                items: _courses
                    .map((course) =>
                        DropdownMenuItem(value: course, child: Text(course)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select a course' : null,
              ),
              // Year
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter year';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < 1 || year > 5) {
                    return 'Enter a valid year (1-5)';
                  }
                  return null;
                },
              ),
              // Enrolled Switch
              SwitchListTile(
                title: const Text('Enrolled'),
                value: _enrolled,
                onChanged: (value) {
                  setState(() {
                    _enrolled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.isUpdate ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Access the StudentBloc
      final studentBloc = BlocProvider.of<StudentBloc>(context);
      // Alternatively:
      // final studentBloc = context.read<StudentBloc>();

      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final course = _selectedCourse!;
      final year = int.parse(_yearController.text.trim());

      final student = Student(
        id: widget.isUpdate ? widget.student!.id : '',
        firstName: firstName,
        lastName: lastName,
        course: course,
        year: year,
        enrolled: _enrolled,
      );

      if (widget.isUpdate) {
        studentBloc.add(UpdateStudent(student.id, student));
      } else {
        studentBloc.add(CreateStudent(student));
      }

      Navigator.pop(context);
    }
  }
}
