import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/student_form.dart';
import '../widgets/student_list_form.dart';
import '../blocs/student_bloc.dart';
import '../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAddingStudent = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentBloc(ApiService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isAddingStudent ? 'Add Student' : 'Get Student List'),
        ),
        body: _isAddingStudent ? StudentForm() : StudentListForm(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isAddingStudent = !_isAddingStudent;
            });
          },
          child: Icon(_isAddingStudent ? Icons.list : Icons.add),
        ),
      ),
    );
  }
}