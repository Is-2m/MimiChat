import 'package:flutter/material.dart';

class Contactspage extends StatefulWidget {
  const Contactspage({super.key});

  @override
  State<Contactspage> createState() => _ContactspageState();
}

class _ContactspageState extends State<Contactspage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100], // Placeholder for contacts list
      child: Center(child: Text('Contacts')),
    );
  }
}