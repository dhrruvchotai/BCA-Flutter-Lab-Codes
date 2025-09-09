import 'package:bca_flutter_lab_solution/database_crud/crud_database_helper.dart';
import 'package:flutter/material.dart';

class StudentCrudPage extends StatefulWidget {
  @override
  _StudentCrudPageState createState() => _StudentCrudPageState();
}

class _StudentCrudPageState extends State<StudentCrudPage> {
  final TextEditingController nameController = TextEditingController();
  String gender = "Male";
  bool hobbyCricket = false;
  bool hobbyMusic = false;
  bool hobbyReading = false;
  CrudDatabaseHelper db = CrudDatabaseHelper();
  List<Map<String, dynamic>> students = [];
  int? editId; // for update

  @override
  void initState() {
    super.initState();
    db.initDB().then((_) => loadData());
  }

  void loadData() async {
    students = await db.getStudents();
    setState(() {});
  }

  void saveStudent() async {
    String hobbies = "";
    if (hobbyCricket) hobbies += "Cricket, ";
    if (hobbyMusic) hobbies += "Music, ";
    if (hobbyReading) hobbies += "Reading, ";
    if (hobbies.isNotEmpty) {
      hobbies = hobbies.substring(0, hobbies.length - 2);
    }

    if (editId == null) {
      // Insert
      await db.insertStudent({
        "name": nameController.text,
        "gender": gender,
        "hobbies": hobbies,
      });
    } else {
      // Update
      await db.updateStudent(editId!, {
        "name": nameController.text,
        "gender": gender,
        "hobbies": hobbies,
      });
      editId = null;
    }

    clearForm();
    loadData();
  }

  void clearForm() {
    nameController.clear();
    gender = "Male";
    hobbyCricket = hobbyMusic = hobbyReading = false;
    setState(() {});
  }

  void deleteStudent(int id) async {
    await db.deleteStudent(id);
    loadData();
  }

  void editStudent(Map<String, dynamic> student) {
    nameController.text = student["name"];
    gender = student["gender"];
    hobbyCricket = student["hobbies"].contains("Cricket");
    hobbyMusic = student["hobbies"].contains("Music");
    hobbyReading = student["hobbies"].contains("Reading");
    editId = student["id"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Form")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Name input
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),

            // Gender (Radio)
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

            // Hobbies (Checkboxes)
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

            // Save Button
            ElevatedButton(
              onPressed: saveStudent,
              child: Text(editId == null ? "Add Student" : "Update Student"),
            ),

            SizedBox(height: 20),

            // List of students
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
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => editStudent(student),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteStudent(student["id"]),
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
