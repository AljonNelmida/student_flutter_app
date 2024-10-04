import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/student_bloc.dart';
import 'bloc/student_event.dart';
import 'repositories/student_repository_impl.dart';
import 'screens/student_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students App',
      home: BlocProvider(
        create: (context) => StudentBloc(StudentRepositoryImpl())..add(FetchStudents()),
        child: const StudentListScreen(),
      ),
    );
  }
}
