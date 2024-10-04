import 'package:equatable/equatable.dart';
import '../models/student_model.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class FetchStudents extends StudentEvent {}

class CreateStudent extends StudentEvent {
  final Student student;

  const CreateStudent(this.student);

  @override
  List<Object?> get props => [student];
}

class DeleteStudent extends StudentEvent {
  final String id;

  const DeleteStudent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateStudent extends StudentEvent {
  final String id;
  final Student student;

  const UpdateStudent(this.id, this.student);

  @override
  List<Object?> get props => [id, student];
}
