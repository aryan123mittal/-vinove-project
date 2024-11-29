import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading asset files
import 'location_screen.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> employees = [];
  bool _showAllEmployees = false;

  // Function to load employees from the JSON file
  Future<void> loadEmployeeData() async {
    final String response = await rootBundle.loadString('assets/employees.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      employees = data.map((item) => item as Map<String, dynamic>).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadEmployeeData(); // Load data when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    // Filter employees based on the toggle state
    List<Map<String, dynamic>> filteredEmployees = _showAllEmployees
        ? employees
        : employees.where((employee) => employee["attendance"] == "Present").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        actions: [
          IconButton(
            icon: Icon(Icons.view_list),
            onPressed: () {
              setState(() {
                _showAllEmployees = !_showAllEmployees; // Toggle between present and all employees
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredEmployees.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(filteredEmployees[index]["image"]),
            ),
            title: Text(filteredEmployees[index]["name"]),
            subtitle: Text('Attendance: ${filteredEmployees[index]["attendance"]}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to LocationScreen with employee data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationScreen(
                    name: filteredEmployees[index]["name"],
                    latitude: filteredEmployees[index]["location"]["lat"],
                    longitude: filteredEmployees[index]["location"]["lng"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
