class Student {
  final String schoolName;
  final String grade;
  final String division;
  final String studentName;
  final String rollNo;

  Student({
    required this.schoolName,
    required this.grade,
    required this.division,
    required this.studentName,
    required this.rollNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'grade': grade,
      'division': division,
      'student_name': studentName,
      'roll_no': rollNo,
    };
  }
}