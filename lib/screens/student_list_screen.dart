import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../models/student_model.dart';
import '../widgets/student_dialog.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showStudentDialog(context, isUpdate: false),
          ),
        ],
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentLoaded) {
            if (state.students.isEmpty) {
              return const Center(child: Text('No students found.'));
            }
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text('${student.firstName} ${student.lastName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course: ${student.course}'),
                        Text('Year: ${student.year}'),
                        Text('Enrolled: ${student.enrolled ? "Yes" : "No"}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showStudentDialog(
                            context,
                            isUpdate: true,
                            student: student,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, student),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is StudentError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  void _showStudentDialog(BuildContext context,
      {Student? student, required bool isUpdate}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StudentDialog(
          isUpdate: isUpdate,
          student: student,
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: Text('Are you sure you want to delete ${student.firstName} ${student.lastName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<StudentBloc>(context).add(DeleteStudent(student.id));
                Navigator.pop(dialogContext);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
