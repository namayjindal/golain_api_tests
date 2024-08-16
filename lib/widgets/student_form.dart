import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/student.dart';
import '../blocs/student_bloc.dart';

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();

  String _schoolName = '';
  String _grade = '';
  String _division = '';
  String _studentName = '';
  String _rollNo = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final student = Student(
        schoolName: _schoolName,
        grade: _grade,
        division: _division,
        studentName: _studentName,
        rollNo: _rollNo,
      );

      context.read<StudentBloc>().add(AddStudent(student));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is StudentAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student added successfully')),
          );
        } else if (state is StudentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'School Name'),
              validator: (value) => value!.isEmpty ? 'Please enter school name' : null,
              onSaved: (value) => _schoolName = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Grade'),
              validator: (value) => value!.isEmpty ? 'Please enter grade' : null,
              onSaved: (value) => _grade = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Division'),
              validator: (value) => value!.isEmpty ? 'Please enter division' : null,
              onSaved: (value) => _division = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Student Name'),
              validator: (value) => value!.isEmpty ? 'Please enter student name' : null,
              onSaved: (value) => _studentName = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Roll Number'),
              validator: (value) => value!.isEmpty ? 'Please enter roll number' : null,
              onSaved: (value) => _rollNo = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}