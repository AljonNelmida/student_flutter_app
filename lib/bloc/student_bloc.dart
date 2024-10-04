import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/student_model.dart';
import '../repositories/student_repository.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository _studentRepository;

  StudentBloc(this._studentRepository) : super(StudentLoading()) {
    on<FetchStudents>(_onFetchStudents);
    on<CreateStudent>(_onCreateStudent);
    on<DeleteStudent>(_onDeleteStudent);
    on<UpdateStudent>(_onUpdateStudent);
  }

  Future<void> _onFetchStudents(FetchStudents event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      final students = await _studentRepository.fetchStudents();
      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onCreateStudent(CreateStudent event, Emitter<StudentState> emit) async {
    try {
      await _studentRepository.createStudent(event.student);
      add(FetchStudents()); // Refresh the list after creating a student
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onDeleteStudent(DeleteStudent event, Emitter<StudentState> emit) async {
    try {
      await _studentRepository.deleteStudent(event.id);
      add(FetchStudents()); // Refresh the list after deleting a student
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onUpdateStudent(UpdateStudent event, Emitter<StudentState> emit) async {
    try {
      await _studentRepository.updateStudent(event.id, event.student);
      add(FetchStudents()); // Refresh the list after updating a student
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }
}
