import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/api_services.dart';
import '../models/student.dart';

// Events
abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class AddStudent extends StudentEvent {
  final Student student;
  const AddStudent(this.student);

  @override
  List<Object> get props => [student];
}

class GetStudentList extends StudentEvent {
  final String schoolName, grade, division;
  const GetStudentList(this.schoolName, this.grade, this.division);

  @override
  List<Object> get props => [schoolName, grade, division];
}

// States
abstract class StudentState extends Equatable {
  const StudentState();
  
  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}
class StudentLoading extends StudentState {}
class StudentAdded extends StudentState {}
class StudentListLoaded extends StudentState {
  final List<Map<String, dynamic>> students;
  const StudentListLoaded(this.students);

  @override
  List<Object> get props => [students];
}
class StudentError extends StudentState {
  final String message;
  const StudentError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final ApiService _apiService;

  StudentBloc(this._apiService) : super(StudentInitial()) {
    on<AddStudent>((event, emit) async {
      emit(StudentLoading());
      final success = await _apiService.postStudentData(event.student);
      if (success) {
        emit(StudentAdded());
      } else {
        emit(const StudentError('Failed to add student'));
      }
    });

    on<GetStudentList>((event, emit) async {
      emit(StudentLoading());
      final students = await _apiService.getStudentList(
        event.schoolName, event.grade, event.division
      );
      emit(StudentListLoaded(students));
    });
  }
}