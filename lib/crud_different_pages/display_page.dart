import 'package:bca_flutter_lab_codes/crud_different_pages/user_form_page.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
  final List<Map<String, dynamic>> userList;
  const DisplayPage({super.key, required this.userList});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  final TextEditingController nameController = TextEditingController();

  String? gender;

  Map<String, bool> hobbies = {
    "Reading": false,
    "Sports": false,
    "Traveling": false,
  };

  void _editUser(int index) {
    var user = widget.userList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => UserFormPage(
              userList: widget.userList,
              editingIndex: index,
              editingUser: user,
            ),
      ),
    );
    setState(() {});
  }

  void _deleteUser(int index) {
    setState(() {
      widget.userList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Users")),
      body: ListView.builder(
        itemCount: widget.userList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(widget.userList[index]["name"]),
            subtitle: Text(
              "${widget.userList[index]["gender"]} | ${widget.userList[index]["hobbies"].join(", ")}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editUser(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserFormPage(userList: widget.userList),
            ),
          ).then((result) {
            if (result == true) {
              setState(() {});
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
