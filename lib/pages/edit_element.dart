import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/firbase_data.dart';

class EditElement extends StatefulWidget {
  const EditElement({super.key, required this.item});
  final String item;
  @override
  State<EditElement> createState() => _EditElementState();
}

class _EditElementState extends State<EditElement> {
  String? name;
  String? date;
  String? address;
  String? typeServes;
  String? phone;
  String? note;
  // ignore: prefer_typing_uninitialized_variables
  var selectedItem;
  CollectionReference noteref =
      FirebaseFirestore.instance.collection('element');
  void strat() async {
    var selectedItem = await noteref.doc(widget.item).get();
    name = (selectedItem.data() as Map)['name'];
    date = (selectedItem.data() as Map)['date'];
    address = (selectedItem.data() as Map)['address'];
    typeServes = (selectedItem.data() as Map)['typeServes'];
    phone = (selectedItem.data() as Map)['phon'];
    note = (selectedItem.data() as Map)['note'];
  }

  @override
  void initState() {
    strat();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
          return StreamBuilder(
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
                return AlertDialog(
                  title: const Text('تعديل العنصر'),
                  content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: (selectedItem.data() as Map)['name'],
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'اسم',
                          ),
                        ),
                        TextFormField(
                          initialValue: (selectedItem.data() as Map)['date'],
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'التاريخ',
                          ),
                        ),
                        TextFormField(
                          initialValue: (selectedItem.data() as Map)['address'],
                          onChanged: (value) {
                            setState(() {
                              address = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'العنوان',
                          ),
                        ),
                        TextFormField(
                          initialValue:
                              (selectedItem.data() as Map)['typeServes'],
                          onChanged: (value) {
                            setState(() {
                              typeServes = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'نوع الخدمة',
                          ),
                        ),
                        TextFormField(
                          initialValue: (selectedItem.data() as Map)['phone'],
                          onChanged: (value) {
                            setState(() {
                              phone = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف',
                          ),
                        ),
                        TextFormField(
                          initialValue: (selectedItem.data() as Map)['note'],
                          onChanged: (value) {
                            setState(() {
                              phone = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "الملاحضة",
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        // تنفيذ التعديل على البيانات هنا
                        // بعد الانتهاء من التعديل، يمكنك إغلاق مربع الحوار

                        MyFirebase().updateData("element", widget.item, {
                          'name': name,
                          'date': date,
                          'address': address,
                          'typeServes': typeServes,
                          'phone': phone,
                          'note': note
                        });

                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text('حفظ التعديل'),
                    ),
                  ],
                );
              }
              return Center(child: const Text("لايوجد بيانات"));
            },
          );
        })));
  }
}
