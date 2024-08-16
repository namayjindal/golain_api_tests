import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/student.dart';

class ApiService {
  late final Dio _dio;
  String _bearerToken = "";
  String orgId = "3bd435fe-a8f1-4673-bbff-b719b7d3b0a3";

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      headers: {
        'Org-ID': dotenv.env['ORG_ID']!,
        'Authorization': 'Bearer ${dotenv.env['BEARER_TOKEN']!}',
      },
    ));
  }

  void setUserToken(String token) {
    _bearerToken = token;
  }

  Future<bool> postStudentData(Student student) async {
    try {
      final response = await _dio.post('/post_student_data/', data: student.toJson());
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error posting student data: ${e.message}');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getStudentList(String schoolName, String grade, String division) async {
    try {
      final response = await _dio.get('/get_student_list/', queryParameters: {
        'school_name': schoolName,
        'grade': grade,
        'division': division,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['ok'] == 1) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('API returned ok: 0');
        }
      } else {
        throw Exception('Failed to load student list');
      }
    } on DioException catch (e) {
      print('Error getting student list: ${e.message}');
      return [];
    }
  }
}