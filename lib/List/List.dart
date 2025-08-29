import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final Box contactsBox;

  @override
  void initState() {
    super.initState();
    contactsBox = Hive.box('contacts');
  }
  void addContact() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                contactsBox.add({
                  "name": nameController.text,
                  "phone": phoneController.text,
                  "isFavourite": false
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
  void editContact(int index, Map contact) {
    final nameController = TextEditingController(text: contact["name"]);
    final phoneController = TextEditingController(text: contact["phone"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              contactsBox.putAt(index, {
                "name": nameController.text,
                "phone": phoneController.text,
                "isFavourite": contact["isFavourite"]
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
  void deleteContact(int index) {
    contactsBox.deleteAt(index);
  }
  void toggleFavourite(int index, Map contact) {
    contactsBox.putAt(index, {
      "name": contact["name"],
      "phone": contact["phone"],
      "isFavourite": !(contact["isFavourite"] ?? false),
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LISTS"),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: "All Contacts"),
              Tab(text: "Favourites"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ValueListenableBuilder(
              valueListenable: contactsBox.listenable(),
              builder: (context, box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text("No contacts yet"));
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final contact = box.getAt(index) as Map;
                    final name = contact["name"];
                    final phone = contact["phone"];
                    final isFav = contact["isFavourite"] ?? false;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(name),
                      subtitle: Text(phone),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : null,
                            ),
                            onPressed: () => toggleFavourite(index, contact),
                          ),
                          PopupMenuButton(
                            onSelected: (value) {
                              if (value == "edit") {
                                editContact(index, contact);
                              } else if (value == "delete") {
                                deleteContact(index);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: "edit",
                                child: Text("Edit"),
                              ),
                              const PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: contactsBox.listenable(),
              builder: (context, box, _) {
                final favourites = box.values
                    .where((c) => (c as Map)["isFavourite"] == true)
                    .toList();
                if (favourites.isEmpty) {
                  return const Center(child: Text("No favourites yet"));
                }
                return ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, i) {
                    final contact = favourites[i] as Map;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(contact["name"][0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(contact["name"]),
                      subtitle: Text(contact["phone"]),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addContact,
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
