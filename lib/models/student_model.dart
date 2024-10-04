import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String course;
  final int year;
  final bool enrolled;

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    this.enrolled = true,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      course: json['course'] as String,
      year: json['year'] as int,
      enrolled: json['enrolled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'year': year,
      'enrolled': enrolled,
    };
  }

  @override
  List<Object?> get props => [id, firstName, lastName, course, year, enrolled];
}
