import 'package:flutter/material.dart';

import 'display_page.dart';

class UserFormPage extends StatefulWidget {
  final List<Map<String, dynamic>>? userList;
  final int? editingIndex;
  final Map<String, dynamic>? editingUser;

  UserFormPage({this.userList, this.editingIndex, this.editingUser});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final TextEditingController nameController = TextEditingController();
  String? gender;
  Map<String, bool> hobbies = {
    "Reading": false,
    "Sports": false,
    "Traveling": false,
  };

  List<Map<String, dynamic>> userList = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    if (widget.userList != null) {
      userList = widget.userList!;
    }

    if (widget.editingUser != null && widget.editingIndex != null) {
      isEditing = true;
      _loadUserDataForEditing();
    }
  }

  void _loadUserDataForEditing() {
    var user = widget.editingUser!;
    nameController.text = user["name"];
    gender = user["gender"];
    // hobbies.updateAll((key, value) => false);

    List<String> userHobbies = List<String>.from(user["hobbies"]);
    for (String hobby in userHobbies) {
      if (hobbies.containsKey(hobby)) {
        hobbies[hobby] = true;
      }
    }
  }

  void _addUser() {
    if (nameController.text.isNotEmpty) {
      setState(() {
        userList.add({
          "name": nameController.text,
          "gender": gender,
          "hobbies":
              hobbies.entries.where((e) => e.value).map((e) => e.key).toList(),
        });
        nameController.clear();
        hobbies.updateAll((key, value) => false);
        gender = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPage(userList: userList),
          ),
        );
      });
    } else {
      print('PLS ENTER DATA');
    }
  }

  void _updateUser() {
    if (nameController.text.isNotEmpty && widget.editingIndex != null) {
      setState(() {
        userList[widget.editingIndex!] = {
          "name": nameController.text,
          "gender": gender,
          "hobbies":
              hobbies.entries.where((e) => e.value).map((e) => e.key).toList(),
        };
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPage(userList: userList),
          ),
        );
      });
    } else {
      print('PLS ENTER DATA');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit User" : "CRUD Form")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text("Gender: "),
                Radio<String>(
                  value: "Male",
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = val ?? "";
                    });
                  },
                ),
                Text("Male"),
                Radio<String>(
                  value: "Female",
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = val ?? "";
                    });
                  },
                ),
                Text("Female"),
              ],
            ),
            Column(
              children:
                  hobbies.keys.map((hobby) {
                    return CheckboxListTile(
                      title: Text(hobby),
                      value: hobbies[hobby],
                      onChanged: (val) {
                        setState(() => hobbies[hobby] = val!);
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isEditing ? _updateUser : _addUser,
              child: Text(isEditing ? "Update User" : "Add User"),
            ),
            const SizedBox(height: 20),
            // const Text("Temporary List (In This Page)"),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: userList.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text(userList[index]["name"]),
            //         subtitle: Text(
            //             "${userList[index]["gender"]}, ${userList[index]["hobbies"].join(", ")}"),
            //         trailing: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             IconButton(
            //               icon: const Icon(Icons.edit),
            //               onPressed: () => _editUser(index),
            //             ),
            //             IconButton(
            //               icon: const Icon(Icons.delete),
            //               onPressed: () => _deleteUser(index),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
