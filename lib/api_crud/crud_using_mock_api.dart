import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentCrudPageApi extends StatefulWidget {
  @override
  _StudentCrudPageApiState createState() => _StudentCrudPageApiState();
}

class _StudentCrudPageApiState extends State<StudentCrudPageApi> {
  final TextEditingController nameController = TextEditingController();
  String gender = "Male";
  bool hobbyCricket = false, hobbyMusic = false, hobbyReading = false;

  List students = [];
  String? editId;

  final String baseUrl =
      "https://67c5368cc4649b9551b5aa00.mockapi.io/mmony/temp";

  Future<void> getStudents() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        setState(() {
          students = json.decode(res.body);
        });
      } else {
        print("GET failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error in getStudents: $e");
    }
  }

  Future<void> addStudent(Map data) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await getStudents();
      } else {
        print("POST failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error in addStudent: $e");
    }
  }

  Future<void> updateStudent(String id, Map data) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        await getStudents();
      } else {
        print("PUT failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error in updateStudent: $e");
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));

      if (res.statusCode == 200) {
        await getStudents();
      } else {
        print("DELETE failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error in deleteStudent: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Form (API CRUD)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            Row(
              children: [
                Text("Gender: "),
                Radio<String>(
                  value: "Male",
                  groupValue: gender,
                  onChanged: (val) => setState(() => gender = val!),
                ),
                Text("Male"),
                Radio<String>(
                  value: "Female",
                  groupValue: gender,
                  onChanged: (val) => setState(() => gender = val!),
                ),
                Text("Female"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: hobbyCricket,
                  onChanged:
                      (val) => setState(() => hobbyCricket = val ?? false),
                ),
                Text("Cricket"),
                Checkbox(
                  value: hobbyMusic,
                  onChanged: (val) => setState(() => hobbyMusic = val ?? false),
                ),
                Text("Music"),
                Checkbox(
                  value: hobbyReading,
                  onChanged:
                      (val) => setState(() => hobbyReading = val ?? false),
                ),
                Text("Reading"),
              ],
            ),

            //add student
            ElevatedButton(
              onPressed: () async {
                String hobbies = "";
                if (hobbyCricket) hobbies += "Cricket, ";
                if (hobbyMusic) hobbies += "Music, ";
                if (hobbyReading) hobbies += "Reading, ";
                if (hobbies.isNotEmpty)
                  hobbies = hobbies.substring(0, hobbies.length - 2);

                Map<String, dynamic> student = {
                  "name": nameController.text,
                  "gender": gender,
                  "hobbies": hobbies,
                };

                if (editId == null) {
                  await addStudent(student);
                } else {
                  await updateStudent(editId.toString(), student);
                  editId = null;
                }

                nameController.clear();
                gender = "Male";
                hobbyCricket = hobbyMusic = hobbyReading = false;

                setState(() {});
              },
              child: Text(editId == null ? "Add Student" : "Update Student"),
            ),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    title: Text(student["name"]),
                    subtitle: Text(
                      "Gender: ${student["gender"]}, Hobbies: ${student["hobbies"]}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //edit
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            nameController.text = student["name"];
                            gender = student["gender"];
                            hobbyCricket = student["hobbies"]
                                .toString()
                                .contains("Cricket");
                            hobbyMusic = student["hobbies"].toString().contains(
                              "Music",
                            );
                            hobbyReading = student["hobbies"]
                                .toString()
                                .contains("Reading");
                            editId = student["id"].toString();
                            await updateStudent(editId!, {
                              "name": nameController.text,
                              "gender": gender,
                              "hobbies": [
                                if (hobbyCricket) "Cricket",
                                if (hobbyMusic) "Music",
                                if (hobbyReading) "Reading",
                              ],
                            });
                            setState(() {});
                          },
                        ),

                        //delete
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteStudent(student["id"].toString());
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
