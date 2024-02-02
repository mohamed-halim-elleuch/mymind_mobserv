import 'package:mymind_mobserv/models/doctor.dart';
import 'user.dart';

class Appointment {
  final String id;
  final DateTime dateTime;
  final String location;
  final Doctor doctor;
  final User user;

  Appointment({required this.id, required this.dateTime,required this.location, required this.doctor, required this.user});
}