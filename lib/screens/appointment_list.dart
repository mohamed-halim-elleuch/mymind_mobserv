import 'package:flutter/material.dart';
import 'package:mymind_mobserv/models/appointment.dart';


class AppointmentListScreen extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentListScreen({Key? key, required this.appointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: appointments.isEmpty
          ? const Center(
              child: Text('No appointments available.'),
            )
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text('Doctor: ${appointment.doctor.name}'),
                  subtitle: Text('Date and Time: ${appointment.dateTime.toString()}'),
                  // Add more information as needed
                );
              },
            ),
    );
  }
}
