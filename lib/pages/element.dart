import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_element.dart';
import '../database/firbase_data.dart';

class Elements extends StatefulWidget {
  final String? item;

  const Elements({super.key, this.item});

  @override
  State<Elements> createState() => _ElementState();
}

class _ElementState extends State<Elements> {
  String? name;
  String? date;
  String? address;
  String? typeServes;
  String? phone;
  String? note;
  CollectionReference noteref =
      FirebaseFirestore.instance.collection('element');
  void fetchData() async {
    var selectedItem = await noteref.doc(widget.item).get();
    setState(() {
      name = (selectedItem.data() as Map)['name'];
      date = (selectedItem.data() as Map)['date'];
      address = (selectedItem.data() as Map)['address'];
      typeServes = (selectedItem.data() as Map)['typeServes'];
      phone = (selectedItem.data() as Map)['phon'];
      note = (selectedItem.data() as Map)['note'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text("العنصر"),
            ),
            body: StreamBuilder(
                stream: noteref.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("خطأ في جلب البيانات"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            initialValue: name,
                            decoration: const InputDecoration(
                              labelText: 'اسم',
                            ),
                          ),
                          TextFormField(
                            initialValue: date,
                            decoration: const InputDecoration(
                              labelText: 'التاريخ',
                            ),
                          ),
                          TextFormField(
                            initialValue: address,
                            decoration: const InputDecoration(
                              labelText: 'العنوان',
                            ),
                          ),
                          TextFormField(
                            initialValue: typeServes,
                            decoration: const InputDecoration(
                              labelText: 'نوع الخدمة',
                            ),
                          ),
                          TextFormField(
                            initialValue: phone,
                            decoration: const InputDecoration(
                              labelText: 'رقم الهاتف',
                            ),
                          ),
                          TextFormField(
                            initialValue: note,
                            decoration: const InputDecoration(
                              labelText: "الملاحظة",
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: Text(
                                              'حذف',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            content: Text(
                                                "هل أنت متأكد من أنك ـريد حذف هذا العنصر"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  MyFirebase().deleteData(
                                                      'element',
                                                      widget.item.toString());
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Text('موافق'),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => EditElement(
                                            item: widget.item.toString()));
                                  },
                                  child: const Icon(Icons.edit)),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                  return Center(child: const Text("لايوجد بيانات"));
                })));
  }
}
