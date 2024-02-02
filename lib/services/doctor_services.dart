import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mymind_mobserv/models/doctor.dart';


class DoctorService {
Future<Doctor> getDoctorById(String doctorId) async {
  // Assuming you have a 'doctors' collection in Firestore
  DocumentSnapshot doctorSnapshot =
      await FirebaseFirestore.instance.collection('doctors').doc(doctorId).get();

  
    Map<String, dynamic> doctorData = doctorSnapshot.data() as Map<String, dynamic>;

    // You may need to replace 'id', 'name', and 'specialty' with your actual field names
    Doctor doctor = Doctor(
      id: doctorId,
      name: doctorData['name'],
      specialization: doctorData['specialty'], 
      // Add other fields as needed
    );

    return doctor;

}

}
