import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_element.dart';
import 'element.dart';
import '../database/firbase_data.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  CollectionReference elementRef =
      FirebaseFirestore.instance.collection('element');
  List<QueryDocumentSnapshot> searchResults = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> elementData =
                searchResults[index].data() as Map<String, dynamic>;

            return Card(
              child: ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Elements(
                        item: searchResults[index].id.toString(),
                      ),
                    ),
                  );
                },
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('العنوان: ${elementData['address']}'),
                    Text('نوع الخدمة: ${elementData['tyepServes']}'),
                    GestureDetector(
                      onTap: () {
                        launch('tel://${elementData['phon']}');
                      },
                      child: Text(
                        'رقم الهاتف: ${elementData['phon']}',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(elementData['name'].toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('حذف'),
                            content: Text(
                                'هل أنت متأكد من أنك تريد حذف هذا العنصر؟'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  MyFirebase().deleteData(
                                    'element',
                                    searchResults[index].id.toString(),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('موافق'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        EditElement(
                          item: searchResults[index].id.toString(),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder<QuerySnapshot>(
          stream: elementRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('حدث خطأ في جلب البيانات'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            searchResults.clear();

            snapshot.data!.docs.forEach((element) {
              Map<String, dynamic> elementData =
                  element.data() as Map<String, dynamic>;

              if (elementData['name'].toString().contains(query) ||
                  elementData['address'].toString().contains(query) ||
                  elementData['tyepServes'].toString().contains(query) ||
                  elementData['phon'].toString().contains(query) ||
                  elementData['date'].toString().contains(query) ||
                  elementData['note'].toString().contains(query)) {
                searchResults.add(element);
              }
            });

            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> elementData =
                    searchResults[index].data() as Map<String, dynamic>;

                return ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Elements(
                          item: searchResults[index].id.toString(),
                        ),
                      ),
                    );
                  },
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('العنوان: ${elementData['address']}'),
                      Text('نوع الخدمة: ${elementData['tyepServes']}'),
                      GestureDetector(
                        onTap: () {
                          launch('tel://${elementData['phon']}');
                        },
                        child: Text(
                          'رقم الهاتف: ${elementData['phon']}',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(elementData['name'].toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('حذف'),
                              content: Text(
                                  'هل أنت متأكد من أنك تريد حذف هذا العنصر؟'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    MyFirebase().deleteData(
                                      'element',
                                      searchResults[index].id.toString(),
                                    );
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('موافق'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          EditElement(
                            item: searchResults[index].id.toString(),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
