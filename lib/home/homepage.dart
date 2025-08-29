import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final contacts = Hive.box('contacts'); 

  int get favouriteCount {
    return contacts.values
        .where((c) =>
            c is Map && c['isFavourite'] == true)
        .length;
        }
        List get recentContacts{
          return contacts.values.toList().reversed.take(3).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Contacts',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contacts.length.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Favourites',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        favouriteCount.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Recent Contacts",style: TextStyle(
              fontSize: 18,
              fontWeight:FontWeight.bold,
              color: Colors.black
            ),),
            SizedBox(height: 10),
            Expanded(child:recentContacts.isEmpty
            ?Center(
              child: Text(
                'No Recent Contacts',
                style: TextStyle(color: Colors.black)
              )
              )
              :ListView.builder(itemCount:recentContacts.length,
               itemBuilder:(context,index){
                 final contact = recentContacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              contact['name'][0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(contact['name']),
                          subtitle: Text(contact['phone']),
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
