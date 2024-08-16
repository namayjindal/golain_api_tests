import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/student_bloc.dart';

class StudentListForm extends StatefulWidget {
  @override
  _StudentListFormState createState() => _StudentListFormState();
}

class _StudentListFormState extends State<StudentListForm> {
  final _formKey = GlobalKey<FormState>();

  String _schoolName = '';
  String _grade = '';
  String _division = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<StudentBloc>().add(GetStudentList(_schoolName, _grade, _division));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Get Student List'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<StudentBloc, StudentState>(
            builder: (context, state) {
              if (state is StudentLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is StudentListLoaded) {
                return ListView.builder(
                  itemCount: state.students.length,
                  itemBuilder: (context, index) {
                    final student = state.students[index];
                    return ListTile(
                      title: Text(student['student_name']),
                      subtitle: Text('Roll No: ${student['roll_no']}'),
                    );
                  },
                );
              } else if (state is StudentError) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text('Submit the form to get student list'));
            },
          ),
        ),
      ],
    );
  }
}