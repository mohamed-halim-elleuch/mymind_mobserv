// Example using the `flutter_datetime_picker` package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mymind_mobserv/models/appointment.dart';
import 'package:mymind_mobserv/models/user.dart';
import 'package:mymind_mobserv/services/doctor_services.dart';

DateTime selectedDateTime = DateTime.now();

/*void _selectDateTime() async {
  DateTime picked = await showDatePicker(
    context: context,
    initialDate: selectedDateTime,
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
  );

  if (picked != null && picked != selectedDateTime) {
    setState(() {
      selectedDateTime = picked;
    });
  }
}*/

// Example using Firestore
class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<List<Appointment>> getUserAppointments(User user) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('appointments')
        .where('userId', isEqualTo: user.id)
        .get();

    List<Appointment> appointments = [];
    DoctorService doctorService = DoctorService();
    for (var document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      appointments.add(Appointment(
        id: document.id,
        dateTime: data['dateTime'].toDate(),
        doctor: await doctorService.getDoctorById(data['doctorId']), // Assuming you have a getDoctorById function
        user: user, 
        location: '',
      ));
    }
return appointments;
  }
  

  Future<void> saveAppointment(Appointment appointment) async {
    await _firestore.collection('appointments').add({
    'dateTime': appointment.dateTime,
    'doctorId': appointment.doctor.id,
    'userId': appointment.user.id,
  });
}
}