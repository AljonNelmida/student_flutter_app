import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import 'student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  static const String baseUrl = 'https://aljon-student-api.vercel.app';

  @override
  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  @override
  Future<void> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create student');
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/students/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }

  @override
  Future<void> updateStudent(String id, Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/students/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }
}
