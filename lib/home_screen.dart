// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hive/boxes/boxes.dart';
import 'package:flutter_hive/model/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App Using Hive'),
        backgroundColor: Colors.blue.shade300,
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data[index].title.toString()),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                _editDialog(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString());
                              },
                              child: Icon(Icons.edit)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          InkWell(
                            onTap: () {
                              delete(data[index]);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Text(data[index].description.toString()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          title: Text('Add Notes'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'),
            ),
            TextButton(
              onPressed: () {
                final data = NotesModel(
                    title: titleController.text,
                    description: descriptionController.text);
                Navigator.pop(context);

                final box = Boxes.getData();
                box.add(data);

                data.save();
                titleController.clear();
                descriptionController.clear();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          title: Text('Add Notes'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'),
            ),
            TextButton(
              onPressed: () {
                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();
                notesModel.save();
                titleController.clear();
                descriptionController.clear();
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }
}
