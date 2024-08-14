import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:the_water/pages/add_new_item.dart';
import 'package:the_water/pages/edit_element.dart';
import 'package:the_water/pages/element.dart';
import 'package:the_water/database/firbase_data.dart';
import 'package:the_water/notefications.dart';
import 'package:the_water/pages/search.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  CollectionReference elementRef =
      FirebaseFirestore.instance.collection('element');
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> searchResults = [];
  AudioCache audioCache = AudioCache();
  @override
  void initState() {
    NotificationManager();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 35,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: elementRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('حدث خطأ في جلب البيانات'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<DateTime, List<QueryDocumentSnapshot>> elementsByDay = {};

          for (var element in snapshot.data!.docs) {
            String elementDateStr = (element.data() as Map)['date'].toString();
            DateFormat format = DateFormat("yyyy/MM/dd");
            DateTime elementDate = format.parse(elementDateStr);
            DateTime elementDay =
                DateTime(elementDate.year, elementDate.month, elementDate.day);

            if (!elementsByDay.containsKey(elementDay)) {
              elementsByDay[elementDay] = [];
            }

            elementsByDay[elementDay]!.add(element);
          }

          if (elementsByDay.isEmpty) {
            return const Center(
              child: Text('لا يوجد عناصر مسجلة'),
            );
          }

          List<DateTime> sortedDays = elementsByDay.keys.toList();
          sortedDays.sort((a, b) => b.compareTo(a));

          return ListView.builder(
            itemCount: sortedDays.length,
            itemBuilder: (context, index) {
              DateTime day = sortedDays[index];
              List<QueryDocumentSnapshot> elements = elementsByDay[day]!;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${day.year}/${day.month}/${day.day}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: elements.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> elementData =
                          elements[index].data() as Map<String, dynamic>;

                      // Check if the notification should be triggered
                      DateTime currentDate = DateTime.now();
                      String elementDateStr = elementData['date'];
                      List<String> dateParts = elementDateStr.split('/');
                      int year = int.parse(dateParts[0]);
                      int month = int.parse(dateParts[1]);
                      int day = int.parse(dateParts[2]);

                      DateTime elementCreatedDate = DateTime(year, month, day);

                      Duration difference =
                          currentDate.difference(elementCreatedDate);
                      if (difference.inHours >= 1) {
                        // Play sound notification
                        audioCache.load('slow_spring_board.mp3');
                        // Update the element's notification status
                        elementRef
                            .doc(elements[index].id)
                            .update({'notified': true});
                      }

                      return Card(
                        borderOnForeground: true,
                        child: ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Elements(
                                  item: elements[index].id.toString(),
                                ),
                              ),
                            );
                          },
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'العنوان: ${elementData['address']}',
                                  ),
                                  Text(
                                      'نوع الخدمة: ${elementData['tyepServes']}'),
                                  Text(
                                    'الملاحظة: ${elementData['note']}',
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // ignore: deprecated_member_use
                                      launch('tel://${elementData['phon']}');
                                    },
                                    child: Text(
                                      'رقم الهاتف: ${elementData['phon']}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        // decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text(
                                            'حذف',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: const Text(
                                              'هل أنت متأكد من أنك تريد حذف هذا العنصر؟'),
                                          actions: [
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  MyFirebase().deleteData(
                                                    'element',
                                                    elements[index]
                                                        .id
                                                        .toString(),
                                                  );
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text('موافق'),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      EditElement(
                                        item: elements[index].id.toString(),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                elementData['name'].toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(elementData['date'].toString())
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItem()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
