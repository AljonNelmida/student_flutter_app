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
  late TextEditingController _courseController;
  late TextEditingController _yearController;
  bool _enrolled = true;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.student?.lastName ?? '');
    _courseController =
        TextEditingController(text: widget.student?.course ?? '');
    _yearController =
        TextEditingController(text: widget.student?.year.toString() ?? '');
    _enrolled = widget.student?.enrolled ?? true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _courseController.dispose();
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
              // Course
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter course' : null,
              ),
              // Year
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Year'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter year';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year <= 0) {
                    return 'Enter a valid year';
                  }
                  return null;
                },
              ),
              // Enrolled checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enrolled'),
                  Checkbox(
                    value: _enrolled,
                    onChanged: (value) {
                      setState(() {
                        _enrolled = value ?? true;
                      });
                    },
                  ),
                ],
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final student = Student(
                  id: widget.student?.id ?? '',
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  course: _courseController.text,
                  year: int.parse(_yearController.text),
                  enrolled: _enrolled,
                );

                if (widget.isUpdate) {
                  context.read<StudentBloc>().add(UpdateStudent(student.id, student));
                } else {
                  context.read<StudentBloc>().add(CreateStudent(student));
                }

                Navigator.pop(context); // Close the dialog on success
              } catch (e) {
                // Handle the exception and show a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to create student: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: Text(widget.isUpdate ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
